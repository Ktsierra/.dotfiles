on run argv
  tell application "System Events"
    -- Send the tmux prefix (Ctrl-a) 
    keystroke "a" using control down
    -- Send the main key (from argv)
    keystroke item 1 of argv
  end tell
end run