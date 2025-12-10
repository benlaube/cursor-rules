# Cursor Rules & Commands

This repository contains Cursor IDE rules and commands used across projects.

## Structure

- `rules/` - Cursor rules (`.mdc` files) that guide AI agent behavior
- `commands/` - Cursor commands (`.md` files) for executable workflows

## Usage

This repository is typically included as a git submodule in projects:

```bash
git submodule add <repository-url> .cursor
```

## Integration

See the main repository's `STANDARDS_INTEGRATION_GUIDE.md` for integration instructions.

## Versioning

This repository follows semantic versioning. Each release is tagged with a version number (e.g., `v1.0.0`).

## Contributing

When adding new rules or commands:
1. Follow the standards in the main repository
2. Update version numbers appropriately
3. Create detailed commit messages
4. Tag releases for stable versions
