#!/bin/bash
# Setup protection for cursor-rules submodule
# 
# This script sets up file locking and git hooks to protect shared
# rules and commands from accidental modifications.
#
# Usage:
#   .cursor/scripts/setup-protection.sh

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CURSOR_DIR="${REPO_ROOT}/.cursor"
PARENT_GIT_DIR="${REPO_ROOT}/.git/modules/.cursor"

echo "🛡️  Setting up protection for cursor-rules..."
echo ""

# Step 1: Verify we're in a submodule
if [ ! -f "${CURSOR_DIR}/.git" ] && [ ! -d "${CURSOR_DIR}/.git" ]; then
    echo "❌ Error: .cursor is not a git submodule"
    exit 1
fi

# Step 2: Lock files immediately
if [ -f "${CURSOR_DIR}/.scripts/lock-rules.sh" ]; then
    echo "🔒 Locking files (read-only)..."
    bash "${CURSOR_DIR}/.scripts/lock-rules.sh" lock
    echo ""
else
    echo "  ⚠️  lock-rules.sh not found"
fi

# Step 3: Install git hooks in parent repository
if [ -d "$PARENT_GIT_DIR" ]; then
    HOOKS_DIR="${PARENT_GIT_DIR}/hooks"
    mkdir -p "$HOOKS_DIR"
    
    # Post-checkout hook (locks after submodule update)
    cat > "${HOOKS_DIR}/post-checkout" << 'HOOK_EOF'
#!/bin/bash
# Auto-lock cursor-rules files after checkout/update
if [ -f ".cursor/scripts/lock-rules.sh" ]; then
    bash .cursor/scripts/lock-rules.sh lock 2>/dev/null || true
fi
HOOK_EOF
    
    # Post-merge hook (locks after pull)
    cat > "${HOOKS_DIR}/post-merge" << 'HOOK_EOF'
#!/bin/bash
# Auto-lock cursor-rules files after merge/pull
if [ -f ".cursor/scripts/lock-rules.sh" ]; then
    bash .cursor/scripts/lock-rules.sh lock 2>/dev/null || true
fi
HOOK_EOF
    
    # Pre-commit hook (warns before committing to submodule)
    cat > "${HOOKS_DIR}/pre-commit" << 'HOOK_EOF'
#!/bin/bash
# Warn before committing to cursor-rules submodule
if git rev-parse --git-dir > /dev/null 2>&1; then
    # Check if we're committing to .cursor submodule
    if [ "$(git rev-parse --show-toplevel)" = "$(cd .cursor && git rev-parse --show-toplevel 2>/dev/null)" ] 2>/dev/null; then
        echo ""
        echo "⚠️  WARNING: You are committing to the cursor-rules submodule!"
        echo ""
        echo "This is a SHARED repository used by multiple projects."
        echo ""
        echo "Are you sure you want to commit these changes?"
        echo ""
        read -p "Continue with commit? (yes/no): " -r
        echo
        if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
            echo "❌ Commit aborted."
            echo ""
            echo "💡 If you need project-specific rules/commands:"
            echo "   Place them in .cursor/rules/_project_specific/ or"
            echo "   .cursor/commands/_project_specific/ (tracked by parent repo)"
            exit 1
        fi
    fi
fi
HOOK_EOF
    
    chmod +x "${HOOKS_DIR}/post-checkout"
    chmod +x "${HOOKS_DIR}/post-merge"
    chmod +x "${HOOKS_DIR}/pre-commit"
    
    echo "✅ Git hooks installed in parent repository"
    echo "   - post-checkout: Auto-locks after submodule update"
    echo "   - post-merge: Auto-locks after pull"
    echo "   - pre-commit: Warns before committing to submodule"
else
    echo "⚠️  Could not find parent git directory for hooks"
    echo "   File locking is active, but hooks not installed"
fi

echo ""
echo "✅ Protection setup complete!"
echo ""
echo "📋 Protection features:"
echo "  ✓ Files are read-only (prevents accidental edits)"
echo "  ✓ Git hooks warn before committing to submodule"
echo "  ✓ Auto-lock after submodule updates"
echo ""
echo "💡 To unlock files for editing:"
echo "   .cursor/.scripts/lock-rules.sh unlock"
echo ""
echo "💡 To make changes:"
echo "   1. Edit in cursor-rules repository (not here)"
echo "   2. Or use _project_specific/ folders for project-specific content"
