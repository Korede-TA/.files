# Initializes the Dot environment by defining global variables, utility
# functions, and other settings.

# Useful variables for plugin setup
export DOTLOGDIR="$DOTDIR/log"
export DOTTMPDIR="$DOTDIR/tmp"
export DOTPLUGINSDIR="$DOTDIR/plugins"

# Prefer applications from HOME bin
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Returns a string representing the shell running this script
current_shell() {
  local shell=sh

  if [ -n "$BASH_VERSION" ]; then
    shell=bash
  elif [ -n "$ZSH_VERSION" ]; then
    shell=zsh
  fi

  echo "$shell"
}

# Sets an alias safely, printing an error if alias is already in use.
alias() {
  local mapping=$1

  # Redirect to builtin behaviour if no mapping provided
  if [ -z "$mapping" ]; then
    builtin alias "$@"
    return $?
  fi

  local alias_name=`echo $mapping | cut -d'=' -f 1`

  if [ -z "`builtin alias $alias_name 2>/dev/null`" ]; then
    builtin alias "$@"
  else
    echo "Error: $alias_name already aliased to `builtin alias $alias_name`"
    return 1
  fi
}

# Ignore any previous alias mappings in certain cases
# (so we don't get a warning on startup of an alias already existing)
forcealias() {
  builtin alias "$@"
}

# Return whether a function with the given name has been defined in the current
# shell.
function_defined() {
  local func=$1

  case `current_shell` in
    zsh)
      functions $func > /dev/null ;;
    *)
      [ "$(type -t $func)" = "function" ] ;;
  esac
}

# Return whether executable is recognized (i.e. is in the system path)
in_path() {
  command -v $1 >/dev/null 2>&1
}

# Print words from string onto separate lines
words() {
  echo "$@" | tr -s " " "\012"
}

# Make working with colour escape codes easier
init_dot_colours() {
  local prefix=''
  local suffix=''
  local shell=`current_shell`

  # Stops bash/zsh from counting escape sequences as characters.
  # This prevents the PS1 prompt from counting
  case "$shell" in
    bash)
      prefix='\['
      suffix='\]'
      ;;
    zsh)
      prefix='%{'
      suffix='%}'
  esac

  # Escape sequence for prompts
  PRESET="$prefix[00m$suffix"
  PBOLD="$prefix[01m$suffix"
  PITALIC="$prefix[03m$suffix"
  PUNDERLINE="$prefix[04m$suffix"
  PBLINK="$prefix[05m$suffix"
  PREVERSE="$prefix[07m$suffix"
  PSTARTLINE=""

  RESET="[00m"
  BOLD="[01m"
  ITALIC="[03m"
  UNDERLINE="[04m"
  BLINK="[05m"
  REVERSE="[07m"

  if [ `current_shell` = zsh ]; then
    typeset -Ag FG BG PFG PBG
  fi

  for color in {0..255}; do
    FG[$color]="[38;5;${color}m"
    BG[$color]="[48;5;${color}m"
    PFG[$color]="$prefix[38;5;${color}m$suffix"
    PBG[$color]="$prefix[48;5;${color}m$suffix"
  done

  colours() {
    for code in {0..255}; do
      printf "${reset}${FG[$code]}%03s: The quick brown fox jumped over the lazy dog\n" "$code"
    done
  }
  alias colors=colours
}
