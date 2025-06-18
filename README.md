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
```

---

## ⚙️ Options
Flag	Description
- --commit	Enable auto-commit for dirty repositories. Used with --message.
- --message "msg"	Required when using --commit. This is the commit message.
- --dry-run	Show what the script would do without making changes.
- --no-log	Disable logging to git_auto_update.log.
- /path/to/repos	The root folder containing your Git repositories (required).

---

## 🔄 Default Behavior
- Dirty repos are skipped unless you use --commit and --message.
- Clean repos:
  - Are automatically stashed
  - Pulled from remote
-- Stash is popped
- All actions are logged by default to git_auto_update.log.
