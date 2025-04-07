#!/bin/bash

# Set the parent directory
PARENT_DIR="$HOME/Documents"  # Use current directory if no argument is given

notify-send "Git Auto Push" 

for dir in "$PARENT_DIR"/*/; do
  if [ -d "$dir/.git" ]; then
    repo_name=$(basename "$dir")
    cd "$dir" || continue

    # Check for changes
    if [[ -n $(git status --porcelain) ]]; then
      git add .
      git commit -m "Auto-commit on $(date '+%Y-%m-%d %H:%M:%S')"
      if git push; then
        notify-send "❌ $repo_name" "Push failed."
      fi
    fi

    cd - >/dev/null || exit
  fi
done

notify-send "Git Auto Push" "✅ All done!"

