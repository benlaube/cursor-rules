#!/bin/bash
# Verification script for cursor-rules submodule integration
set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CURSOR_DIR="${REPO_ROOT}/.cursor"
echo "🔍 Verifying cursor-rules submodule integration..."
if [ ! -d "$CURSOR_DIR" ]; then
    echo "❌ Error: .cursor directory not found"
    exit 1
fi
RULES_COUNT=$(find "${CURSOR_DIR}/rules" -name "*.mdc" 2>/dev/null | wc -l | tr -d " ")
COMMANDS_COUNT=$(find "${CURSOR_DIR}/commands" -name "*.md" 2>/dev/null | wc -l | tr -d " ")
echo "📊 Rules: $RULES_COUNT | Commands: $COMMANDS_COUNT"
if [ "$RULES_COUNT" -gt 0 ] && [ "$COMMANDS_COUNT" -gt 0 ]; then
    echo "✅ Integration verified!"
else
    echo "❌ Run: git submodule update --init --recursive"
    exit 1
fi
