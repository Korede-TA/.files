# Excerpt taken from the output of `rbenv init - fish`
# We explicitly define this so the rehash/shell commands work, while at the same
# time avoiding:
# - Adding the shims directory to the PATH again (it was already added on login)
# - Sourcing completions
# - Performing a rehash
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (rbenv "sh-$command" $argv|psub)
  case '*'
    command rbenv "$command" $argv
  end
end
