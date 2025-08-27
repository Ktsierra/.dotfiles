#!/usr/bin/env bash

# SSH hosts list - add your hosts here
ssh_hosts=(
  "ember"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(printf '%s\n' "${ssh_hosts[@]}" | fzf --prompt="SSH Host: ")
fi

if [[ -z $selected ]]; then
    exit 0
fi

# Create session name from host (replace dots, @, and special chars with underscores)
selected_name=$(echo "$selected" | sed 's/[.@:]/_/g' | tr -cd '[:alnum:]_')
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "ssh_$selected_name" "ssh $selected"
    exit 0
fi

if ! tmux has-session -t="ssh_$selected_name" 2> /dev/null; then
    tmux new-session -ds "ssh_$selected_name" "ssh $selected"
fi

tmux switch-client -t "ssh_$selected_name"