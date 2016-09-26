setup() {
  if [ `uname` = Darwin ]; then
    cask slate
    symlink "$HOME/.slate" "$DOTPLUGIN/slate"
  fi
}
