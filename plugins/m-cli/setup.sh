setup () {
  repo "git@github.com:rgcr/m-cli.git" "$DOTPLUGIN/.m-cli"
  symlink "$HOME/bin/m" "$DOTPLUGIN/.m-cli/m"
}
