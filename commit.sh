#!/bin/bash

# Prompt user for commit message
echo "Enter commit message:"
read commit_message

# Add changes to staging
git add .

# Commit with the provided message
git commit -m "$commit_message"

# Push changes to the current branch on GitHub
git push
#git push origin $(git rev-parse --abbrev-ref HEAD)

echo "Changes pushed to GitHub with commit message: $commit_message"
