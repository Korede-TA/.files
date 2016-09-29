setup() {
  if [ "$(uname)" = Darwin ]; then
    formula gpg
    cask gpgtools
  fi
}
