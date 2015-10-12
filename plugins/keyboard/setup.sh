install() {
  if [ `uname` = Darwin ]; then
    enable_accessibility 'com.apple.Terminal'
    enable_accessibility 'com.googlecode.iterm2'

    osascript $DOTPLUGIN/switch-capslock-to-control.scpt
  fi
}
