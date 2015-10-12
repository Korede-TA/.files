install() {
  if [ `uname` = Darwin ]; then
    enable_accessibility 'com.slate.Slate'
  fi
}

setup() {
  if [ `uname` = Darwin ]; then
    cask slate
    symlink "$HOME/.slate" "$DOTPLUGIN/slate"
  fi
}
