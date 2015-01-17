# TODO: Figure out a way to define these in the plugin itself while preserving
# the ordering of having these commands run last.

# Initialize syntax highlighting
source $DOTDIR/plugins/terminal/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Allow for searching through previous commands matching a given substring
# (i.e. you type a bit of the command and then cycle with Ctrl-P/N)
source $DOTDIR/plugins/terminal/zsh-history-substring-search/zsh-history-substring-search.zsh

# Add a large library of completions that aren't in upstream zsh completions yet
fpath=($DOTDIR/plugins/terminal/zsh-completions/src $fpath)

# Initialize completion system now that all completions are in $fpath
autoload -U compinit
compinit -d "${DOTTMPDIR}/zcompdump"
