source "$DOT_PLUGIN_DIR/lib/interactive/prompt.sh"

# % escapes expanded in prompts
setopt prompt_percent

# Allow $ expansion in prompts
setopt prompt_subst

# Initialize the prompt
autoload -U promptinit
promptinit
