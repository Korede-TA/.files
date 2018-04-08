# Load shims
if dot::in_path goenv; then
  eval "$(goenv init - "$DOT_SHELL")"
fi
