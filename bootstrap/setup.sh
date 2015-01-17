# Sets .bash_profile and .zprofile to load this framework, and runs any plugin
# installation scripts (setting up symlinks, etc.)
#
# This script and any setup scripts should be idempotent.

backup() {
  local file=$1
  local file_name=`basename $1`
  local backup_file="$DOTDIR/backups/$file_name.bak"

  if [ -e "$backup_file" ]; then
    # Warn user if backup file already exists and is different
    if [ ! -z "`diff --ignore-blank-lines --ignore-space-change \
         $tmp_file $file`" ]; then
      read -p "Backup '$backup_file' for '$file' already exists. Overwrite? (y/n) "
      [ "$REPLY" == "n" ] && return
    fi
  fi

  cp -r "$file" "$backup_file"
}

restore() {
  local file=$1
  local file_name=`basename $1`
  local backup_file="$DOTDIR/backups/$file_name.bak"

  if [ -e "$backup_file" ]; then
    if [ -e "$file" ]; then
      rm "$file"
    fi

    echo "Restoring file '$file' from '$backup_file'"
    mv "$backup_file" "$file"
  fi
}

installing() {
  [ "$DOTSETUPTYPE" = "install" ]
}

uninstalling() {
  [ "$DOTSETUPTYPE" = "uninstall" ]
}

# Declares a git repository for a plugin, handling both install/uninstall
repo() {
  local repo_url=$1
  local repo_dest=$2 # optional
  local commit=$3    # optional

  # Default to current plugin directory if none specified
  if [ -z "$repo_dest" ]; then
    repo_dest="$DOTPLUGIN/$(basename -s .git $repo_url)"
  fi

  if installing; then
    if [ -d "$repo_dest/.git" ]; then
      # Repo already exists; update it
      (cd "$repo_dest" && git pull > /dev/null)
    else
      git clone "$repo_url" "$repo_dest"
    fi

    if [ -n "$commit" ]; then
      (cd "$repo_dest" && git reset --hard "$commit")
    fi
  else
    rm -rf "$repo_dest"
  fi
}

# Declarative syntax for specifying that a symlink should be created for plugin
symlink() {
  local target_file=$1 # Location to place the symlink
  local source_file=$2 # File to point symlink to

  if installing; then
    if [ -e "$target_file" ]; then
      if [ "`readlink $target_file`" = "$source_file" ]; then
        return
      fi
      backup "$target_file" && rm -rf $target_file
    fi

    ln -sf "$source_file" "$target_file"
  else
    if [ -L "$target_file" ]; then
      rm "$target_file"
    elif [ -e "$target_file" ]; then
      echo "Can't remove '$target_file', since it is not a symbolic link"
    fi

    restore "$target_file"
  fi
}

# Declarative syntax for specifying a file to be created for plugin
# The file contents are passed in via STDIN, so callers can use Heredoc syntax
# to make convenient file templates.
file() {
  local file=$1
  local file_name=`basename $1`
  local tmp_file="$DOTTMPDIR/$file_name"

  if installing; then
    # `file` will be passed file contents via STDIN
    while read data; do
      echo "$data" >> "$tmp_file"
    done

    # Backup previously existing file unless it has the exact same contents
    if [ -e "$file" ]; then
      if [ ! -z "`diff --ignore-blank-lines --ignore-space-change \
           $tmp_file $file`" ]; then
        backup "$file" || return -1
      fi
    fi

    mv "$tmp_file" "$file"
  else
    if [ -e "$file" ]; then
      rm "$file"
    fi

    restore "$file"
  fi
}

# Ensures Dot is a git repo. This is useful when it is installed via tarball.
ensure_git_repo() {
  if [ ! -d $DOTDIR/.git ]; then
    git init -q
    git remote add origin git@github.com:sds/dot
    git fetch origin
    git reset origin/master
  fi
}

# Sets up environment for [un]installation of plugin
setup_dot_plugin() {
  local plugin_name=$1
  local plugin_dir="$DOTPLUGINSDIR/$plugin_name"

  # Define variable so plugin install script can use it for convenience
  DOTPLUGIN="$plugin_dir"

  for script in `words setup.sh setup.$(current_shell)`; do
    script_path="$plugin_dir/$script"
    [ ! -e "$script_path" ] && continue

    # Execute in subshell to prevent functions clobbering namespace
    (
      source "$script_path" &&
      for func in `words setup $DOTSETUPTYPE`; do
        if function_defined $func; then
          $func
        fi
      done
    )
  done
}

setup_dot() {
  local install_type=$1    # Whether this is an install or uninstall
  local specific_plugin=$2 # Can optionally specify plugin

  if [ "$install_type" = install ]; then
    export DOTSETUPTYPE="install"
  elif [ "$install_type" = uninstall ]; then
    export DOTSETUPTYPE="uninstall"
  else
    echo "Invalid installation type '$install_type'. Must be 'install or 'uninstall'"
    return 1
  fi

  # Load basic helpers
  source "$DOTDIR/bootstrap/init.sh"

  # Load additional OS-specific helpers
  if [ `uname` = Darwin ]; then
    source "$DOTDIR/bootstrap/helpers/mac.sh"
    source "$DOTDIR/bootstrap/setup/mac.sh"
  fi

  if [ -n "$specific_plugin" ]; then
    setup_dot_plugin $specific_plugin
    return
  fi

  # Write shell config files to point to bootstrap script
  for startup_file in `words .bash_profile .zshrc`; do
    file "$HOME/$startup_file" <<EOF
export DOTDIR="$DOTDIR"
source "\$DOTDIR/bootstrap/startup.sh"
EOF
  done

  for script in `find $DOTPLUGINSDIR -name "setup.sh"`; do
    local plugin="$(basename $(dirname $script))"
    setup_dot_plugin "$plugin"
  done

  # By this point we should have git installed, so ensure we're a git repo
  ensure_git_repo
}
