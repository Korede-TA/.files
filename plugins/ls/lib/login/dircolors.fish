# Colorize `ls` output using dircolors settings
load_env (gdircolors $DOT_PLUGIN_DIR/etc/dircolors | psub)
alias ls "gls --color=auto"
