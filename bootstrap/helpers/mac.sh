ensure_homebrew_installed() {
  if [ ! $(command -v brew) ]; then
    echo "You may be asked for your sudo password to install:"
    sudo -v
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install git # Commonly used so just install it now
  fi

  if ! brew cask >/dev/null 2>&1; then
    echo "You may be asked for your sudo password to install:"
    sudo -v
    brew install caskroom/cask/brew-cask
  fi
}

formula_installed() {
  formula=$1
  ! brew info $formula | grep "Not installed" >/dev/null 2>&1
}

install_formula() {
  formula=$1
  if ! formula_installed $formula; then
    brew install $formula
  fi
}

uninstall_formula() {
  formula=$1
  if formula_installed $formula; then
    brew uninstall $formula
  fi
}

# Declarative syntax for specifying a Homebrew formula should be installed
formula() {
  formula=$1
  plist=$2 # Optional plist to load/unload with launchctl

  if installing; then
    install_formula $formula
    if [ -n "$plist" ]; then
      mkdir -p ~/Library/LaunchAgents
      ln -sf `brew --prefix`/opt/$formula/$plist $HOME/Library/LaunchAgents
      launchctl load $HOME/Library/LaunchAgents/$plist
    fi
  else
    if [ -n "$plist" ]; then
      launchctl unload $HOME/Library/LaunchAgents/$plist
      rm $HOME/Library/LaunchAgents/$plist
    fi
    uninstall_formula $formula
  fi
}

cask_installed() {
  cask=$1
  ! brew cask info $cask | grep "Not installed" >/dev/null 2>&1
}

install_cask() {
  cask=$1
  if ! cask_installed $cask; then
    brew cask install $cask
  fi
}

uninstall_cask() {
  cask=$1
  if cask_installed $cask; then
    brew cask uninstall $cask
  fi
}

# Declarative syntax for specifying a Homebrew cask should be installed
cask() {
  cask=$1
  if installing; then
    install_cask $cask
  else
    uninstall_cask $cask
  fi
}
