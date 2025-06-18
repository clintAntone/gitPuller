# Git Auto Update Script

This script automates updating multiple Git repositories located under a specified base directory.

---

## 🚀 Features

- ✅ Automatically finds and processes all Git repositories (recursively).
- ✅ Works only on repositories currently on the `main` branch.
- ✅ Skips dirty repositories **by default**.
- ✅ Optionally commits dirty repos with a batch commit message (`--commit --message`).
- ✅ Automatically stashes and pulls latest changes for clean repos.
- ✅ Automatically updates Git submodules if present.
- ✅ Logging is **enabled by default** (writes to `git_auto_update.log`).
- ✅ Optionally supports dry-run mode (`--dry-run`).
- ✅ Supports repository blacklist (skip specific folders).

---

## 📦 Usage

```bash
./gitPuller.sh /path/to/repos [options]
