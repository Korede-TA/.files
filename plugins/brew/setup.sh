install() {
  if [ `uname` = Darwin ]; then
    brew tap homebrew/completions
    brew install brew-cask-completion
  fi
}
