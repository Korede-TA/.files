setup() {
  if [ `uname` = Darwin ]; then
    formula tmux
  fi

  symlink "$HOME/.tmux.conf" "$DOTPLUGIN/tmux.conf"
}
