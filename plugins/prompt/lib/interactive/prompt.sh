# Runs after a command is executed (or interrupted),
# before the prompt is rendered for the next command.
precmd() {
  # Display exit code if non-zero
  local last_cmd_status=$?
  if [ ! $last_cmd_status -eq 0 ]; then
    echo -e "\033[0;31m→ exit status: $last_cmd_status\033[0m" >&2
  fi

  # Update terminal title bar if one is available
  if [[ "$TERM" =~ xterm* ]]; then
    echo -en "\033]0;$USER@$(hostname):$(__prompt_curdir)\007"
  fi
}

active_git_branch() {
  local ref="$(git symbolic-ref HEAD 2> /dev/null)"
  echo "${ref#refs/heads/}"
}

git_branch_ahead() {
  local branch="$(active_git_branch)"
  (git log origin/$branch..HEAD 2>/dev/null | grep '^commit' >/dev/null 2>&1) \
    && echo '➨'
}

# Prompt escape variables differ between shells, so use functions instead
__prompt_curdir() {
  echo "${PWD/#$HOME/~}"
}

# Display the currently git branch and status if we're in a git repository
__git_prompt() {
  local branch="$(active_git_branch)"
  if [ ! -z "$branch" ]; then
    echo " $(git_branch_ahead)$branch"
  else
    echo ""
  fi
}

# Stops bash/zsh from counting escape sequences as characters.
# This prevents the PS1 prompt causing long commands to overflow the terminal
case "$DOT_SHELL" in
  bash)
    prefix='\['
    suffix='\]'
    ;;
  zsh)
    prefix='%{'
    suffix='%}'
    ;;
  *)
    prefix=''
    suffix=''
    ;;
esac

prompt_reset="$prefix[00m$suffix"
dark_gray="$prefix[38;5;234m$suffix"
gray="$prefix[38;5;240m$suffix"
light_gray="$prefix[38;5;245m$suffix"
blue="$prefix[38;5;33m$suffix"
green="$prefix[38;5;64m$suffix"
orange="$prefix[38;5;136m$suffix"

# Main prompt line
PS1="${prompt_reset}${gray}\$USER${prompt_reset}"
PS1="${PS1}${dark_gray}@${light_gray}\$(hostname -s)${prompt_reset}"
PS1="${PS1}${dark_gray}:${orange}\$(__prompt_curdir)${prompt_reset}"
PS1="${PS1}${green}\$(__git_prompt)${prompt_reset}"
PS1="${PS1}
${blue}⨠ ${prompt_reset}"

# Prompt to display at beginning of next line when command spans multiple lines
PS2="${blue}↳${prompt_reset} "
