# Initialize zsh completion system
autoload -U compinit
compinit -d "${DOTTMPDIR}/zcompdump"

zmodload zsh/complist

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false

# Initialize the prompt
autoload -U promptinit
promptinit

# TODO: Figure out a way to define these in the plugin itself while preserving
# the ordering of having these commands run last.

# Initialize syntax highlighting
source $DOTDIR/plugins/terminal/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Allow for searching through previous commands matching a given substring
# (i.e. you type a bit of the command and then cycle with Ctrl-P/N)
source $DOTDIR/plugins/terminal/zsh-history-substring-search/zsh-history-substring-search.zsh

# Add a large library of completions that aren't in upstream zsh completions yet
fpath=($DOTDIR/plugins/terminal/zsh-completions/src $fpath)
