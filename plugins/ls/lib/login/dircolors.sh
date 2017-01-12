# Colorize `ls` output using dircolors settings
eval "$(gdircolors "$DOT_PLUGIN_DIR/etc/dircolors")"
alias ls="gls --color=auto"
