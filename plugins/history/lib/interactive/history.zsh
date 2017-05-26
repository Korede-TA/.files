# Append command to history file once executed
# (so we don't lose history if disconnected)
setopt INC_APPEND_HISTORY

# Ignore duplicate entries
setopt HIST_IGNORE_ALL_DUPS

# Don't remember commands with a leading space
# (useful for hiding sensitive arguments like passwords)
setopt HIST_IGNORE_SPACE
