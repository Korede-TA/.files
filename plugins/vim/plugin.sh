# Vim doesn't support XDG out of the box, so override the initial command
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
