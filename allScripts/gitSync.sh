#!/bin/bash

# Set the parent directory
PARENT_DIR="$HOME/Documents"

notify-send "Git Auto Push" "💖 Starting push for lowercase-named repos in: $PARENT_DIR"

for dir in "$PARENT_DIR"/*/; do
    repo_name=$(basename "$dir")

    # Check if the first character is lowercase and it's a git repo
    if [[ $repo_name =~ ^[a-z] ]] && [ -d "$dir/.git" ]; then
        cd "$dir" || continue

        # Check for changes
        if [ -n "$(git status --porcelain)" ]; then
            git add .
            git commit -m "Auto-commit on $(date '+%Y-%m-%d %H:%M:%S')"

            if ! git push; then
                notify-send "❌ $repo_name" "Push failed"
            fi
        fi

        cd - > /dev/null || exit
    fi
done

# Optional: success summary
notify-send "Git Auto Push" "✔ All lowercase repos processed."

