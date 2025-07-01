on run
  tell application "Ghostty"
    activate
  end tell

  -- delay 0.5 -- Give Ghostty a moment to open/activate

  tell application "System Events"
    -- Send the tmux prefix (Ctrl-a)
    keystroke "a" using control down
    -- Send the key for sessionizer (F)
    keystroke "F"
  end tell
end run