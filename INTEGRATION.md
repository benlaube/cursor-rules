# Cursor Rules Submodule Integration Guide

> **Version:** 1.0.0  
> **Last Updated:** 2025-01-27

Complete guide for integrating the cursor-rules repository as a git submodule in your project.

---

## Table of Contents

1. [Quick Start](#1-quick-start)
2. [Full Integration Process](#2-full-integration-process)
3. [Updating the Submodule](#3-updating-the-submodule)
4. [Version Pinning](#4-version-pinning)
5. [Troubleshooting](#5-troubleshooting)
6. [CI/CD Integration](#6-cicd-integration)

---

## 1. Quick Start

### Add to New Project

```bash
# In your project root
git submodule add https://github.com/benlaube/cursor-rules.git .cursor

# Verify installation
ls .cursor/rules/
ls .cursor/commands/
```

### Clone Existing Project

```bash
# Clone with submodules
git clone --recurse-submodules <your-project-repo-url>

# Or clone then initialize
git clone <your-project-repo-url>
cd <project-name>
git submodule update --init --recursive
```

---

## 2. Full Integration Process

### Step 1: Add Submodule

```bash
cd /path/to/your/project
git submodule add https://github.com/benlaube/cursor-rules.git .cursor
```

This creates:
- `.cursor/` directory with all rules and commands
- `.gitmodules` file with submodule configuration

### Step 2: Verify Installation

```bash
# Check submodule status
git submodule status

# Verify content
ls .cursor/rules/
ls .cursor/commands/

# Count files (should see ~74 rules, ~38 commands)
find .cursor/rules -name "*.mdc" | wc -l
find .cursor/commands -name "*.md" | wc -l
```

### Step 3: Commit Submodule

```bash
git add .cursor .gitmodules
git commit -m "chore: add cursor-rules as git submodule

## Summary
Added cursor-rules repository as git submodule to provide Cursor IDE 
rules and commands for consistent AI agent behavior.

## Changes Made
- Added .cursor submodule pointing to cursor-rules repository
- Created .gitmodules configuration
- All rules and commands now available in .cursor/ directory

## Next Steps
- Cursor IDE will automatically recognize rules
- Commands available in Cursor command palette
- See README.md for usage instructions"
```

### Step 4: Test in Cursor IDE

1. Open project in Cursor IDE
2. Rules should be automatically applied
3. Commands should be available in command palette
4. Test a command: `Cmd+Shift+P` → type "pre-flight-check"

---

## 3. Updating the Submodule

### Update to Latest Version

```bash
# Navigate to submodule
cd .cursor

# Pull latest changes
git pull origin main

# Return to main repository
cd ..

# Stage submodule update
git add .cursor

# Commit the update
git commit -m "chore(.cursor): update submodule to latest version

## Summary
Updated .cursor submodule to latest version from cursor-rules repository.

## Changes
- Updated submodule reference to commit [hash]
- Includes latest rules and commands
- See cursor-rules repository for changelog"
```

### Update All Submodules

If you have multiple submodules:

```bash
git submodule update --remote
git add .
git commit -m "chore: update all submodules to latest versions"
```

---

## 4. Version Pinning

### Pin to Specific Version/Tag

**To pin to a stable release:**

```bash
cd .cursor
git checkout v1.0.0  # or specific tag
cd ..
git add .cursor
git commit -m "chore(.cursor): pin submodule to version 1.0.0

## Summary
Pinned .cursor submodule to stable version 1.0.0 for production use.

## Context
Version 1.0.0 is a stable release with all required rules and commands.
Pinning ensures consistent behavior across environments.

## Changes
- Submodule now points to tag: v1.0.0
- Commit hash: [auto-set by git]
- All rules and commands from version 1.0.0"
```

### Pin to Specific Commit

```bash
cd .cursor
git checkout abc123def456  # specific commit hash
cd ..
git add .cursor
git commit -m "chore(.cursor): pin submodule to commit abc123

## Summary
Pinned .cursor submodule to specific commit for stability.

## Context
Commit abc123 contains a known-good state of rules that has been 
thoroughly tested in production.

## Changes
- Submodule now points to commit: abc123def456
- Includes rules and commands from that specific commit"
```

### View Available Versions

```bash
cd .cursor
git tag -l
git log --oneline --decorate | head -20
```

---

## 5. Troubleshooting

### Submodule Directory is Empty

**Symptom:** `.cursor` exists but is empty

**Solution:**
```bash
git submodule update --init --recursive
```

### Cursor IDE Not Recognizing Rules

**Symptom:** Rules not being applied

**Solutions:**
1. Verify submodule is initialized:
   ```bash
   ls .cursor/rules/
   # Should show .mdc files
   ```

2. Check submodule status:
   ```bash
   git submodule status
   # Should show commit hash, not empty
   ```

3. Restart Cursor IDE

4. Verify rule files have proper YAML frontmatter

### Submodule Out of Sync

**Symptom:** `git status` shows "modified: .cursor (new commits)"

**Solution:**
```bash
# Update to latest
cd .cursor && git pull origin main && cd ..
git add .cursor
git commit -m "chore(.cursor): update submodule"
```

### Detached HEAD State

**Symptom:** Submodule in detached HEAD state

**Solution:**
```bash
cd .cursor
git checkout main
git pull origin main
cd ..
git add .cursor
git commit -m "chore(.cursor): switch submodule to main branch"
```

---

## 6. CI/CD Integration

### GitHub Actions

```yaml
- name: Checkout with submodules
  uses: actions/checkout@v3
  with:
    submodules: recursive
    # Or: submodules: true  (for latest)
```

### GitLab CI

```yaml
variables:
  GIT_SUBMODULE_STRATEGY: recursive

# Or in job:
before_script:
  - git submodule update --init --recursive
```

### Jenkins

```groovy
checkout([
    $class: 'GitSCM',
    submodules: true,
    extensions: [[$class: 'SubmoduleOption', recursiveSubmodules: true]]
])
```

### Manual in Script

```bash
# In your build script
git submodule update --init --recursive
```

---

## Daily Workflow

### Normal Development (No Submodule Changes)

```bash
# Normal git workflow - submodule stays at pinned version
git pull origin main
# Make changes
git commit -m "..."
git push origin main
```

### When You Want Latest Rules

```bash
# Update submodule to latest
cd .cursor
git pull origin main
cd ..
git add .cursor
git commit -m "chore(.cursor): update to latest rules"
git push origin main
```

### When Adding New Rule (Advanced)

If you need to modify rules in the submodule:

1. **Work in submodule:**
   ```bash
   cd .cursor
   git checkout -b feat/new-rule
   # Make changes
   git commit -m "feat(rules): add new rule"
   git push origin feat/new-rule
   ```

2. **Create PR in cursor-rules repository**

3. **After merge, update main repo:**
   ```bash
   cd .cursor
   git checkout main
   git pull origin main
   cd ..
   git add .cursor
   git commit -m "chore(.cursor): update to include new rule"
   ```

---

## Best Practices

1. **Pin to Stable Versions in Production**
   - Use tags (e.g., `v1.0.0`) for production
   - Use `main` branch for development

2. **Regular Updates**
   - Update submodule regularly to get bug fixes
   - Test updates in development before production

3. **Document Your Version**
   - Note which version you're using in project README
   - Document why you pinned to specific version

4. **Team Coordination**
   - Coordinate submodule updates with team
   - Update submodule in separate commit for clarity

5. **CI/CD Configuration**
   - Always configure CI/CD to handle submodules
   - Test submodule initialization in CI

---

## Related Resources

- **Submodule Repository:** https://github.com/benlaube/cursor-rules
- **Main Repository:** https://github.com/benlaube/cursor-workflow-rules
- **README.md** - Overview and quick start
- **Git Submodule Docs:** https://git-scm.com/book/en/v2/Git-Tools-Submodules

---

**Last Updated:** 2025-01-27
