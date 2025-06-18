# Git Repositories Auto-Updater

This bash script loops through all Git repositories in a specified directory, checks if they are on the `main` branch, and performs one of the following:

- If **not** on the `main` branch, it **skips** the repository.
- If on `main`:
  - If there are **uncommitted changes**, it displays them and asks if you want to commit them.
  - If there are **no changes**, it performs `git stash`, `git pull`, and then `git stash pop`.

---

## 📜 Features

- Skips repositories not on the `main` branch.
- Displays a list of uncommitted changes, if any.
- Optionally commits uncommitted changes with a message.
- Stashes and pulls the latest code from the remote if clean.
- Includes untracked files in stashes for safe pulls.

---

## 🚀 Usage

1. Make the script executable:

   ```bash
   chmod +x gitPuller.sh
