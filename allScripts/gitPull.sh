#!/bin/bash

# Set the parent directory
PARENT_DIR="$HOME/Documents"

# notify-send "Git Auto Pull" " Starting pull from GitHub"

for dir in "$PARENT_DIR"/*; do
    repo_name=$(basename "$dir")

    if [ -d "$dir/.git" ]; then
        cd "$dir" || continue

        git pull
	notify-send  "$repo_name pulled"
    fi
done

