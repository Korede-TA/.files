# Shell bootstrap script run for all interactive shells.
#
# To activate, have .bash_profile/.zshrc/etc. define an environment variable
# DOTDIR pointing to the location of this repository, and source this file.

[ -z "$DOTDIR" ] && echo '$DOTDIR environment variable not set' && exit 1

# Load library of helper functions and initialize global environment
source "$DOTDIR/bootstrap/init.sh"

bootstrap () {
  local exts=sh
  local shell=`current_shell`

  init_dot_colours

  # Include shell-specific extension in list of files to source after .sh files
  if [ "$shell" != sh ]; then
    exts="$exts $shell"
  fi

  # Perform any shell-specific tasks that must happen first
  for ext in `words $exts`; do
    local src_file="$DOTDIR/bootstrap/start.$ext"
    if [ -s "$src_file" ]; then
      source "$src_file"
    fi
  done

  # For each plugin...
  for DOTPLUGIN in `find $DOTPLUGINSDIR -mindepth 1 -maxdepth 1 -type d`; do
    # Source the generic .sh files first, then the shell-specific ones
    for ext in `words $exts`; do
      if [ -s "$DOTPLUGIN/plugin.$ext" ]; then
        source "$DOTPLUGIN/plugin.$ext"
      fi
    done

    # Perform any shell-specific tasks for loading a plugin
    local src_file="$DOTDIR/bootstrap/plugin.$shell"
    if [ -s "$src_file" ]; then
      source "$src_file"
    fi
  done

  # Perform any final shell-specific tasks
  for ext in `words $exts`; do
    local src_file="$DOTDIR/bootstrap/finish.$ext"
    if [ -s "$src_file" ]; then
      source "$src_file"
    fi
  done

  # Now execute any final scripts for each plugin
  for DOTPLUGIN in `find $DOTPLUGINSDIR -mindepth 1 -maxdepth 1 -type d`; do
    # Source the generic .sh files first, then the shell-specific ones
    for ext in `words $exts`; do
      if [ -s "$DOTPLUGIN/finish.$ext" ]; then
        source "$DOTPLUGIN/finish.$ext"
      fi
    done
  done
}

bootstrap && unset bootstrap
