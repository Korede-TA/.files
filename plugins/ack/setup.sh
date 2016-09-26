setup() {
  if [ `uname` = Darwin ]; then
    formula ack
    formula ag
  fi

  symlink "$HOME/.ackrc" "$DOTPLUGIN/ackrc"
}
