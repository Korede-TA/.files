# Dot

Dot is a framework for managing large numbers of applications and their
configurations via shell scripts.

It allows you to:

* Organize your dotfile configurations in any manner you choose

* Maintain dotfile configurations for different shells simultaneously
  (useful if you frequently log in to multiple systems with different
  available shells)

* Specify how your configurations should be installed (where symlinks should
  point to, which repositories to clone, which Homebrew formula to install,
  etc.), making it easy to get set up on a new machine, and also making it easy
  to remove your presence from that machine when you're done

## Installation

Whether you're starting with a brand new machine or want to install Dot on
a machine you've been using for a while, run the following in your terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sds/dot/master/bootstrap/remote-install)"
```

Have a look at the [source](https://github.com/sds/dot/blob/master/bootstrap/remote-install)
if you want to confirm what you're about to run.

## Organization

Dot allows you to organize configuration settings into logical groups. The
`plugins` directory contains a folder for each one of these groups (e.g. an
`ssh` folder for SSH-related settings, or a `git` folder for git-related
settings).

Each of these directories can contains files of the form
`plugin.{sh,bash,zsh}`. `plugin` files are loaded on shell startup, and perform
any environment initialization (e.g. exporting variables) to support the
particular plugin.

For any file that is loaded from a plugin, the `.sh` extension is loaded
first. `.sh` files are intended to represent code that runs regardless of
which shell you are using (i.e. it should contain shell-agnostic code).

Next, any file with the shell-specific extension of the current shell (e.g.
`.bash` or `.zsh`) is loaded to run commands specific to that shell. This
allows you to tweak your configuration on a per-shell basis.

In each plugin, there may also be an installation script `setup.sh`, and
other configuration files related to the plugin. For example, a plugin
directory for git would likely have `gitconfig` and `gitignore` files, along
with an `setup.sh` script which symlinks these files to the user's home
directory.

Look at the `plugins` directory for examples of how this organizational system
works in practice.

## Writing a Plugin

Writing your own plugin with Dot is designed to be easy. To start, you need
to identify what you want your plugin to do.

  * Does it install files in your home directory?
  * Does it set any environment variables?
  * Does it declare any aliases or functions for use in your shell?

If you're installing any sort of files or repository, you'll need to add a
`setup.sh` script to your plugin, and in that either have a `setup` function
which makes the appropriate calls to `symlink`, `file`, `repo`, etc., or
individual `install`/`uninstall` functions to carry out the install/uninstall
commands by hand.

### Install/Uninstall Scripts

Defining a function called `setup` in a plugin's `setup.sh` allows you to use
a "declarative" syntax for specifying which files and repos your plugin
requires. Using this declarative syntax means you only have to write your setup
script once---there's no need to define what to do when you install a script
versus when you uninstall (i.e. instead of creating a symlink in the install
script and removing the symlink in the uninstall script, you just declare the
existence of the directory once).

Here's an example of a `setup.sh` file for installing some symlinks for `git`:

    setup () {
      symlink "$HOME/.gitconfig" "$DOTPLUGIN/gitconfig"
      symlink "$HOME/.gitignore" "$DOTPLUGIN/gitignore"
    }

Here we use the `symlink` helper to declare that the `.gitconfig`/`.gitignore`
files in the user's home directory should be symlinks pointing to the
`gitconfig` and `gitignore` files in the plugin directory itself. When
installing, `symlink` makes a backup of any currently existing
`.gitconfig`/`.gitignore` files if they exist, and replaces them with symlinks.
When uninstalling, these symlinks are removed, and if backups were made they
are restored.

If the install/uninstall processes vary significantly, you can also explictly
define them by defining `install` and `uninstall` functions in your plugin's
`setup.sh`. For example:

    install () {
      mkdir "$HOME/blah"
    }

    uninstall () {
      rm -rf "$HOME/blah"
    }

### Implementing your Plugin

If you're setting environment variables, aliases, or defining custom functions,
these should go in the `plugin.sh` file. How you organize this file is entirely
up to you; you can source other files in order to impose your own source code
structure.

Here's an example of a `plugin.sh` for `tmux`, which overrides the `tmux`
command with custom behaviour, and also adds an alias.

    alias t=tmux

    # Automatically name sessions to the directory from which we started tmux
    tmux () {
      if [ -z "$@" ]; then
        local dir=`basename $(pwd)`
        # Attach to session with the current directory name if one exists,
        # otherwise automatically create a session with the current directory name
        command tmux attach-session -t "$dir" || command tmux new-session -s "$dir"
      else
        command tmux "$@"
      fi
    }

Note that `plugin.sh` is run regardless of which shell you are using. If you
have a plugin specific to a particular shell, such as `zsh`, then you'll have
to create a `plugin.zsh` file instead. However, you should try to make your
plugins as general as possible.

#### Helper Environment Variables

The following environment variables are useful when writing plugins:

* `DOTDIR`: Location of the Dot repository. If you installed using the
  instructions above, this would be `$HOME/.dotfiles`, with `$HOME`
  appropriately expanded

* `DOTPLUGIN`: Location of the plugin running the currently plugin code.
  This is available only within the context of a plugin (e.g. in the
  `plugin.sh` and `setup.sh` files of a plugin)

* `DOTLOGDIR`: Directory to store log files (optional to use, but useful
  if you like keeping all logs in one place). Shortcut for `"$DOTDIR/log"`

* `DOTTMPDIR`: Directory to store temporary files (optional to use). Shortcut
  for `"$DOTDIR/tmp"`

## Motivations

Dot was motivated by the desire to:

* Save setup time on new systems

* Provide a flexible framework for organizing a large number of dotfile
  configurations

* Provide a way to gracefully degrade from `zsh` to `bash` in the event
  `zsh` wasn't available (likely when using dotfiles on multiple systems)

* Allow easy switching between shells when pair programming (for example
  if one pair prefers `bash`)

* Learn more about the idiosyncrasies of `bash` and `zsh`

While it currently only supports `bash` and `zsh`, in theory there's nothing
preventing it from supporting `csh` or others---there's just little
motivation to do so as they are far less commonly used.

## Etymology

Dot comes from the fact that it ultimately manages 'dot' files, and is a
tribute to [Dot Matrix][DotMatrix] of [ReBoot][ReBoot] fame.

## License

[WTFPL][WTFPL]

[DotMatrix]: http://reboot.wikia.com/wiki/Dot_Matrix
[ReBoot]: http://en.wikipedia.org/wiki/ReBoot
[WTFPL]: http://en.wikipedia.org/wiki/WTFPL
