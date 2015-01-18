# Invokes `kitchen` in a Bundler context if a `Gemfile` is present in the
# current working directory.
kitchen () {
  if [ -e Gemfile ] && grep "test-kitchen" Gemfile > /dev/null; then
    bundle exec kitchen "$@"
  else
    kitchen "$@"
  fi
}
