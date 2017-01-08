# Append to history file after each command
# (so we don't lose history on disconnect/crash)
export PROMPT_COMMAND="$PROMPT_COMMAND; history -a"

# Always append to bash history file (don't overwrite)
shopt -s histappend
