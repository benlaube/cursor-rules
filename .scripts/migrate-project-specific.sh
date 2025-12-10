#!/bin/bash
# Migrate existing project-specific rules/commands to _project_specific folders
# 
# This script helps identify and optionally move project-specific content
# that existed before the submodule conversion.
#
# Usage:
#   .cursor/.scripts/migrate-project-specific.sh [--dry-run] [--auto]
#
# Options:
#   --dry-run    Show what would be moved without actually moving files
#   --auto       Automatically move files without prompting

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CURSOR_DIR="${REPO_ROOT}/.cursor"
DRY_RUN=false
AUTO=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --auto)
            AUTO=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--dry-run] [--auto]"
            exit 1
            ;;
    esac
done

echo "🔍 Scanning for project-specific rules and commands..."
echo ""

# Check if we're in a submodule
if [ ! -f "${CURSOR_DIR}/.git" ] && [ ! -d "${CURSOR_DIR}/.git" ]; then
    echo "⚠️  Warning: .cursor doesn't appear to be a git submodule"
    echo "   This script is designed for submodule setups"
    echo ""
fi

# Get list of files tracked by the submodule
SUBMODULE_FILES=$(cd "${CURSOR_DIR}" && git ls-files 2>/dev/null || echo "")

# Find rules that are NOT in the submodule
PROJECT_RULES=()
PROJECT_COMMANDS=()

echo "📋 Checking rules..."
for rule in "${CURSOR_DIR}"/rules/**/*.mdc; do
    [ -f "$rule" ] || continue
    
    # Get relative path from .cursor
    REL_PATH="${rule#${CURSOR_DIR}/}"
    
    # Skip _project_specific folder
    [[ "$REL_PATH" == rules/_project_specific/* ]] && continue
    
    # Check if file is tracked by submodule
    if echo "$SUBMODULE_FILES" | grep -q "^${REL_PATH}$"; then
        # File is in submodule, skip
        continue
    else
        # File is NOT in submodule, likely project-specific
        PROJECT_RULES+=("$REL_PATH")
    fi
done

echo "📋 Checking commands..."
for cmd in "${CURSOR_DIR}"/commands/**/*.md; do
    [ -f "$cmd" ] || continue
    
    # Get relative path from .cursor
    REL_PATH="${cmd#${CURSOR_DIR}/}"
    
    # Skip _project_specific folder
    [[ "$REL_PATH" == commands/_project_specific/* ]] && continue
    
    # Check if file is tracked by submodule
    if echo "$SUBMODULE_FILES" | grep -q "^${REL_PATH}$"; then
        # File is in submodule, skip
        continue
    else
        # File is NOT in submodule, likely project-specific
        PROJECT_COMMANDS+=("$REL_PATH")
    fi
done

# Report findings
if [ ${#PROJECT_RULES[@]} -eq 0 ] && [ ${#PROJECT_COMMANDS[@]} -eq 0 ]; then
    echo "✅ No project-specific files found!"
    echo ""
    echo "All rules and commands appear to be from the submodule."
    echo "If you have project-specific content, place it in:"
    echo "  - .cursor/rules/_project_specific/"
    echo "  - .cursor/commands/_project_specific/"
    exit 0
fi

echo ""
echo "📦 Found project-specific files:"
echo ""

if [ ${#PROJECT_RULES[@]} -gt 0 ]; then
    echo "  Rules (${#PROJECT_RULES[@]}):"
    for rule in "${PROJECT_RULES[@]}"; do
        echo "    - $rule"
    done
    echo ""
fi

if [ ${#PROJECT_COMMANDS[@]} -gt 0 ]; then
    echo "  Commands (${#PROJECT_COMMANDS[@]}):"
    for cmd in "${PROJECT_COMMANDS[@]}"; do
        echo "    - $cmd"
    done
    echo ""
fi

# Ask for confirmation unless --auto
if [ "$AUTO" = false ] && [ "$DRY_RUN" = false ]; then
    echo "❓ Move these files to _project_specific folders? (yes/no): "
    read -r CONFIRM
    if [[ ! $CONFIRM =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "❌ Migration cancelled"
        exit 0
    fi
    echo ""
fi

# Move files
MOVED_COUNT=0

if [ ${#PROJECT_RULES[@]} -gt 0 ]; then
    echo "📦 Moving rules to _project_specific..."
    mkdir -p "${CURSOR_DIR}/rules/_project_specific"
    
    for rule in "${PROJECT_RULES[@]}"; do
        SRC="${CURSOR_DIR}/${rule}"
        FILENAME=$(basename "$rule")
        DEST="${CURSOR_DIR}/rules/_project_specific/${FILENAME}"
        
        # Handle name conflicts
        if [ -f "$DEST" ]; then
            COUNTER=1
            while [ -f "$DEST" ]; do
                DEST="${CURSOR_DIR}/rules/_project_specific/${FILENAME%.*}_${COUNTER}.${FILENAME##*.}"
                COUNTER=$((COUNTER + 1))
            done
        fi
        
        if [ "$DRY_RUN" = true ]; then
            echo "  [DRY RUN] Would move: $rule → _project_specific/$(basename "$DEST")"
        else
            mv "$SRC" "$DEST"
            echo "  ✓ Moved: $rule → _project_specific/$(basename "$DEST")"
            MOVED_COUNT=$((MOVED_COUNT + 1))
        fi
    done
    echo ""
fi

if [ ${#PROJECT_COMMANDS[@]} -gt 0 ]; then
    echo "📦 Moving commands to _project_specific..."
    mkdir -p "${CURSOR_DIR}/commands/_project_specific"
    
    for cmd in "${PROJECT_COMMANDS[@]}"; do
        SRC="${CURSOR_DIR}/${cmd}"
        FILENAME=$(basename "$cmd")
        DEST="${CURSOR_DIR}/commands/_project_specific/${FILENAME}"
        
        # Handle name conflicts
        if [ -f "$DEST" ]; then
            COUNTER=1
            while [ -f "$DEST" ]; do
                DEST="${CURSOR_DIR}/commands/_project_specific/${FILENAME%.*}_${COUNTER}.${FILENAME##*.}"
                COUNTER=$((COUNTER + 1))
            done
        fi
        
        if [ "$DRY_RUN" = true ]; then
            echo "  [DRY RUN] Would move: $cmd → _project_specific/$(basename "$DEST")"
        else
            mv "$SRC" "$DEST"
            echo "  ✓ Moved: $cmd → _project_specific/$(basename "$DEST")"
            MOVED_COUNT=$((MOVED_COUNT + 1))
        fi
    done
    echo ""
fi

if [ "$DRY_RUN" = true ]; then
    echo "✅ Dry run complete. No files were moved."
    echo ""
    echo "Run without --dry-run to actually move files."
else
    echo "✅ Migration complete! Moved $MOVED_COUNT file(s)"
    echo ""
    echo "💡 Next steps:"
    echo "   1. Review moved files in _project_specific folders"
    echo "   2. Commit to parent repository (not submodule):"
    echo "      git add .cursor/rules/_project_specific/"
    echo "      git add .cursor/commands/_project_specific/"
    echo "      git commit -m 'chore: move project-specific rules/commands to _project_specific'"
fi
