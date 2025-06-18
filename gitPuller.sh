#!/bin/bash

# Set the base folder containing the git repositories
BASE_DIR="$1"

if [ -z "$BASE_DIR" ]; then
  echo "Usage: $0 /path/to/folder"
  exit 1
fi

# Loop through all subdirectories
for dir in "$BASE_DIR"/*; do
  if [ -d "$dir/.git" ]; then
    echo "Entering repository: $dir"
    cd "$dir" || continue

    # Get current branch
    CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

    if [ "$CURRENT_BRANCH" != "main" ]; then
      echo "  Skipping - Not on main branch (currently on $CURRENT_BRANCH)"
      continue
    fi

    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
      echo "  Uncommitted changes found:"
      git status --short
      echo -n "  Do you want to commit these changes? [y/N]: "
      read -r response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        echo -n "  Enter commit message: "
        read -r msg
        git add .
        git commit -m "$msg"
        echo "  Changes committed."
      else
        echo "  Skipping commit."
      fi
    else
      echo "  No uncommitted changes. Running stash and pull..."
      git stash push -u -m "Auto-stash before pull on $(date)"
      git pull
      git stash pop
    fi

    echo ""
  fi
done
