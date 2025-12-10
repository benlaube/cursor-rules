# create-agents-file

## Metadata

- **Status:** Active
- **Created:** 12-04-2025 14:32:51 EST
- **Last Updated:** 01-27-2025 15:30:00 EST
- **Version:** 2.0.0
- **Description:** Create a project-specific `AGENTS.md` file in THIS repo, based on the shared `templates/file-templates/AGENTS-TEMPLATE.md` template, if `AGENTS.md` does not already exist. The generated file is meant to be the AI Developer Agent context & memory document described in the template.
- **Type:** Executable Command - Used by AI agents to automate AGENTS.md creation
- **Audience:** AI agents setting up new projects
- **Applicability:** When setting up a new project that needs an AGENTS.md file, or when onboarding a project to the workflow rules system
- **How to Use:** Run this command to create a project-specific AGENTS.md file based on the template. The command will adapt the template to the current project's structure and requirements
- **Dependencies:** [templates/file-templates/AGENTS-TEMPLATE.md](../../templates/file-templates/AGENTS-TEMPLATE.md)
- **Related Cursor Commands:** [integrate-cursor-workflow-standards.md](./integrate-cursor-workflow-standards.md)
- **Related Cursor Rules:** [workflow/task-workflow.mdc](../rules/workflow/task-workflow.mdc), [documentation/documentation-metadata.mdc](../rules/documentation/documentation-metadata.mdc)
- **Related Standards:** [project-planning/documentation-management.md](../../standards/project-planning/documentation-management.md)

---

## Purpose

Create a project-specific `AGENTS.md` file in THIS repo, based on the shared `templates/file-templates/AGENTS-TEMPLATE.md` template, **if `AGENTS.md` does not already exist**. The generated file is meant to be the **AI Developer Agent context & memory** document described in the template.

> NOTE: This command assumes the template has the structure shown in `templates/file-templates/AGENTS-TEMPLATE.md` (sections 1–9: Project Mission, Current Phase, Active Context, Architecture Highlights, Persistent Memory, Standard Developer Lifecycle, Agent Rules of Engagement, Related Checklists & Commands, Quick Reference). The template includes metadata at the top and references to workflow variants, task-workflow.mdc rule, git workflow rules, and module-specific rules.

---

## A. Project Identity & Existing Files

1. Assume the current working directory is the project root (e.g., `/benlaube/apps/<project>`).
2. Derive:
   - `PROJECT_NAME` from the folder name.
   - `PROJECT_PATH` as a relative or canonical path (e.g., `/benlaube/apps/<project>`).
3. Look for the following files in this project:
   - `AGENTS.md`
   - `PROJECT_AUDIT.md`
   - `README.md`
   - `docs/TECH_STACK.md` or `standards/project-planning/tech-stack-document.md`
   - `.cursorrules` or project rules files (for Notion binding / commands info)
   - `.cursor/commands/` (for command names like `pre-flight-check`, `create-start-scripts`, `pr-review-check`, etc.)
   - `.cursor/rules/` (for workflow rules like `task-workflow.mdc`, `pre-flight-check.mdc`, etc.)

4. If `AGENTS.md` already exists:
   - **Do not overwrite it.**
   - Optionally:
     - Scan it for gross mismatches with the current standards (e.g., missing sections, clearly outdated references to non‑existent commands), but only make minimal, safe improvements.
   - In your final response, clearly state that `AGENTS.md` already existed and was not replaced.
   - **Stop the command here.**

---

## B. Fetch the Template Content

1. Obtain the contents of `templates/file-templates/AGENTS-TEMPLATE.md`:
   - Read from `templates/file-templates/AGENTS-TEMPLATE.md` in the current repository.
   - If that doesn't exist, try `templates/general/AGENTS-TEMPLATE.md` or `standards/templates/AGENTS-TEMPLATE.md`.
2. If the template cannot be read for any reason:
   - Do **not** invent a completely new structure.
   - Abort gracefully and report the failure in your final response.

> The template structure includes:
>
> - **Metadata section** at the top (Created, Last Updated, Version, Description)
> - Sections 1–9: Project Mission, Current Phase, Active Context, System Architecture Highlights, Persistent Memory, Standard Developer Lifecycle (with Section 6.0 Requirements Clarification and workflow variants), Agent Rules of Engagement, Related Checklists & Commands, Quick Reference
> - References to `.cursor/rules/task-workflow.mdc` as the authoritative workflow rule
> - Git workflow rules section (Section 7 or 8)
> - Module-specific rules section (Section 7 or 8)

---

## C. Adapt Template → Project-Specific AGENTS.md

You will **start from the template text as-is** and then selectively adapt/fill fields. The goal is to:

- Keep the template’s section structure and explanation paragraphs.
- Fill in what can be reasonably derived from this project.
- Leave other fields clearly marked as TODO for a human or later agent.

### C.0 Metadata Section (Before Section 1)

1. The template includes a **Metadata** section at the top. Ensure it includes:
   - **Created:** Set to current date (format: `YYYY-MM-DD` or `DD-MM-YYYY` per project standards)
   - **Last Updated:** Set to current date/time (format: `DD-MM-YYYY HH:MM:SS EST` per `.cursor/rules/date-time.mdc`)
   - **Version:** Start at `1.0` or `1.0.0`
   - **Description:** "Project context and memory for AI Developer Agent"
   - Keep the CRITICAL NOTE about AI Developer Agent vs runtime agents

### C.1 Project Mission (Section 1)

1. If `PROJECT_AUDIT.md` or `README.md` contains a clear one‑sentence mission or tagline, use it to replace:
   - `**[One-Sentence Mission Statement Here]**`
2. If no clear mission statement is available:
   - Leave the placeholder text but prepend `TODO:` to make it obvious, e.g.:
     - `**TODO: [One-Sentence Mission Statement Here]**`

### C.2 Current Phase (Section 2)

1. If the project has an obvious phase documented (e.g., in `PROJECT_AUDIT.md` or README), populate:
   - `## 2. Current Phase: [Phase Name, e.g., "Foundation"]`
2. Otherwise, keep the placeholder but mark it with `TODO` and leave the example checklist bullets intact.

### C.3 Active Context (Section 3)

1. If there is a recent, clearly defined active task (from Notion binding, `CLEAN_UP_TO_DO.md`, or local docs), you may set:
   - **Latest Task** to that description (short).
   - **Blocking Issues** and **Next Up** if they are obvious.
2. If not, leave generic placeholders, but keep the text instructive for future updates.

### C.4 System Architecture Highlights (Section 4)

1. If `docs/TECH_STACK.md` or `standards/project-planning/tech-stack-document.md` exists:
   - Update the reference line to point to the actual file:
     > `> **Note:** This repository is a [description]. For full details, see \`standards/project-planning/tech-stack-document.md\` or \`docs/TECH_STACK.md\`.`
   - Optionally skim the tech stack doc to fill:
     - **Frontend:** e.g., `Next.js / React`
     - **Backend:** e.g., `Supabase (Edge Functions, Postgres)`, `FastAPI`, etc.
     - **Auth:** e.g., `Supabase Auth`, `NextAuth.js`, etc.
     - **Styling:** e.g., `Tailwind CSS`.
2. If no tech stack doc exists:
   - Infer from `package.json` / `pyproject.toml` and fill what you can.
   - If still uncertain, leave placeholders, but keep section structure.
   - Update the reference to note that tech stack documentation should be created.

### C.5 Persistent Memory (Section 5)

1. Copy the template bullet examples **unchanged**, unless you already have project-specific learnings recorded elsewhere (e.g., in `PROJECT_AUDIT.md` or standards).
2. If you have real persistent learnings (e.g., naming conventions, testing patterns) in existing docs, you may add 1–3 bullets below the examples.
3. Preserve the idea that this list grows over time; do not over‑summarize.

### C.6 Standard Developer Lifecycle (Section 6)

This section heavily references commands, checklists, and the authoritative `task-workflow.mdc` rule.

1. **Section 6.0 (Requirements Clarification):** The template includes a new Section 6.0 for Requirements Clarification:
   - Check if `.cursor/rules/workflow/task-workflow.mdc` exists
   - If it exists, keep the Section 6.0 structure with references to:
     - `task-workflow.mdc` Section 0
     - `standards/process/checklists/requirements_clarification_checklist_v1_0.md` (if exists)
     - Workflow variants (Standard, Emergency, Documentation, Database, Security)
   - If `task-workflow.mdc` doesn't exist, mark Section 6.0 with TODO or remove it

2. **Section 6.1-6.5 (Lifecycle Steps):** Inspect `.cursor/commands/` for the presence of:
   - `pre-flight-check` (kebab-case, not `pre_flight_check`)
   - `create-start-scripts` (for launch scripts)
   - `pr-review-check` (kebab-case, not `pr_review_check`)
   - `audit-project` or `project-audit` (check actual filename)
   - `audit-security` or `security_audit` (check actual filename)
   - `full-project-health-check` (meta-command)
   - `launch` (for launching dev server)

3. **For each command referenced in the template:**
   - If the command exists in this project, keep it as‑is.
   - If it does **not** exist:
     - Either:
       - a) Keep the entry but mark with `TODO: define this command in this project`, or
       - b) Remove/shorten the reference if this project follows a simpler lifecycle.
   - Do **not** claim commands exist when they don’t.

4. **For checklists:**
   - Check for files under `standards/process/checklists/` (not `docs/process/checklists/`):
     - `pre_flight_checklist_v1_0.md`
     - `pr_review_checklist_v1_0.md`
     - `project_audit_checklist_v1_0.md`
     - `requirements_clarification_checklist_v1_0.md` (if exists)
   - Check for `standards/security/security-audit-checklist.md`
   - If missing, leave the references but annotate them with TODO in a gentle way, e.g.:
     - `<!-- TODO: Add project-specific checklist or update path -->`

5. **Workflow Variants:** The template references workflow variants. Check if `.cursor/rules/workflow/workflow-variants.mdc` exists:
   - If it exists, keep the workflow variants table in Section 6.0
   - If it doesn't exist, remove or mark with TODO

### C.7 Agent Rules of Engagement (Section 7)

1. **Section 7 Structure:** The template includes a "What the AI Agent Reviews First" section. Ensure it references:
   - `AGENTS.md` (this file) as first priority
   - `.cursor/rules/task-workflow.mdc` as second priority (if exists)
   - Auto-applied rules
   - Context-specific rules

2. **Keep the rules conceptually intact;** they are generally applicable to your agent ecosystem.

3. **Check for key rules:**
   - `.cursor/rules/workflow/task-workflow.mdc` - Should be prominently referenced
   - `.cursor/rules/workflow/pre-flight-check.mdc` - Auto-applied pre-flight validation
   - `.cursor/rules/workflow/pr-review-check.mdc` - Auto-applied PR validation
   - `.cursor/rules/core/date-time.mdc` - Temporal awareness
   - `.cursor/rules/core/dry-principle.mdc` - DRY principle enforcement
   - `.cursor/rules/documentation/documentation-metadata.mdc` - Documentation standards
   - `.cursor/rules/supabase-rls-policy-review.mdc` - If Supabase is used

4. **Git Workflow Rules:** The template includes a "Git Workflow Rules" subsection. Check for:
   - `.cursor/rules/git/git-branch-naming.mdc`
   - `.cursor/rules/git/git-commit-messages.mdc`
   - `.cursor/rules/git/git-pr-preparation.mdc`
   - `.cursor/rules/git/git-repository-hygiene.mdc`
   - `.cursor/rules/git/git-hooks-standards.mdc`
   - `.cursor/rules/git/git-workflow-integration.mdc`
   - If these exist, keep the Git Workflow Rules subsection; if not, remove or mark with TODO

5. **Module-Specific Rules:** The template includes a "Module-Specific Rules" subsection. Check for:
   - `.cursor/rules/modules/module-discovery-selection.mdc`
   - `.cursor/rules/modules/module-integration-patterns.mdc`
   - `.cursor/rules/modules/module-documentation-requirements.mdc`
   - Other module rules in `.cursor/rules/modules/`
   - If these exist, keep the Module-Specific Rules subsection; if not, remove or mark with TODO

6. **If some referenced rules do not exist in this project:**
   - Add an inline note, like:
     - `> NOTE: This project does not currently implement [feature]; this rule applies only if/when [feature] is added.`
   - Or remove the reference if it's clearly not applicable

7. **Ensure the Temporal Awareness sub‑rule** references `.cursor/rules/core/date-time.mdc` for date format standards.

### C.8 Related Checklists & Commands (Section 8) and Quick Reference (Section 9)

1. For each checklist and command listed:
   - Verify existence in this project.
   - If paths or names differ slightly, adjust them to match reality.
   - If entirely missing but desired, leave them and mark TODO.
2. The Quick Reference table (Section 9) should be consistent with the commands/checklists above; update entries to reflect the actual commands and files in this repo.

### C.9 Dates / Metadata

1. **Metadata Section (Top of File):** The template includes a metadata section at the top. Ensure:
   - **Created:** Set to current date (format per `.cursor/rules/date-time.mdc` - typically `YYYY-MM-DD` or `DD-MM-YYYY`)
   - **Last Updated:** Set to current date/time (format: `DD-MM-YYYY HH:MM:SS EST` per `.cursor/rules/date-time.mdc`)
   - **Version:** Start at `1.0` or `1.0.0`

2. **Last Updated (Bottom of File):** Near the bottom, the template includes:
   - `_Last Updated: [Update this date when you customize the template]_`
   - Replace it using current date/time:
     - Format: `DD-MM-YYYY HH:MM:SS EST` per `.cursor/rules/date-time.mdc`
     - Use `date` command or system date functions
   - If date cannot be determined:
     - Do **not** guess.
     - Either leave the placeholder or insert `TODO: Set Last Updated date`.

3. **Maintenance Note:** The template includes a maintenance note referencing `.cursor/rules/workflow-standards-documentation-maintenance.mdc`. Check if this rule exists:
   - If it exists (project-specific rule), keep the reference
   - If it doesn't exist, remove the reference or update to point to `.cursor/rules/documentation/documentation-metadata.mdc`

---

## D. Write AGENTS.md

1. After adapting the template content, write it to a new file in the project root named:
   - `AGENTS.md`
2. Ensure:
   - **Metadata section** is at the top with all required fields (Created, Last Updated, Version, Description)
   - Markdown structure is preserved.
   - All sections (1–9) are present and readable:
     - Section 1: Project Mission
     - Section 2: Current Phase
     - Section 3: Active Context
     - Section 4: System Architecture Highlights
     - Section 5: Persistent Memory
     - Section 6: Standard Developer Lifecycle (with 6.0 Requirements Clarification if applicable)
     - Section 7: Agent Rules of Engagement
     - Section 8: Related Checklists & Commands
     - Section 9: Quick Reference
   - The file ends with a newline.
   - All file references use correct paths (kebab-case for commands, proper relative paths)

3. Do **not** add any secrets (API keys, tokens, private URLs) to AGENTS.md.
   - It may mention env var names, commands, standards, and file paths only.
   - See `.cursor/rules/security/secrets-management.mdc` for security guidelines.

---

## E. Cross-linking & Final Clean-up

1. If `PROJECT_AUDIT.md` exists:
   - Optionally add a short note inside `AGENTS.md` (e.g., in Section 4 or 6) like:
     - `> See PROJECT_AUDIT.md for current ports, Supabase mode, and configuration details.`

2. If README.md has a “Developer” or “Contributing” section:
   - Optionally add a one-line pointer:
     - `For AI Developer Agent context and lifecycle, see AGENTS.md.`

3. In your final chat response, summarize:
   - Whether AGENTS.md was created or skipped due to existing file.
   - Which sections were partially auto-filled (e.g., Tech Stack, commands, metadata) vs left as TODO.
   - Which rules/commands were found vs marked as TODO (e.g., task-workflow.mdc, git rules, module rules).
   - Any obvious follow-up actions for the human (e.g., fill in mission statement, phase, Notion project name, create missing commands/checklists).

4. Do not dump the entire contents of AGENTS.md into the chat unless explicitly requested; keep the summary concise.

5. **Validation Checklist:**
   - [ ] Metadata section present at top with Created, Last Updated, Version
   - [ ] All command names use kebab-case (e.g., `pre-flight-check`, not `pre_flight_check`)
   - [ ] Section 6.0 (Requirements Clarification) included if task-workflow.mdc exists
   - [ ] Workflow variants referenced if workflow-variants.mdc exists
   - [ ] Git workflow rules section included if git rules exist
   - [ ] Module-specific rules section included if module rules exist
   - [ ] All file paths are correct and use proper relative paths
   - [ ] Checklist paths point to `standards/process/checklists/` (not `docs/process/checklists/`)
   - [ ] Last Updated date at bottom uses correct format per date-time.mdc
