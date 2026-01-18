---
description: Run pre-flight checks before starting any coding task. Validates environment, git status, dependencies, and baseline integrity.
version: 1.0.1
lastUpdated: 01-13-2026 01:22:00 EST
lastupdatedby: Codex (GPT-5)
globs:
---

# Pre-Flight Check Command

Use this command to validate your environment and repository state before starting any coding task. This is the **first command** you should run before making significant changes.

**Source Checklist:** None (this command is the source of truth; the checklist reference in `docs/INDEX.md` is stale)

## Usage

@agent: When starting a new task or before making significant changes, run this command first.

**Automation Script:** `scripts/pre-flight-check.sh`

## Execution Steps

### 1. Git Status Validation

1. **Check Current Branch:**
   - Get current branch: `git branch --show-current`
   - Verify branch name follows format: `project-taskId-short-title`
   - If on `main` or `master`, warn: "⚠️ You are on main branch. Consider creating a feature branch."
   - If branch name doesn't match format, suggest: "Consider renaming to match format: `project-taskId-short-title`"

2. **Check Working Tree:**
   - Run: `git status --porcelain`
   - If there are uncommitted changes:
     - List them
     - Warn: "⚠️ Working tree is not clean. Consider committing or stashing changes before proceeding."
   - If clean: ✅ "Working tree is clean"

3. **Sync with Remote:**
   - Check if behind: `git fetch origin && git rev-list HEAD..origin/main --count`
   - If behind, warn: "⚠️ Local branch is behind origin/main. Run `git pull origin main` to sync."
   - If up to date: ✅ "Local branch is synced with origin/main"

### 2. Environment Validation

1. **Git Hooks Check:**
   - Verify `.husky/` directory exists
   - Verify `.husky/pre-commit` and `.husky/commit-msg` exist
   - Check `git config core.hooksPath` is set to `.husky`
   - If missing, suggest: `npm run prepare`

1. **Dependencies Check:**
   - **Node.js (repo root):** Check `node_modules` in repo root.
     - If missing: `npm install`
   - **Node.js (apps/web):** Check `apps/web/node_modules`.
     - If missing: `npm install --prefix apps/web`
   - **Python:** Check for `venv/` or `.venv/` (repo uses `venv/` today).
     - If missing: create and install `pip install -r requirements.txt`
   - ✅ "Dependencies are up to date"

2. **Configuration Check:**
   - Verify **root** `.env` or `.env.local` exists (server-only secrets live here).
   - Verify **Next.js** `apps/web/.env.local` exists.
   - If missing:
     - Copy `apps/web/.env.example` → `apps/web/.env.local`
     - Warn: "⚠️ Created `.env.local` from `.env.example`. Fill in required secrets."
   - Compare `apps/web/.env.local` vs `apps/web/.env.example` for missing keys.
   - ✅ "Configuration files exist and have required keys"

3. **Secrets Validation:**
   - For Supabase projects:
     - Root: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` (server-side)
     - apps/web: `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - ✅ "Secrets are properly configured"

### 3. Baseline Integrity

1. **Tests:**
   - Run: `npm run test` (root script proxies to `apps/web`)
   - If tests fail:
     - Display failing tests
     - **ABORT:** "❌ Tests are failing. Fix tests before proceeding."
   - If pass: ✅ "All tests pass"

2. **Build:**
   - Run: `npm run build` (root script proxies to `apps/web`)
   - If build fails:
     - Display build errors
     - **ABORT:** "❌ Build is failing. Fix build errors before proceeding."
   - If succeeds: ✅ "Project builds successfully"

3. **Linter:**
   - Run: `npm run lint` (root script proxies to `apps/web`)
   - If linter errors exist:
     - Display errors
     - Warn: "⚠️ Linter errors found. Consider fixing before adding new code."
     - Option to auto-fix: `npm run lint:fix`
   - If clean: ✅ "No linter errors"
   - **Reference:** See `docs/standards/` for linting standards

### 4. Task Understanding

1. **Requirements Check:**
   - Prompt: "Do you understand the goal of this task?"
   - If unclear, suggest reviewing task description or requirements

2. **Documentation Review:**
   - Check if relevant standards exist in `standards/`
   - List relevant standards for the task
   - Suggest: "Review relevant standards before proceeding"

3. **Planning:**
   - Prompt: "Do you have a clear plan or todo list?"
   - If not, suggest creating a todo list

---

## Output

### Success Case

```
✅ Pre-flight check complete – safe to start coding.

Summary:
- Git: Clean working tree, synced with origin/main
- Environment: Dependencies installed, .env configured
- Baseline: Tests pass, build succeeds, no linter errors
- Task: Ready to proceed
```

### Failure Case

```
❌ Pre-flight check failed. Please address the following:

Issues:
- Git: Working tree has uncommitted changes
- Tests: 2 tests failing in auth.test.ts
- Linter: 5 errors in src/utils/helpers.ts

Action required: Fix issues above before proceeding.
```

---

## Self-Healing Actions

This command will automatically:

- Install missing dependencies (`npm install`, `npm install --prefix apps/web`)
- Create `apps/web/.env.local` from `apps/web/.env.example` if missing
- Attempt to auto-fix linter errors via `npm run lint:fix`

---

## Optional Automation Hooks (Recommended)

If you want this checklist to be fully automated, use `scripts/pre-flight-check.sh` (added) or a wrapper that performs the steps below:

1. **Install dependencies automatically**
   - Root: `npm install`
   - Web app: `npm install --prefix apps/web`

2. **Auto-fix lint issues**
   - `npm run lint:fix`
   - (Pre-commit already uses `node scripts/pre-commit/lint-staged-fix.js` for staged files)

3. **Standard commands (root)**
   - `npm run lint`
   - `npm run test`
   - `npm run build`

---

## Script Usage

```bash
./scripts/pre-flight-check.sh
```

Optional flags:

- `LINT_FIX=1` run lint with auto-fix
- `SKIP_LINT=1` skip lint
- `SKIP_TESTS=1` skip tests
- `SKIP_BUILD=1` skip build
- `RUN_HUSKY=1` run `.husky/pre-commit` for a full pre-commit dry run

---

## Related Commands

- `launch_application_dev` - Launch development environment (runs after pre-flight)
- `pr-review-check` - Validate before submitting PR
- `project-audit` - Full project health check

---

## Integration with AGENTS.md

This command is referenced in `AGENTS.md` as the **first step** in the standard developer lifecycle. Always run this before starting significant coding work.
