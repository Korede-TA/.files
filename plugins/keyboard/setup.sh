install() {
  if [ `uname` = Darwin ]; then
    # Enable accessibility for installs via remote SSH connection
    enable_accessibility '/usr/libexec/sshd-keygen-wrapper'

    # Enable accessibility for installs via typical terminals
    enable_accessibility 'com.apple.Terminal'
    enable_accessibility 'com.googlecode.iterm2'

    osascript $DOTPLUGIN/switch-capslock-to-control.scpt
  fi
}
