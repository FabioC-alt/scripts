#!/bin/bash

# Set the parent directory
PARENT_DIR="$HOME/Documents"  # Use current directory if no argument is given

notify-send "Git Auto Push" "🚀 Starting push for lowercase-named repos in: $PARENT_DIR"

for dir in "$PARENT_DIR"/*/; do
  repo_name=$(basename "$dir")

  # Check if the first character is lowercase
  if [[ $repo_name =~ ^[a-z] ]] && [ -d "$dir/.git" ]; then
    cd "$dir" || continue

    # Check for changes
    if [[ -n $(git status --porcelain) ]]; then
      echo "📁 Changes found in $repo_name"
      git add .
      git commit -m "Auto-commit on $(date '+%Y-%m-%d %H:%M:%S')"
      if git push; then
        notify-send "✅ $repo_name" "Pushed changes successfully."
      else
        notify-send "❌ $repo_name" "Push failed."
      fi
    else
      notify-send "🟢 $repo_name" "No changes to push."
    fi

    cd - >/dev/null || exit
  else
    echo "🔁 Skipping $repo_name (not lowercase or not a git repo)"
  fi
done

notify-send "Git Auto Push" "✅ All lowercase repos processed."

