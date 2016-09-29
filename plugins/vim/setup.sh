setup () {
  repo "git@github.com:sds/.vim.git" "$DOTPLUGIN/vim"
  symlink "$HOME/.vim" "$DOTPLUGIN/vim"
}

install () {
  (cd $DOTPLUGIN/vim && $DOTPLUGIN/vim/update)
}
