tell application "System Preferences"
  activate
  set current pane to pane "com.apple.preference.keyboard"
end tell

# Give Keyboard pane time to load, otherwise "tab group 1" may not be ready yet
delay 1

tell application "System Events"
  tell process "System Preferences"
    click button "Modifier Keys…" of tab group 1 of window "Keyboard"

    # Select Caps Lock Key options
    click pop up button 4 of sheet 1 of window "Keyboard"

    # Change it to Control, the 2nd choice
    click menu item 2 of menu 1 of pop up button 4 of sheet 1 of window "Keyboard"

    click button "OK" of sheet 1 of window "Keyboard"
  end tell
end tell

tell application "System Preferences"
  quit
end tell
