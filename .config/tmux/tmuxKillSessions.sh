#!/usr/bin/env bash

# tmuxKillSessions.sh
# Automatically kill tmux sessions that have been inactive for too long.

# copied from linkarzu/tmuxKillSessions.sh which is a modified
# version of https://gist.github.com/dhulihan/4c65e868851660fb0d8bfa2d059e7967
# by github user dhulihan

# Linkarzu's version is here:
# Tmux Cleanup Session Script | Automatically Kill Unused Tmux Sessions
# https://youtu.be/3axjsVR7QfA

# If I do not add this, the script will not find tmux or any other apps in
# the /opt/homebrew/bin dir. So it will not run the tmux ls command
export PATH="/opt/homebrew/bin:$PATH"

# I make this slightly lower than the LaunchAgent interval
TOO_OLD_THRESHOLD_MIN=110
TMUX_LOG_PATH="/tmp/tmuxKillSessions.log"

NOW=$(($(date +%s)))

tmux ls -F '#{session_name} #{session_activity} #{session_attached}' | while read -r LINE; do
  SESSION_NAME=$(echo $LINE | awk '{print $1}')
  LAST_ACTIVITY=$(echo $LINE | awk '{print $2}')
  ATTACHED=$(echo $LINE | awk '{print $3}')
  LAST_ACTIVITY_MINS_ELAPSED=$(((NOW - LAST_ACTIVITY) / 60))

  # Skip sessions with a client currently attached (Ghostty/iTerm window open on it).
  # An attached session is "in use" no matter how idle the keyboard is.
  if [[ "$ATTACHED" -gt 0 ]]; then
    continue
  fi

  if [[ "$LAST_ACTIVITY_MINS_ELAPSED" -gt "$TOO_OLD_THRESHOLD_MIN" ]]; then
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$TIMESTAMP - Killed session: $SESSION_NAME (detached, inactive for ${LAST_ACTIVITY_MINS_ELAPSED}min)" | tee -a $TMUX_LOG_PATH
    tmux kill-session -t ${SESSION_NAME}
    # In case you want to test the script without killing sessions, comment the 2 lines above and uncomment below
    # echo "${SESSION_NAME} is ${LAST_ACTIVITY_MINS_ELAPSED}min inactive and would be killed."
  fi
done