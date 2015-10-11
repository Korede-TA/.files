set -e # Halt on first error

# Define DOTDIR to be location of this repository
export DOTDIR="$( cd "$( dirname $( dirname "$0" ) )" && pwd )"

source "$DOTDIR/bootstrap/setup.sh"

setup_dot install "$@"
