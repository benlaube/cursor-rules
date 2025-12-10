# Cursor Rules & Commands

This repository contains Cursor IDE rules and commands used across projects.

## Structure

- `rules/` - Cursor rules (`.mdc` files) that guide AI agent behavior
- `commands/` - Cursor commands (`.md` files) for executable workflows

## Usage

This repository is included as a git submodule in projects. **Important:** The submodule should be added to `cursor-rules/` (not `.cursor/`) to preserve project-specific `.cursor/` content.

### Quick Start

```bash
# Add submodule to cursor-rules/ directory
git submodule add https://github.com/benlaube/cursor-rules.git cursor-rules

# Run setup script to create symlinks
./scripts/setup-cursor-rules.sh
```

This creates:
- `cursor-rules/` - The submodule (contains rules/ and commands/)
- `.cursor/rules` - Symlink to `cursor-rules/rules`
- `.cursor/commands` - Symlink to `cursor-rules/commands`

### Why cursor-rules/ instead of .cursor/?

Projects may have additional content in `.cursor/` beyond rules and commands:
- Project-specific configurations
- Custom rules
- Other directories

Placing the submodule directly in `.cursor/` would overwrite this content. Using `cursor-rules/` with symlinks preserves project-specific content while providing shared rules and commands.

## Integration

See the main repository's `STANDARDS_INTEGRATION_GUIDE.md` for complete integration instructions, or run the setup script after adding the submodule.

## Versioning

This repository follows semantic versioning. Each release is tagged with a version number (e.g., `v1.0.0`).

## Contributing

When adding new rules or commands:
1. Follow the standards in the main repository
2. Update version numbers appropriately
3. Create detailed commit messages
4. Tag releases for stable versions
