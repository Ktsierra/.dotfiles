# ~/.zshrc

# nvm setup
export NVM_DIR="$HOME/.nvm"

# brew setup
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"

# react-native setup
export ANDROID_HOME=$HOME/Library/Android/sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# console-ninja setup
PATH=~/.console-ninja/.bin:$PATH

# ssh-agent setup
# personal github
if ssh-add -l 2>/dev/null | grep -q "$(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')"; then
  # Key is already loaded in the agent
  #echo "personal github key is already loaded in the agent."
  : # No action needed
else
  # Key is not loaded; add it
  ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
fi

# Automate tmux session cleanup every X hours using a LaunchAgent
# This will create plist file to run the script every X hours
# and log output/errors to /tmp/$PLIST_LABEL.out and /tmp/$PLIST_LABEL.err
# NOTE: If you modify the INTERVAL_SEC below, make sure to also change it in
# the ~/github/dotfiles-latest/tmux/tools/linkarzu/tmuxKillSessions.sh script
#
# 1 hour = 3600 s
INTERVAL_SEC=7200
PLIST_ID="tmuxKillSessions"
PLIST_NAME="com.ktsierra.$PLIST_ID.plist"
PLIST_LABEL="${PLIST_NAME%.plist}"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME"
SCRIPT_PATH="$HOME/.config/tmux/$PLIST_ID.sh"

# Ensure the script file exists
if [ ! -f "$SCRIPT_PATH" ]; then
  echo "Error: $SCRIPT_PATH does not exist."
else
  # If the PLIST file does not exist, create it
  if [ ! -f "$PLIST_PATH" ]; then
    echo "Creating $PLIST_PATH..."
    cat <<EOF >"$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$PLIST_LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$SCRIPT_PATH</string>
    </array>
    <key>StartInterval</key>
    <integer>$INTERVAL_SEC</integer>
    <key>StandardOutPath</key>
    <string>/tmp/$PLIST_ID.out</string>
    <key>StandardErrorPath</key>
    <string>/tmp/$PLIST_ID.err</string>
</dict>
</plist>
EOF
  fi
fi

# Check if the plist is loaded, and load it if not
if ! launchctl list | grep -q "$PLIST_LABEL"; then
  echo "Loading $PLIST_PATH..."
  launchctl load "$PLIST_PATH"
  echo "$PLIST_PATH loaded."
fi

# To unload
# launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.ktsierra.tmuxKillSessions
# Not sure why its not unloading it so I just remove the plist file
# rm $PLIST_PATH

# Set key repeat rate to 1 (fastest) and InitialKeyRepeat to 15 (fastest)
# This is for macOS to make key repeat faster
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15