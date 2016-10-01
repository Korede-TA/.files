setup() {
  if [ `uname` = Darwin ]; then
    formula tmux
  fi

  # TODO: Replace with helper for XDG
  mkdir -p "$XDG_CONFIG_HOME/tmux"

  symlink "$XDG_CONFIG_HOME/tmux/tmux.conf" "$DOTPLUGIN/tmux.conf"
}
