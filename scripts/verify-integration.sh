#!/bin/bash
# Verification script for cursor-rules submodule integration
# 
# This script verifies that the .cursor submodule is properly set up
# and all rules and commands are accessible.

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CURSOR_DIR="${REPO_ROOT}/.cursor"

echo "🔍 Verifying cursor-rules submodule integration..."
echo ""

# Check if .cursor exists
if [ ! -d "$CURSOR_DIR" ]; then
    echo "❌ Error: .cursor directory not found"
    echo "Run: git submodule add https://github.com/benlaube/cursor-rules.git .cursor"
    exit 1
fi

# Check if it's a submodule
if [ ! -f "${CURSOR_DIR}/.git" ] && [ ! -d "${CURSOR_DIR}/.git" ]; then
    echo "⚠️  Warning: .cursor doesn't appear to be a git submodule"
    echo "Expected: .cursor/.git file or directory"
fi

# Check submodule status
echo "📋 Submodule Status:"
git -C "$REPO_ROOT" submodule status .cursor 2>/dev/null || echo "  ⚠️  Not found in submodule list"

# Count rules and commands
RULES_COUNT=$(find "${CURSOR_DIR}/rules" -name "*.mdc" 2>/dev/null | wc -l | tr -d ' ')
COMMANDS_COUNT=$(find "${CURSOR_DIR}/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "📊 Content Verification:"
echo "  Rules (.mdc files): $RULES_COUNT"
echo "  Commands (.md files): $COMMANDS_COUNT"

if [ "$RULES_COUNT" -eq 0 ]; then
    echo "  ❌ No rules found!"
    echo "  Run: git submodule update --init --recursive"
fi

if [ "$COMMANDS_COUNT" -eq 0 ]; then
    echo "  ❌ No commands found!"
    echo "  Run: git submodule update --init --recursive"
fi

# Check for _project_specific folders
if [ -d "${CURSOR_DIR}/rules/_project_specific" ]; then
    echo "  ✓ _project_specific folder exists in rules/"
else
    echo "  ⚠️  _project_specific folder missing in rules/"
fi

if [ -d "${CURSOR_DIR}/commands/_project_specific" ]; then
    echo "  ✓ _project_specific folder exists in commands/"
else
    echo "  ⚠️  _project_specific folder missing in commands/"
fi

# Check .gitmodules
if grep -q "\.cursor" "${REPO_ROOT}/.gitmodules" 2>/dev/null; then
    echo ""
    echo "✅ .gitmodules configured correctly"
else
    echo ""
    echo "⚠️  Warning: .cursor not found in .gitmodules"
fi

echo ""
if [ "$RULES_COUNT" -gt 0 ] && [ "$COMMANDS_COUNT" -gt 0 ]; then
    echo "✅ Integration verified successfully!"
    echo ""
    echo "💡 Next steps:"
    echo "  - Open project in Cursor IDE"
    echo "  - Rules should be automatically applied"
    echo "  - Commands available in command palette"
else
    echo "❌ Integration incomplete. Please run:"
    echo "   git submodule update --init --recursive"
    exit 1
fi
