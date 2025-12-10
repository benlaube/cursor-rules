#!/bin/bash
# Lock cursor-rules files to prevent accidental modifications
# 
# This script makes all rules and commands read-only to remind developers
# that these are shared files managed in the cursor-rules repository.
# 
# Usage:
#   .cursor/.scripts/lock-rules.sh        # Lock files (read-only)
#   .cursor/.scripts/lock-rules.sh unlock  # Unlock files (writable)

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CURSOR_DIR="${REPO_ROOT}/.cursor"
ACTION="${1:-lock}"

if [ ! -d "$CURSOR_DIR" ]; then
    echo "❌ Error: .cursor directory not found"
    exit 1
fi

if [ "$ACTION" = "unlock" ]; then
    echo "🔓 Unlocking cursor-rules files..."
    
    # Make rules writable
    find "${CURSOR_DIR}/rules" -type f -name "*.mdc" -exec chmod u+w {} \; 2>/dev/null || true
    
    # Make commands writable
    find "${CURSOR_DIR}/commands" -type f -name "*.md" -exec chmod u+w {} \; 2>/dev/null || true
    
    # Count unlocked files
    RULES_COUNT=$(find "${CURSOR_DIR}/rules" -type f -name "*.mdc" -perm -u+w 2>/dev/null | wc -l | tr -d ' ')
    COMMANDS_COUNT=$(find "${CURSOR_DIR}/commands" -type f -name "*.md" -perm -u+w 2>/dev/null | wc -l | tr -d ' ')
    
    echo "✅ Unlocked $RULES_COUNT rules and $COMMANDS_COUNT commands"
    echo "⚠️  Remember: Changes should be made in cursor-rules repository, not here!"
    
else
    echo "🔒 Locking cursor-rules files (read-only)..."
    echo ""
    echo "📝 Note: These files are shared from the cursor-rules repository."
    echo "   To modify rules/commands, make changes in the cursor-rules repo."
    echo "   Use 'unlock' if you need to edit locally for testing."
    echo ""
    
    # Make rules read-only
    find "${CURSOR_DIR}/rules" -type f -name "*.mdc" -exec chmod u-w {} \; 2>/dev/null || true
    
    # Make commands read-only
    find "${CURSOR_DIR}/commands" -type f -name "*.md" -exec chmod u-w {} \; 2>/dev/null || true
    
    # Count locked files
    RULES_COUNT=$(find "${CURSOR_DIR}/rules" -type f -name "*.mdc" ! -perm -u+w 2>/dev/null | wc -l | tr -d ' ')
    COMMANDS_COUNT=$(find "${CURSOR_DIR}/commands" -type f -name "*.md" ! -perm -u+w 2>/dev/null | wc -l | tr -d ' ')
    
    echo "✅ Locked $RULES_COUNT rules and $COMMANDS_COUNT commands (read-only)"
    echo ""
    echo "💡 To unlock for editing: .cursor/.scripts/lock-rules.sh unlock"
    echo "💡 To make changes: Edit in cursor-rules repository and update submodule"
fi
