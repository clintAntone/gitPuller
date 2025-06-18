#!/bin/bash

# ========================
# Git Auto Update Script
# ========================

# Defaults
COMMIT_MSG=""
DRY_RUN=false
LOG=true
COMMIT_DIRTY=false
LOG_FILE="git_auto_update.log"
SKIP_REPOS=("legacy-repo" "experimental")  # Add repo names here to skip
BASE_DIR=""

# -----------------
# Parse CLI Options
# -----------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --message)
      COMMIT_MSG="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --commit)
      COMMIT_DIRTY=true
      shift
      ;;
    --no-log)
      LOG=false
      shift
      ;;
    *)
      BASE_DIR="$1"
      shift
      ;;
  esac
done

if [[ -z "$BASE_DIR" ]]; then
  echo "Usage: $0 /path/to/repos [--commit --message \"msg\"] [--dry-run] [--no-log]"
  exit 1
fi

# -------------------
# Start Processing Repos
# -------------------
find "$BASE_DIR" -type d -name ".git" | while read -r git_dir; do
  REPO_DIR=$(dirname "$git_dir")
  REPO_NAME=$(basename "$REPO_DIR")

  # Skip blacklisted repos
  if [[ " ${SKIP_REPOS[*]} " =~ " $REPO_NAME " ]]; then
    echo "[$REPO_NAME] Skipped (in skip list)"
    continue
  fi

  echo "[$REPO_NAME] Processing..."
  cd "$REPO_DIR" || continue

  CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ "$CURRENT_BRANCH" != "main" ]]; then
    echo "[$REPO_NAME] Skipped (on $CURRENT_BRANCH, not main)"
    continue
  fi

  CHANGES=$(git status --porcelain)

  if [[ -n "$CHANGES" ]]; then
    echo "[$REPO_NAME] Uncommitted changes detected."

    if [[ "$COMMIT_DIRTY" == true && -n "$COMMIT_MSG" ]]; then
      echo "[$REPO_NAME] Committing with message: $COMMIT_MSG"
      [[ "$DRY_RUN" == false ]] && git add . && git commit -m "$COMMIT_MSG"
      [[ "$LOG" == true ]] && echo "$(date): [$REPO_NAME] Committed changes" >> "$LOG_FILE"
    else
      echo "[$REPO_NAME] Skipped (dirty repo and no --commit flag)"
      [[ "$LOG" == true ]] && echo "$(date): [$REPO_NAME] Skipped due to uncommitted changes" >> "$LOG_FILE"
      continue
    fi
  else
    echo "[$REPO_NAME] Clean. Pulling latest..."
    if [[ "$DRY_RUN" == false ]]; then
      git stash push -u -m "Auto-stash before pull on $(date)"
      git pull
      git stash pop
    fi
    [[ "$LOG" == true ]] && echo "$(date): [$REPO_NAME] Pulled latest" >> "$LOG_FILE"
  fi

  if [[ -f .gitmodules && "$DRY_RUN" == false ]]; then
    git submodule update --init --recursive
    [[ "$LOG" == true ]] && echo "$(date): [$REPO_NAME] Updated submodules" >> "$LOG_FILE"
  fi

  echo "[$REPO_NAME] Done."
  echo ""
done
