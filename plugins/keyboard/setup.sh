install() {
  if [ `uname` = Darwin ]; then
    osascript $DOTPLUGIN/switch-capslock-to-control.scpt
  fi
}
