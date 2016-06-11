setup () {
  file "$HOME/.psqlrc" <<EOF
\\\set DOTDIR '$DOTDIR'
\\\i $DOTPLUGIN/psqlrc
\\\i $HOME/.psqlrc.local
EOF
}
