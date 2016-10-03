setup () {
  if [ `uname` = Darwin ]; then
    formula git
  fi

  # TODO: use XDG helper
  mkdir -p "$XDG_CONFIG_HOME/git"

  symlink "$XDG_CONFIG_HOME/git/config" "$DOTPLUGIN/gitconfig"
  symlink "$XDG_CONFIG_HOME/git/ignore" "$DOTPLUGIN/gitignore"
}
