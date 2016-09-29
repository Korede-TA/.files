setup () {
  if [ `uname` = Darwin ]; then
    symlink "$HOME/.karabiner.d" "$DOTPLUGIN/karabiner.d"
  fi
}
