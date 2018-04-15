# Excerpt taken from the output of `rbenv init -`
# We explicitly define this so the rehash/shell commands work, while at the same
# time avoiding:
# - Adding the shims directory to the PATH again (it was already added on login)
# - Sourcing completions
# - Performing a rehash
rbenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}
