# TechStackAudit Command (Version 1.1)

## Command Name

**TechStackAudit**

## Purpose

This command instructs the Agent to analyze and document the technology stack of the current project. The Agent must examine frameworks, languages, dependencies, APIs, services, build systems, runtimes, infrastructure, and external integrations to produce a complete and accurate overview of the project's technical foundation.

The goal is to create a unified, accurate view of how the project is built, what it uses, and where technical risks or outdated dependencies may exist.

---

## Behavior Requirements

### A. Full Technology Scan

The Agent must:
A1. Identify all programming languages in use.
A2. Identify all frameworks, libraries, and SDKs.
A3. Parse dependency files (e.g., package.json, pyproject.toml, Gemfile, go.mod, requirements.txt, etc.).
A4. Identify runtime environments (Node, Python, Deno, Ruby, etc.).
A5. Identify build tools (Webpack, Vite, esbuild, etc.).
A6. Identify database engines and ORM layers.
A7. Identify external services (Supabase, TradeStation API, OpenAI API, Slack API, Stripe, Postmark, etc.).
A8. Identify infrastructure components (Docker, Supabase edge functions, cron runners, CI/CD pipelines, GitHub Actions, etc.).
A9. Identify configuration files and environment variables.
A10. Identify toolchains (Cursor Agents, Make.com automations, linters, formatters, analyzers, etc.).

---

## B. Audit Output Structure

The Agent must produce a structured audit in the following format:

### B1. Language & Framework Summary

- List of programming languages
- Frameworks used per service

### B2. Dependency Analysis

- Key dependencies
- Versions
- Deprecated/insecure/outdated packages
- Suggested upgrade paths

### B3. Infrastructure Overview

- Build systems
- Deployment model
- CI/CD
- Containers or serverless components

### B4. External Integrations

- APIs
- Webhooks
- Third-party SDKs
- Authentication providers

### B5. Environment & Configuration

- Detected environment variables
- Missing environment variables
- Secrets required

### B6. Risk & Issues Assessment

- Outdated libraries
- Known vulnerabilities
- Unsupported frameworks
- Areas needing modernization

### B7. Notion-Ready Tasks

Examples:

- "Upgrade Node 14 to Node 20."
- "Replace deprecated Supabase function with latest format."
- "Document missing environment variables in README."

---

## C. Guardrails

C1. The Agent must not create or modify code.
C2. The Agent must not attempt to auto-upgrade dependencies.
C3. The Agent must not create new documentation; only analyze.
C4. The Agent must highlight assumptions.
C5. The output must reflect the repository **as-is**.

---

## D. When to Use This Command

Use **TechStackAudit** when:

- Starting a new project
- Inheriting or reviewing unfamiliar code
- Preparing for refactoring
- Evaluating upgrade or migration needs
- Creating architecture or onboarding docs
- Preparing a project for multi-agent development

---

## E. Versioning

- Last Updated: 2025-12-01
- This doc is **Version 1.1**
- All updates must increment the version number.
- The Agent must include a diff summary when updating this file.
