# Append to history file after each command
# (so we don't lose history on disconnect/crash)
export PROMPT_COMMAND="$PROMPT_COMMAND; history -a"

# Always append to bash history file (don't overwrite)
shopt -s histappend

# Don't remember commands with a leading space
# (useful for hiding sensitive arguments like passwords).
# Also ignore duplicate commands
export HISTCONTROL=ignorespace:ignoredups
