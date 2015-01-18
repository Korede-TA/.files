# Invokes `knife` in a Bundler context if a `Gemfile` is present in the current
# working directory.
berks () {
  if [ -e Berksfile ]; then
    bundle exec berks "$@"
  else
    command berks "$@"
  fi
}
