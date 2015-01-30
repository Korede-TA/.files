# Enable autocompletion for pip (only available for bash/zsh)
shell=`current_shell`
if [[ "$shell" =~ (ba|z)sh ]]; then
  which pip >/dev/null 2>&1 && \
    eval `pip completion --$shell`
fi
