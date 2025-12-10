# Cursor Rules & Commands

This repository contains Cursor IDE rules and commands used across projects.

## Structure

- `rules/` - Cursor rules (`.mdc` files) that guide AI agent behavior
- `commands/` - Cursor commands (`.md` files) for executable workflows

## Usage

This repository is included as a git submodule in projects. **The submodule is added directly to `.cursor/`** - this is the simplest and most direct approach.

### Quick Start

```bash
# Add submodule directly to .cursor/ directory
git submodule add https://github.com/benlaube/cursor-rules.git .cursor
```

This creates:
- `.cursor/` - The submodule (contains rules/ and commands/ at root)
- `.cursor/rules/` - All Cursor rules (tracked by submodule)
- `.cursor/commands/` - All Cursor commands (tracked by submodule)

### Project-Specific Content

Projects can still add project-specific files to `.cursor/`:
- These files are tracked by the **parent repository** (not the submodule)
- They coexist with the submodule content
- Example: `.cursor/project-config.json` (project-specific, in parent repo)

**How it works:**
- Files in `.cursor/rules/` and `.cursor/commands/` are tracked by the submodule
- Other files in `.cursor/` are tracked by the parent repository
- Git automatically handles this separation

## Integration

### Quick Integration

```bash
# Add submodule
git submodule add https://github.com/benlaube/cursor-rules.git .cursor

# Set up file protection (recommended)
.cursor/.scripts/setup-protection.sh

# Verify installation (optional)
.cursor/.scripts/verify-integration.sh
```

### Complete Guide

See `INTEGRATION_SETUP.md` in this repository for complete integration instructions, or the main repository's `STANDARDS_INTEGRATION_GUIDE.md` for full workflow integration.

## File Protection

Files are protected by default to prevent accidental modifications:

- **Read-only permissions** - Files are locked (read-only) by default
- **Git hooks** - Require confirmation before committing to submodule
- **Auto-locking** - Files automatically locked after updates

**To unlock for editing:**
```bash
.cursor/.scripts/lock-rules.sh unlock
```

**See `INTEGRATION_SETUP.md` Section 10 for complete protection guide.**

## Versioning

This repository follows semantic versioning. Each release is tagged with a version number (e.g., `v1.0.0`).

## Contributing

When adding new rules or commands:
1. Follow the standards in the main repository
2. Update version numbers appropriately
3. Create detailed commit messages
4. Tag releases for stable versions
