# Invokes `knife` in a Bundler context if a `Gemfile` is present in the current
# working directory.
k () {
  if [ -e Gemfile ] && grep "chef" Gemfile > /dev/null; then
    bundle exec knife "$@"
  else
    knife "$@"
  fi
}
