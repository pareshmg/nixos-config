#!/usr/bin/env bash

# Get the ID of the current pane
current_pane_id=$(tmux display-message -p '#{pane_id}')

# Get the global pane history string
history_str=$(tmux show-option -gv @global_pane_history 2>/dev/null)

# Convert history string to array
# Ensure IFS is set correctly for space-separated values
IFS=' ' read -r -a history_array <<< "$history_str"

local target_pane_id=''

# Loop through the history to find the first pane that isn't the current one
for item in "${history_array[@]}"; do
    if [[ "$item" != "$current_pane_id" ]]; then
        target_pane_id="$item"
        break
    fi
done

# Perform the switch if a target pane is found
if [[ -n "$target_pane_id" ]]; then
    # tmux display-message "DEBUG: Global last pane: Switching to $target_pane_id"
    tmux switch-client -t "$target_pane_id"
else
    tmux display-message "No previous global pane found in history."
fi
