---
description: Command to update data_model_map.json (and optional data_model_map.md) after any data-layer changes
version: 1.0.0
created: 12-04-2025
lastUpdated: 12-04-2025 18:20:44 EST
---

# Command: update-data-model-map

## Purpose

Ensure `data_model_map.json` remains the canonical source of truth whenever data-layer files change.

## When to Run

- After modifying any files in `/db`, `/schema`, `/models`, `/types`, `/api`, `/components`, `/services`, or migrations.
- After adding or changing domain objects, fields, or API contracts.
- After adding/updating components or services that consume domain data.

## Steps

1. **Run Impact Analysis first**
   - Use the Impact Analysis rule/command to summarize affected objects and usages.

2. **Scan changes**
   - Identify domain objects and fields added/modified/removed.
   - Note new/changed definitions (schema, models, types) and usages (API, components, services).

3. **Update `data_model_map.json`**
   - Add/modify objects, fields, `defined_in`, `used_in`, and `notes`.
   - Bump `version` (semver).
   - Update `last_updated` (EST).
   - Keep JSON valid (run `jq . data_model_map.json`).

4. **Regenerate `data_model_map.md` (optional)**
   - If maintaining the Markdown view, regenerate from JSON.

5. **Record impact notes**
   - Add critical notes (filters, notifications, analytics, cross-object deps).

6. **Run targeted checks**
   - Type check (`tsc --noEmit`, `pyright`/`mypy`, etc.).
   - Run tests tagged for affected objects (e.g., `@lead`, `@orders`).
   - Treat failures as blockers.

7. **Stage and commit**
   - Stage `data_model_map.json` (and `data_model_map.md` if used).
   - Include other changed files and changelog entries as needed.

## CI Expectation

- CI should **fail** if data-layer files change and `data_model_map.json` is not updated.
- CI should validate JSON syntax, presence of `version` and `last_updated`, and semver bump.

## Notes

- `data_model_map.json` lives at project root (same level as `CHANGELOG.md`).
- Follow `standards/database/data-model-map-standard.md` for structure.
- Follow `data-model-integrity.mdc` for enforcement and structured docs.
