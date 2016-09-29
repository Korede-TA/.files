setup () {
  repo "git@github.com:sds/.vim.git" "$DOTPLUGIN/vim"
  symlink "$XDG_CONFIG_HOME/vim" "$DOTPLUGIN/vim"
}

install () {
  (cd $DOTPLUGIN/vim && $DOTPLUGIN/vim/update)
}
