install() {
  if [ `uname` = Darwin ]; then
    enable_accessibility 'com.sproutcube.Shortcat'
  fi
}

setup() {
  if [ `uname` = Darwin ]; then
    cask shortcat
  fi
}
