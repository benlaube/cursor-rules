# File Protection Guide

## Metadata

- **Version:** 1.0.0
- **Last Updated:** 12/10/2025
- **Author:** Ben Laube
- **Description:** Guide for protecting cursor-rules files from accidental modifications. This system uses file permissions and git hooks to remind developers that rules and commands are shared files managed in the cursor-rules repository, requiring intentional action to modify.

---

## Overview

The cursor-rules submodule contains **shared** rules and commands used across multiple projects. To prevent accidental modifications, files are protected using:

1. **File Permissions** - Rules and commands are read-only by default
2. **Git Hooks** - Warnings before committing to the submodule
3. **Auto-Locking** - Files are automatically locked after submodule updates

---

## Quick Start

### Initial Setup

After adding the cursor-rules submodule, run:

```bash
.cursor/scripts/setup-protection.sh
```

This will:
- Lock all rules and commands (read-only)
- Install git hooks for automatic protection
- Set up auto-locking after updates

### Manual Locking

```bash
# Lock files (read-only)
.cursor/scripts/lock-rules.sh lock

# Unlock files (writable)
.cursor/scripts/lock-rules.sh unlock
```

---

## How Protection Works

### 1. File Permissions (Read-Only)

**Default State:** All `.mdc` and `.md` files in `rules/` and `commands/` are read-only.

**When you try to edit:**
- Most editors will show a warning
- You'll need to explicitly unlock or save as a new file
- This reminds you these are shared files

**To unlock:**
```bash
.cursor/scripts/lock-rules.sh unlock
```

### 2. Git Hooks (Commit Warnings)

**Pre-Commit Hook:** Warns before committing to the cursor-rules submodule.

**When you try to commit:**
```
⚠️  WARNING: You are committing to the cursor-rules submodule!

This is a SHARED repository used by multiple projects.

Are you sure you want to commit these changes?

Continue with commit? (yes/no):
```

**You must type "yes"** to proceed, preventing accidental commits.

### 3. Auto-Locking

**Post-Checkout/Post-Merge Hooks:** Automatically lock files after:
- Submodule updates (`git submodule update`)
- Pulling latest changes (`git pull` in submodule)

This ensures files stay protected even after updates.

---

## Making Changes

### Option 1: Edit in cursor-rules Repository (Recommended)

**For shared changes that should affect all projects:**

1. Navigate to cursor-rules repository (or clone it separately)
2. Make your changes
3. Commit and push to cursor-rules repository
4. Update submodule in your project:
   ```bash
   cd .cursor
   git pull origin main
   cd ..
   git add .cursor
   git commit -m "chore(.cursor): update to latest rules"
   ```

### Option 2: Use _project_specific/ Folders

**For project-specific rules/commands:**

```bash
# Add project-specific rule
vim .cursor/rules/_project_specific/my-custom-rule.mdc

# Add project-specific command
vim .cursor/commands/_project_specific/my-custom-command.md
```

These files are:
- ✅ Available to Cursor IDE
- ✅ Tracked by your parent repository (not submodule)
- ✅ Ignored by cursor-rules repository
- ✅ Won't conflict with submodule updates

### Option 3: Temporary Local Editing

**For testing changes locally:**

```bash
# Unlock files
.cursor/scripts/lock-rules.sh unlock

# Make your edits
vim .cursor/rules/some-rule.mdc

# Test in Cursor IDE

# Re-lock when done
.cursor/scripts/lock-rules.sh lock
```

**⚠️ Remember:** These changes are local only. To make them permanent, edit in the cursor-rules repository.

---

## Protection Levels

### Level 1: File Permissions (Always Active)

- Files are read-only by default
- Requires explicit unlock to edit
- Works immediately after setup

### Level 2: Git Hooks (After Setup)

- Pre-commit warning before committing to submodule
- Auto-lock after updates
- Requires running `setup-protection.sh`

### Level 3: Manual Verification

- Always verify you're editing the right location
- Use `_project_specific/` for project-only changes
- Commit to cursor-rules repo for shared changes

---

## Troubleshooting

### "Permission Denied" When Editing

**Symptom:** Can't save changes to rules/commands

**Solution:**
```bash
# Unlock files
.cursor/scripts/lock-rules.sh unlock

# Make your changes
# Then re-lock if needed
.cursor/scripts/lock-rules.sh lock
```

### Files Not Locking After Update

**Symptom:** Files are writable after `git submodule update`

**Solution:**
```bash
# Re-run setup
.cursor/scripts/setup-protection.sh

# Or manually lock
.cursor/scripts/lock-rules.sh lock
```

### Want to Disable Protection

**To temporarily disable:**
```bash
# Unlock all files
.cursor/scripts/lock-rules.sh unlock
```

**To permanently disable:**
- Remove git hooks: `rm .git/modules/.cursor/hooks/*`
- Files will remain unlocked until you lock them again

---

## Best Practices

1. **Keep Files Locked** - Only unlock when you need to edit
2. **Use _project_specific/** - For project-only changes
3. **Edit in Repository** - For shared changes, edit in cursor-rules repo
4. **Verify Before Committing** - Always check you're committing to the right repo
5. **Re-lock After Testing** - Lock files again after local testing

---

## Related Resources

- **Lock Script:** `.cursor/scripts/lock-rules.sh`
- **Setup Script:** `.cursor/scripts/setup-protection.sh`
- **Integration Guide:** `INTEGRATION.md`
- **README:** `README.md`

---

**Last Updated:** 12/10/2025  
**Author:** Ben Laube  
**Version:** 1.0.0
