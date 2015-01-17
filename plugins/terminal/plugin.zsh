bindkey -e # Use emacs key bindings

bindkey ' ' magic-space # Expands "!!" and other such shortcuts on space

# Allow searching through previous commands that match the current prefix
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
