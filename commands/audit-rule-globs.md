# audit-rule-globs

## Metadata

- **Status:** Active
- **Created:** 12-09-2025 11:30:32 EST
- **Last Updated:** 12-09-2025 11:30:32 EST
- **Version:** 1.0.0
- **Description:** Audits all Cursor rule files (`.mdc`) to validate glob pattern formatting according to cursor-rules-standards.md. Checks for proper spacing, quotes, empty string usage, and pattern validity.
- **Type:** Executable Command - Used by AI agents for rule maintenance and validation
- **Applicability:** When performing periodic maintenance, after rule updates, or when validating rule file structure
- **How to Use:** Run `audit-rule-globs` to scan all rule files and validate glob pattern formatting
- **Dependencies:** None
- **Related Cursor Commands:** [audit-documentation-rules-metadata.md](./audit-documentation-rules-metadata.md), [validate-rule-metadata.md](./validate-rule-metadata.md)
- **Related Cursor Rules:** [cursor-rule-creation.mdc](../rules/cursor-rule-creation.mdc), [cursor-rules-standards.md](../../standards/process/cursor-rules-standards.md)
- **Related Standards:** [process/cursor-rules-standards.md](../../standards/process/cursor-rules-standards.md)

---

## Purpose

Systematically review all Cursor rule files (`.mdc`) to ensure glob patterns are properly formatted according to `standards/process/cursor-rules-standards.md` Section 3.1. This command validates:

- Proper spacing in comma-separated patterns
- No quotes around glob values
- Empty string when `alwaysApply: true`
- Valid glob pattern syntax
- Consistency with `alwaysApply` field

---

## When to Run

- **Periodic Maintenance:** Monthly or quarterly rule audits
- **After Rule Updates:** When rules are created or modified
- **Before Releases:** As part of release preparation
- **Onboarding:** When adopting this standards library in a new project
- **After Standard Updates:** When cursor-rules-standards.md is updated

---

## Command Invocation

Use this command name in your AI assistant:

```
audit-rule-globs
```

---

## Execution Steps

When this command is invoked, the AI agent should:

### Step 1: Identify Target Files

1. **Rule Files (`.mdc`):**
   - All files in `.cursor/rules/` directory (recursive)
   - Include nested subdirectories (e.g., `workflow/variants/`, `modules/`, etc.)

2. **Exclusions:**
   - `node_modules/`
   - Archive directories
   - Template files in `templates/` (unless explicitly requested)

### Step 2: Extract and Validate Glob Patterns

For each `.mdc` file:

1. **Extract YAML Frontmatter:**
   - Read the file and extract the YAML frontmatter block (between `---` delimiters)
   - Parse `globs:` field value
   - Parse `alwaysApply:` field value

2. **Validate Glob Formatting:**

   **Check 1: Presence of globs field**
   - ✅ `globs:` field must exist in frontmatter
   - ❌ Missing `globs:` field

   **Check 2: Quotes (should NOT have quotes)**
   - ✅ No quotes: `globs: **/*.ts`
   - ❌ Has quotes: `globs: "**/*.ts"` or `globs: '**/*.ts'`

   **Check 3: Empty string when alwaysApply is true**
   - ✅ If `alwaysApply: true`, then `globs: ""` (empty string)
   - ❌ If `alwaysApply: true` but globs has pattern
   - ❌ If `alwaysApply: false` but globs is empty

   **Check 4: Comma spacing (multiple patterns)**
   - ✅ Proper spacing: `globs: **/*.ts, **/*.tsx, **/*.js`
   - ❌ Missing spaces: `globs: **/*.ts,**/*.tsx,**/*.js`
   - ✅ Single pattern: `globs: **/*.ts` (no comma needed)

   **Check 5: Pattern syntax validity**
   - ✅ Valid glob patterns (basic validation):
     - `**/*.ts` - Recursive file pattern
     - `**/dir/**` - Recursive directory pattern
     - `**/*.{ts,tsx}` - Multiple extensions
     - `dir/**/*.ts` - Specific directory
   - ⚠️ Potentially invalid patterns (flag for review):
     - Patterns with spaces (unless quoted, but quotes are invalid)
     - Patterns with special characters that might need escaping
     - Empty patterns (should be `""` not just whitespace)

   **Check 6: Consistency with alwaysApply**
   - ✅ `alwaysApply: true` → `globs: ""`
   - ✅ `alwaysApply: false` → `globs: [pattern]` (non-empty)
   - ❌ Mismatch between `alwaysApply` and `globs` value

### Step 3: Generate Validation Report

For each file, create a report entry:

````markdown
### [File Path]

**Status:** ✅ Valid | ⚠️ Needs Fix | ❌ Invalid

**Current State:**

- `alwaysApply:` [value]
- `globs:` [current value]

**Issues Found:**

- [ ] Missing globs field
- [ ] Has quotes (should be removed)
- [ ] Empty string mismatch with alwaysApply
- [ ] Missing spaces after commas
- [ ] Invalid pattern syntax
- [ ] Consistency issue with alwaysApply

**Proposed Fix:**

```yaml
globs: [corrected value]
```
````

**Explanation:**
[Brief explanation of what needs to be fixed]

````

### Step 4: Generate Summary Report

Create a comprehensive summary:

```markdown
# Rule Globs Audit Report
**Generated:** [DD-MM-YYYY HH:MM:SS EST]

## Overview
- Total Rule Files Audited: X
- Files with Valid Globs: X (XX%)
- Files Needing Fixes: X
- Files with Critical Issues: X

## Issues Breakdown
- Missing globs field: X files
- Has quotes: X files
- Empty string mismatch: X files
- Missing comma spacing: X files
- Invalid pattern syntax: X files
- Consistency issues: X files

## Files by Status
### ✅ Valid (X files)
- [file1.mdc](path)
- [file2.mdc](path)

### ⚠️ Needs Fix (X files)
- [file3.mdc](path) - [issue description]
- [file4.mdc](path) - [issue description]

### ❌ Invalid (X files)
- [file5.mdc](path) - [critical issue]
````

### Step 5: Propose Fixes (with Confirmation)

For each file with issues:

1. **Show current state:**
   - Display current `globs:` and `alwaysApply:` values
   - Highlight the specific issue

2. **Propose corrected globs value:**
   - Show proposed `globs:` value
   - Explain the fix (e.g., "Added spaces after commas", "Removed quotes", "Set to empty string for alwaysApply: true")

3. **Wait for confirmation** before updating

4. **Update the file** if approved:
   - Modify only the `globs:` field in YAML frontmatter
   - Preserve all other content
   - Ensure proper YAML formatting

### Step 6: Validation Rules Reference

Reference the standard for validation:

**From `standards/process/cursor-rules-standards.md` Section 3.1:**

- **globs** (REQUIRED): File pattern(s) this rule applies to (NO quotes in .mdc files)
  - **Required field** - must be present in all rules
  - If `alwaysApply: true`, use empty string: `globs: ""`
  - If `alwaysApply: false`, specify pattern: `globs: **/*.ts` or `globs: **/*.{ts,tsx}`
  - Examples:
    - `globs: ""` (when alwaysApply is true)
    - `globs: **/*.ts` (TypeScript files)
    - `globs: **/*.{ts,tsx}` (TypeScript and TSX files)
    - `globs: **/api/**, **/routes/**` (Multiple patterns with spaces)

---

## Expected Output

### Success Case

```
I'll audit all rule files for proper glob pattern formatting.

Scanning .cursor/rules/ directory...
Found 76 rule files (.mdc)

Audit complete! Here's the summary:
- 76 files audited
- 65 files have valid globs (86%)
- 11 files need fixes

Issues found:
- Missing comma spacing: 8 files
- Has quotes: 2 files
- Empty string mismatch: 1 file

Would you like me to:
1. Show detailed report for all files
2. Fix files with issues (I'll show you changes first)
3. Show only files with issues
```

### Failure Case

```
Error: Could not parse YAML frontmatter in [file.mdc]
- Invalid YAML syntax at line X
- Missing closing `---` delimiter

Please fix the YAML syntax before running the audit.
```

---

## Validation Checklist

After running the audit, verify:

- [ ] All rule files have `globs:` field
- [ ] No globs values have quotes
- [ ] All `alwaysApply: true` rules have `globs: ""`
- [ ] All `alwaysApply: false` rules have non-empty globs
- [ ] All comma-separated patterns have spaces after commas
- [ ] All glob patterns use valid syntax
- [ ] Report generated with clear issue descriptions
- [ ] Proposed fixes are accurate and follow the standard

---

## Integration with Other Rules

This command works with:

### `cursor-rule-creation.mdc`

- That rule enforces rule structure standards
- This command validates one specific aspect (globs formatting)
- Both ensure rules follow `cursor-rules-standards.md`

### `audit-documentation-rules-metadata.md`

- That command audits all metadata fields
- This command focuses specifically on globs formatting
- Can be run as part of comprehensive metadata audit

---

## Related Files

- **Commands:**
  - [audit-documentation-rules-metadata.md](./audit-documentation-rules-metadata.md) - Comprehensive metadata audit
  - [validate-rule-metadata.md](./validate-rule-metadata.md) - Rule metadata validation
- **Rules:**
  - [cursor-rule-creation.mdc](../rules/cursor-rule-creation.mdc) - Rule creation standards
- **Standards:**
  - [process/cursor-rules-standards.md](../../standards/process/cursor-rules-standards.md) - **GOVERNING STANDARD** (Section 3.1 for globs)

---

## How to Use This Command

**This command can be run manually or as part of periodic maintenance.**

**Agents should:**

1. Scan all `.mdc` files in `.cursor/rules/` (recursive)
2. Extract and validate `globs:` field from YAML frontmatter
3. Check against all validation rules (quotes, spacing, empty string, consistency)
4. Generate detailed report with issues and proposed fixes
5. Wait for user confirmation before updating files
6. Reference `cursor-rules-standards.md` Section 3.1 for validation rules

**Validation checklist:**

- [ ] All rule files scanned
- [ ] YAML frontmatter parsed correctly
- [ ] All validation checks performed
- [ ] Issues clearly identified and categorized
- [ ] Proposed fixes follow the standard
- [ ] Report generated with statistics
- [ ] User confirmation requested before updates

---

## Notes

- **Be Precise:** Only modify the `globs:` field, preserve all other content
- **Follow Standard:** Always reference `cursor-rules-standards.md` Section 3.1
- **Preserve YAML:** Ensure YAML formatting remains valid after updates
- **Batch Updates:** Update files in batches, show changes before applying
- **Validation:** After updating, re-run audit to verify fixes

---

## Examples

### Example 1: Missing Spaces After Commas

**Current:**

```yaml
globs: **/*.test.{ts,tsx,js,jsx},**/*.spec.{ts,tsx,js,jsx},**/test/**
```

**Fixed:**

```yaml
globs: **/*.test.{ts,tsx,js,jsx}, **/*.spec.{ts,tsx,js,jsx}, **/test/**
```

### Example 2: Has Quotes

**Current:**

```yaml
globs: '**/*.ts'
```

**Fixed:**

```yaml
globs: **/*.ts
```

### Example 3: Empty String Mismatch

**Current:**

```yaml
alwaysApply: true
globs: **/*.ts
```

**Fixed:**

```yaml
alwaysApply: true
globs: ''
```

### Example 4: Proper Formatting

**Current (Correct):**

```yaml
alwaysApply: false
globs: **/db/**, **/schema/**, **/models/**, **/types/**
```

**Status:** ✅ Valid - No changes needed
