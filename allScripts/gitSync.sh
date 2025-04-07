#!/bin/bash

# Set the parent directory
PARENT_DIR="$HOME/Documents"  # Use current directory if no argument is given

notify-send -t 2000 "🔄 Syncing Git repositories inside: $PARENT_DIR"

for dir in "$PARENT_DIR"/*/; do
  if [[ $dir =~ ^[a-z] ]] && [ -d "$dir/.git" ]; then
    cd "$dir" || continue
    git remote update
    git pull
    cd - >/dev/null || exit
  else
    notify-send -t 5000 "❌ Skipping $dir (not a git repo)"
  fi
done

notify-send -t 1000 "✅ All repositories processed."

