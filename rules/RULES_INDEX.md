# Rules Catalog (RULES_INDEX.md)

> **Last Updated:** 12-09-2025 10:44:43 EST  
> **Version:** 2.1.0  
> **Total Rules:** 60+

This catalog provides a comprehensive index of all rules organized by category. Each rule includes its purpose, when it applies, and approximate file size guidance.

---

## Quick Navigation

- [Core Rules](#core-rules) - Universal standards (always apply)
- [Workflow Rules](#workflow-rules) - Development lifecycle
- [Git Rules](#git-rules) - Version control
- [Security Rules](#security-rules) - Security & access control
- [Testing Rules](#testing-rules) - Testing standards
- [Performance Rules](#performance-rules) - Optimization
- [Architecture Rules](#architecture-rules) - Design patterns & data integrity
- [Error Handling Rules](#error-handling-rules) - Error management
- [Database Rules](#database-rules) - Schema & data
- [API Rules](#api-rules) - API design
- [Documentation Rules](#documentation-rules) - Docs & metadata
- [Module Rules](#module-rules) - Module management
- [Tech Stack Rules](#tech-stack-rules) - Language/framework specific
- [Project-Specific Rules](#project-specific-rules) - Repository-specific

---

## Core Rules

Universal rules that apply to all AI agent interactions.

| Rule                    | File                               | Description                                      | Auto-Apply  |
| ----------------------- | ---------------------------------- | ------------------------------------------------ | ----------- |
| AI Interaction          | `core/ai-interaction-rules.mdc`    | Core behavioral standards for AI agents          | ✅          |
| Cursor Command Creation | `core/cursor-command-creation.mdc` | Standards for creating Cursor commands           | Conditional |
| Cursor Rule Creation    | `core/cursor-rule-creation.mdc`    | Standards for creating Cursor rules              | Conditional |
| Date & Time             | `core/date-time.mdc`               | Temporal awareness for time-sensitive operations | ✅          |
| DRY Principle           | `core/dry-principle.mdc`           | Single source of truth, reference patterns       | ✅          |
| File Naming             | `core/file-naming.mdc`             | Consistent file naming conventions               | ✅          |
| Version Management      | `core/version-management.mdc`      | Semantic versioning standards                    | ✅          |

**Recommended File Size:** 150-300 lines per rule

---

## Workflow Rules

Rules governing the development lifecycle from task start to PR submission.

| Rule                       | File                                          | Description                                  | Auto-Apply  |
| -------------------------- | --------------------------------------------- | -------------------------------------------- | ----------- |
| Task Workflow              | `workflow/task-workflow.mdc`                  | Complete development lifecycle orchestration | ✅          |
| Pre-Flight Check           | `workflow/pre-flight-check.mdc`               | Environment validation before coding         | ✅          |
| PR Review Check            | `workflow/pr-review-check.mdc`                | Pre-PR validation (quality, security, docs)  | ✅          |
| Linting Behavior           | `workflow/linting-behavior.mdc`               | Linting throughout development               | ✅          |
| Runtime Configuration      | `workflow/runtime-configuration.mdc`          | Environment and container standards          | ✅          |
| Audit Report               | `workflow/audit-report.mdc`                   | Audit report generation standards            | Conditional |
| Workflow Variants (Router) | `workflow/workflow-variants.mdc`              | Routes to appropriate workflow variant       | Conditional |
| Variant: Emergency         | `workflow/variants/variant-emergency.mdc`     | Emergency/Hotfix workflow                    | Conditional |
| Variant: Documentation     | `workflow/variants/variant-documentation.mdc` | Documentation-only workflow                  | Conditional |
| Variant: Database          | `workflow/variants/variant-database.mdc`      | Database migration workflow                  | Conditional |
| Variant: Security          | `workflow/variants/variant-security.mdc`      | Security patch workflow                      | Conditional |
| Auto-Heal (Router)         | `workflow/auto-heal.mdc`                      | Routes to appropriate auto-heal rule         | ✅          |
| Auto-Heal Dev              | `workflow/auto-heal/auto-heal-dev.mdc`        | Build/compile error recovery                 | Conditional |
| Auto-Heal Runtime          | `workflow/auto-heal/auto-heal-runtime.mdc`    | Port/container/process recovery              | Conditional |
| Auto-Heal Database         | `workflow/auto-heal/auto-heal-database.mdc`   | Database connectivity recovery               | Conditional |

**Recommended File Size:** 200-400 lines per rule

---

## Git Rules

Version control and workflow standards.

| Rule                 | File                               | Description                              | Auto-Apply  |
| -------------------- | ---------------------------------- | ---------------------------------------- | ----------- |
| Branch Naming        | `git/git-branch-naming.mdc`        | Branch format and protection             | ✅          |
| Commit Messages      | `git/git-commit-messages.mdc`      | Conventional Commits, secrets scanning   | ✅          |
| PR Preparation       | `git/git-pr-preparation.mdc`       | PR validation and description generation | ✅          |
| Repository Hygiene   | `git/git-repository-hygiene.mdc`   | .gitignore, tracked files                | ✅          |
| Hooks Standards      | `git/git-hooks-standards.mdc`      | Husky, commitlint configuration          | Conditional |
| Workflow Integration | `git/git-workflow-integration.mdc` | Git operations coordination              | ✅          |

**Recommended File Size:** 150-300 lines per rule

---

## Security Rules

Rules for secure application development.

| Rule               | File                              | Description                           | Auto-Apply  |
| ------------------ | --------------------------------- | ------------------------------------- | ----------- |
| Authentication     | `security/authentication.mdc`     | Auth flows, sessions, JWT, passwords  | Conditional |
| Authorization      | `security/authorization.mdc`      | RBAC/ABAC, permissions, ownership     | Conditional |
| Secrets Management | `security/secrets-management.mdc` | API keys, credentials, env vars       | ✅          |
| Input Validation   | `security/input-validation.mdc`   | Zod/Pydantic validation, sanitization | Conditional |
| API Security       | `security/api-security.mdc`       | Rate limiting, CORS, security headers | Conditional |

**Recommended File Size:** 150-250 lines per rule

---

## Testing Rules

Standards for writing effective tests.

| Rule                 | File                               | Description                              | Auto-Apply  |
| -------------------- | ---------------------------------- | ---------------------------------------- | ----------- |
| Unit Testing         | `testing/unit-testing.mdc`         | Unit test structure, mocking, assertions | Conditional |
| Integration Testing  | `testing/integration-testing.mdc`  | Database, API, service integration tests | Conditional |
| E2E Testing          | `testing/e2e-testing.mdc`          | Browser automation, user journeys        | Conditional |
| Test Data Management | `testing/test-data-management.mdc` | Factories, fixtures, cleanup             | Conditional |

**Recommended File Size:** 150-250 lines per rule

---

## Performance Rules

Optimization and performance standards.

| Rule               | File                                 | Description                         | Auto-Apply  |
| ------------------ | ------------------------------------ | ----------------------------------- | ----------- |
| Caching Strategies | `performance/caching-strategies.mdc` | Client/server caching, invalidation | Conditional |
| Query Optimization | `performance/query-optimization.mdc` | N+1 prevention, indexes, pagination | Conditional |

**Recommended File Size:** 150-200 lines per rule

---

## Architecture Rules

Design patterns and architectural standards.

| Rule                 | File                                    | Description                           | Auto-Apply  |
| -------------------- | --------------------------------------- | ------------------------------------- | ----------- |
| Design Patterns      | `architecture/design-patterns.mdc`      | Repository, service, factory patterns | Conditional |
| Data Model Integrity | `architecture/data-model-integrity.mdc` | Data layer changes, model validation  | Conditional |
| Impact Analysis      | `architecture/impact-analysis.mdc`      | Change impact assessment              | Conditional |

**Recommended File Size:** 200-300 lines per rule

---

## Error Handling Rules

Error management and logging standards.

| Rule              | File                                   | Description                                | Auto-Apply |
| ----------------- | -------------------------------------- | ------------------------------------------ | ---------- |
| Error Standards   | `error-handling/error-standards.mdc`   | Error types, boundaries, handling          | ✅         |
| Logging Standards | `error-handling/logging-standards.mdc` | Structured logging, levels, sensitive data | ✅         |

**Recommended File Size:** 150-250 lines per rule

---

## Database Rules

Database schema and data management.

| Rule               | File                              | Description                    | Auto-Apply  |
| ------------------ | --------------------------------- | ------------------------------ | ----------- |
| Schema Enforcement | `database/schema-enforcement.mdc` | COMMENT ON, timestamps, naming | Conditional |

**Recommended File Size:** 150-250 lines per rule

---

## API Rules

API design and implementation standards.

| Rule       | File                 | Description                           | Auto-Apply  |
| ---------- | -------------------- | ------------------------------------- | ----------- |
| API Routes | `api/api-routes.mdc` | REST conventions, responses, handlers | Conditional |

**Recommended File Size:** 150-250 lines per rule

---

## Documentation Rules

Documentation standards and metadata management.

| Rule                       | File                                                  | Description                  | Auto-Apply  |
| -------------------------- | ----------------------------------------------------- | ---------------------------- | ----------- |
| Documentation Metadata     | `documentation/documentation-metadata.mdc`            | File metadata standards      | Conditional |
| Documentation Dependencies | `documentation/documentation-dependency-tracking.mdc` | Cross-reference tracking     | ✅          |
| README Standards           | `documentation/readme-standards.mdc`                  | README structure and content | Conditional |
| Docs Folder Maintenance    | `documentation/docs-folder-maintenance.mdc`           | Docs folder organization     | Conditional |

**Recommended File Size:** 150-250 lines per rule

---

## Module Rules

Standards for working with reusable modules.

| Rule                 | File                                            | Description                   | Auto-Apply  |
| -------------------- | ----------------------------------------------- | ----------------------------- | ----------- |
| Module Discovery     | `modules/module-discovery-selection.mdc`        | Finding and selecting modules | Conditional |
| Module Integration   | `modules/module-integration-patterns.mdc`       | Integration approaches        | Conditional |
| Module Documentation | `modules/module-documentation-requirements.mdc` | Module docs requirements      | Conditional |
| Module Creation      | `modules/module-creation-decision.mdc`          | When to create modules        | Conditional |
| Module Dependencies  | `modules/module-dependencies.mdc`               | Dependency management         | Conditional |
| Module Cursor Rules  | `modules/module-cursor-rule-creation.mdc`       | Module-specific rules         | Conditional |
| Module Testing       | `modules/module-testing-requirements.mdc`       | Module testing standards      | Conditional |
| Module Versioning    | `modules/module-update-versioning.mdc`          | Version management            | Conditional |
| Module Migration     | `modules/module-migration-upgrade.mdc`          | Upgrade procedures            | Conditional |
| Module Deprecation   | `modules/module-deprecation-removal.mdc`        | Deprecation handling          | Conditional |

**Recommended File Size:** 100-200 lines per rule

---

## Tech Stack Rules

Language and framework-specific standards.

### TypeScript

| Rule              | File                               | Description                           | Auto-Apply  |
| ----------------- | ---------------------------------- | ------------------------------------- | ----------- |
| TypeScript Config | `typescript/typescript-config.mdc` | tsconfig, strict mode, best practices | Conditional |
| Zod Schemas       | `typescript/zod-schemas.mdc`       | Validation schemas, type inference    | Conditional |

### React

| Rule             | File                         | Description                             | Auto-Apply  |
| ---------------- | ---------------------------- | --------------------------------------- | ----------- |
| React Components | `react/react-components.mdc` | Component structure, props, composition | Conditional |
| React Hooks      | `react/react-hooks.mdc`      | Hooks patterns, custom hooks, rules     | Conditional |

### Next.js

| Rule              | File                          | Description                  | Auto-Apply  |
| ----------------- | ----------------------------- | ---------------------------- | ----------- |
| Next.js Structure | `nextjs/nextjs-structure.mdc` | App Router, layouts, routing | Conditional |

### Supabase

| Rule            | File                           | Description                 | Auto-Apply  |
| --------------- | ------------------------------ | --------------------------- | ----------- |
| Supabase Client | `supabase/supabase-client.mdc` | Client setup, queries, auth | Conditional |
| Supabase RLS    | `supabase/supabase-rls.mdc`    | Row Level Security policies | Conditional |

### Python

| Rule             | File                          | Description                         | Auto-Apply  |
| ---------------- | ----------------------------- | ----------------------------------- | ----------- |
| Python Structure | `python/python-structure.mdc` | Project organization, naming, style | Conditional |

### Tailwind CSS

| Rule            | File                           | Description                         | Auto-Apply  |
| --------------- | ------------------------------ | ----------------------------------- | ----------- |
| Tailwind Config | `tailwind/tailwind-config.mdc` | Configuration, patterns, responsive | Conditional |

**Recommended File Size:** 150-250 lines per rule

---

## Project-Specific Rules

Rules specific to individual repositories.

| Rule                    | File                                                       | Description                      | Auto-Apply |
| ----------------------- | ---------------------------------------------------------- | -------------------------------- | ---------- |
| Workflow Standards Docs | `project-specific/workflow-standards-docs-maintenance.mdc` | This repository's documentation  | ✅         |
| Notion Project Binding  | `project-specific/notion-project-binding.mdc`              | Notion integration for this repo | ✅         |

**Note:** These rules should be adapted when integrating into other projects.

---

## File Size Guidelines

### Recommended Lengths

| Rule Type        | Lines   | Rationale                  |
| ---------------- | ------- | -------------------------- |
| Core/Universal   | 150-300 | Comprehensive but focused  |
| Workflow         | 200-400 | Complex lifecycle coverage |
| Security         | 150-250 | Focused security domain    |
| Testing          | 150-250 | Pattern-focused            |
| Tech Stack       | 150-250 | Quick reference            |
| Module           | 100-200 | Focused scope              |
| Project-Specific | 100-200 | Targeted scope             |

### Signs a Rule is Too Long

- More than 500 lines
- Multiple unrelated topics
- Excessive code examples
- Duplicated content from other rules

### When to Split Rules

- Rule exceeds 400 lines
- Covers multiple distinct topics
- Has sections that could stand alone
- Different apply conditions for sections

---

## Directory Structure

```
.cursor/rules/
├── RULES_INDEX.md          ← This catalog
├── core/                   ← Universal (7 rules)
├── workflow/               ← Lifecycle (15 rules)
│   ├── variants/          ← Workflow variants (4 rules)
│   └── auto-heal/         ← Auto-healing (3 rules)
├── git/                    ← Version control (6 rules)
├── security/               ← Security (5 rules)
├── testing/                ← Testing (4 rules)
├── performance/            ← Performance (2 rules)
├── architecture/           ← Architecture (3 rules)
├── error-handling/         ← Errors (2 rules)
├── database/               ← Database (1 rule)
├── api/                    ← API (1 rule)
├── documentation/          ← Documentation (4 rules)
├── modules/                ← Module mgmt (10 rules)
├── typescript/             ← TypeScript (2 rules)
├── react/                  ← React (2 rules)
├── nextjs/                 ← Next.js (1 rule)
├── supabase/               ← Supabase (2 rules)
├── python/                 ← Python (1 rule)
├── tailwind/               ← Tailwind (1 rule)
└── project-specific/       ← This repo (2 rules)
```

**Total: 60+ rules across 17 categories**

---

## Rule Application Matrix

### Always Apply (All Projects)

```
core/ai-interaction-rules.mdc
core/date-time.mdc
core/dry-principle.mdc
core/file-naming.mdc
core/version-management.mdc

workflow/task-workflow.mdc
workflow/pre-flight-check.mdc
workflow/pr-review-check.mdc
workflow/linting-behavior.mdc
workflow/runtime-configuration.mdc
workflow/auto-heal.mdc

git/git-branch-naming.mdc
git/git-commit-messages.mdc
git/git-pr-preparation.mdc
git/git-repository-hygiene.mdc
git/git-workflow-integration.mdc

security/secrets-management.mdc

error-handling/error-standards.mdc
error-handling/logging-standards.mdc

documentation/documentation-dependency-tracking.mdc
```

### Conditional Apply (Based on Context)

```
security/*          → Auth/security code
testing/*           → Test files
performance/*       → Performance work
architecture/*      → Architecture changes
database/*          → Database/SQL files
api/*               → API routes

typescript/*        → *.ts, *.tsx files
react/*             → React projects
nextjs/*            → Next.js projects
supabase/*          → Supabase projects
python/*            → *.py files
tailwind/*          → Tailwind projects
modules/*           → Module work
```

---

## Integration Guide

### For New Projects

1. Copy entire `.cursor/rules/` directory
2. Keep all `core/`, `workflow/`, `git/` rules
3. Keep relevant tech stack rules
4. Remove/adapt `project-specific/` rules

### For Selective Integration

1. Identify required categories
2. Copy selected rule folders
3. Update cross-references as needed
4. Test rule application

---

## Maintenance

### Version Updates

- Rules use semantic versioning (X.Y.Z)
- Update `lastUpdated` timestamp on changes
- Update this index when adding/removing rules

### Adding New Rules

1. Create rule in appropriate category folder
2. Follow standard metadata format
3. Add entry to this index
4. Update CHANGELOG.md

---

_This index is the authoritative catalog of all rules in the repository._
