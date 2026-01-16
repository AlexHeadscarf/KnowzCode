# KnowzCode v2.0: Migrate Knowledge

**Sources:** [List of source paths, patterns, or text]
**Format Override:** [auto|kc-v1|noderr|generic]
**Mode:** [normal|dry-run]
**Conflict Strategy:** [merge|overwrite|prompt]

> **Automation Path:** Use `/kc:migrate-knowledge <source>` to invoke the `knowledge-migrator` agent for streamlined migration.

---

## Your Mission

You have been instructed to migrate external knowledge into KnowzCode v2.0 spec format. This protocol handles legacy KnowzCode (v1.x), Noderr output, and generic markdown analysis.

**CRITICAL RULE: Preserve valuable information.** Never discard content that might be useful. When in doubt, include it with appropriate markers for later review.

**Reference:** Your actions are governed by the spec template in `knowzcode/knowzcode_loop.md`.

---

## Extraction Rules by Format

### KnowzCode v1.x

**Detection Markers:**
```
## Node Specification:
**NodeID:** {value}
## ARC Criteria
**Type:** Component|UseCase
```

**Field Mapping:**

| v1.x Field | v2.0 Section |
|------------|--------------|
| `**NodeID:**` | Filename (knowzcode/specs/{NodeID}.md) |
| `## Purpose` / `## Overview` | 1. Purpose |
| `## Dependencies` | 2. Dependencies (convert to table) |
| `## Interfaces` / `## API` | 3. Interfaces |
| `## Implementation` / `## Logic` | 4. Core Logic |
| `## Data` / `## Models` | 5. Data Structures |
| `## ARC Criteria` / `## Verification` | 6. ARC Verification Criteria |
| `## Tech Debt` / `## Issues` | 7. Tech Debt & Future Improvements |

**Transformation Rules:**
1. Convert bullet lists to markdown tables where appropriate
2. Preserve code blocks exactly as-is
3. Update date fields to current timestamp
4. Add `[MIGRATED]` marker to Tech Debt section

---

### Noderr Format

**Detection Markers:**
```
## Component: {name}
## Service: {name}
### Dependencies
{
  "type": "component|service",
  "name": "...",
  "dependencies": [...]
}
```

**Field Mapping:**

| Noderr Field | v2.0 Section |
|--------------|--------------|
| `name` / `## Component:` | NodeID (with prefix inference) |
| First paragraph / `description` | 1. Purpose |
| `dependencies` / `### Dependencies` | 2. Dependencies |
| `inputs` / `## Inputs` | 3. Interfaces → Inputs |
| `outputs` / `## Outputs` | 3. Interfaces → Outputs |
| `logic` / `## Process` | 4. Core Logic |
| `schema` / `## Data` | 5. Data Structures |
| — | 6. ARC Verification Criteria (generate placeholders) |
| `issues` / `## Known Issues` | 7. Tech Debt |

**NodeID Prefix Inference from Noderr:**

| Noderr Type | Inferred Prefix |
|-------------|-----------------|
| `component` with `ui` in name/path | `UI_` |
| `component` otherwise | `SVC_` |
| `service` | `SVC_` |
| `api` / `endpoint` | `API_` |
| `model` / `data` | `DB_` |
| `utility` / `helper` | `LIB_` |
| `config` | `CONFIG_` |
| `flow` / `workflow` | `UC_` |

---

### Generic Markdown

**Detection:** Fallback when no specific format markers found.

**Entity Extraction Heuristics:**

1. **Component Names** (scan for):
   - Capitalized multi-word phrases in headers: `## User Authentication`
   - Capitalized references in body: "The `AuthService` handles..."
   - Function/class references: `class UserManager`, `function handleLogin`

2. **Relationships** (scan for patterns):
   - "X depends on Y" → Dependency
   - "X calls Y" → Dependency
   - "X uses Y" → Dependency
   - "X is responsible for Y" → Purpose description
   - "X handles Y" → Purpose description
   - "X returns Y" → Output interface

3. **Type Inference** (from keywords):

   | Keywords in Context | Inferred Type |
   |---------------------|---------------|
   | button, form, component, page, modal, dialog | `UI_` |
   | endpoint, route, REST, GraphQL, API | `API_` |
   | service, handler, processor, worker, manager | `SVC_` |
   | model, schema, table, entity, record | `DB_` |
   | util, helper, lib, format, parse, validate | `LIB_` |
   | config, settings, env, options | `CONFIG_` |
   | flow, journey, process, workflow, use case | `UC_` |

4. **ARC Criteria Generation** (when not present):
   - Generate 3-5 testable criteria based on extracted purpose
   - Format: "[ ] {Action verb} {expected behavior}"
   - Examples:
     - "[ ] Returns valid JWT token on successful authentication"
     - "[ ] Displays error message when validation fails"
     - "[ ] Persists data to database within 100ms"

---

## Consolidation Decision Tree

```
FOR EACH extracted NodeID:
│
├─► Does knowzcode/specs/{NodeID}.md exist?
│   │
│   ├─► NO: Create new spec
│   │
│   └─► YES: Compare content
│       │
│       ├─► Identical? → Skip (log: "already up-to-date")
│       │
│       ├─► Existing is SUBSET of new? → Merge (add new sections)
│       │
│       ├─► New is SUBSET of existing? → Skip (log: "existing is more complete")
│       │
│       └─► Divergent content?
│           │
│           ├─► Strategy = merge → Merge with [MIGRATED] markers
│           │
│           ├─► Strategy = overwrite → Replace entirely
│           │
│           └─► Strategy = prompt → Ask user
│               │
│               ├─► User: "merge" → Merge with markers
│               ├─► User: "overwrite" → Replace
│               ├─► User: "skip" → Skip this NodeID
│               └─► User: "abort" → Stop migration
```

---

## Spec Completeness Assessment

Before merging, assess completeness of both sources:

| Section | Weight | Complete If |
|---------|--------|-------------|
| 1. Purpose | 20 | >50 characters, describes what it does |
| 2. Dependencies | 15 | Table with at least 1 entry OR explicit "none" |
| 3. Interfaces | 15 | Both Inputs and Outputs defined |
| 4. Core Logic | 15 | >100 characters OR code block present |
| 5. Data Structures | 10 | Any content present |
| 6. ARC Criteria | 15 | At least 3 testable criteria |
| 7. Tech Debt | 10 | Any content present |

**Score Calculation:**
- Sum weights of complete sections
- Score 0-100

**Comparison:**
- `new_score > existing_score + 10` → New is significantly better
- `existing_score > new_score + 10` → Existing is significantly better
- Otherwise → Comparable, merge recommended

---

## Template Application Instructions

When generating a spec, follow this exact structure:

```markdown
# {NodeID}

**Type**: {Component|UseCase}
**Status**: Migrated
**Migrated From**: {source_path}
**Migration Date**: {YYYY-MM-DD HH:MM}

## 1. Purpose

{If extracted: use extracted content}
{If not extracted: "Purpose to be documented. Review and update."}

## 2. Dependencies

{If dependencies extracted:}
| Dependency | Type | Purpose |
|------------|------|---------|
| {dep1} | {Internal|External} | {purpose} |

{If no dependencies: }
No dependencies identified. Verify and update if needed.

## 3. Interfaces

### Inputs
{Extracted inputs OR "Inputs to be documented."}

### Outputs
{Extracted outputs OR "Outputs to be documented."}

## 4. Core Logic

{Extracted logic description OR "Core logic to be documented."}

{Preserve any code blocks from source}

## 5. Data Structures

{Extracted data structures OR "Data structures to be documented if applicable."}

## 6. ARC Verification Criteria

{Extracted criteria OR generated placeholders:}
- [ ] Component initializes without errors
- [ ] Primary function executes successfully
- [ ] Error handling covers edge cases

## 7. Tech Debt & Future Improvements

- [MIGRATED] Migrated from {format} format on {date}
- [NEEDS_REVIEW] Verify all sections are accurate

{Any additional extracted tech debt items}
```

---

## Output Artifacts

### 1. Specs (unless dry-run)
Location: `knowzcode/specs/{NodeID}.md`

### 2. Migration Report
Location: `knowzcode/planning/migration-{YYYYMMDD-HHMMSS}.md`

Content:
- Summary statistics
- Full NodeID extraction table
- Conflict resolution log
- Warnings and issues
- Next steps checklist

### 3. Log Entry (unless dry-run)
Location: `knowzcode/knowzcode_log.md` (prepend)

Format:
```markdown
---
**Type:** Migration
**Timestamp:** {timestamp}
**NodeID(s):** {comma-separated}
**Logged By:** knowledge-migrator
**Details:**
- **Sources:** {count} processed
- **Format:** {format(s)}
- **Created:** {n} specs
- **Updated:** {n} specs
- **Report:** {report_path}
---
```

---

## Final Report Format

After completing migration:

```markdown
✓ Migration completed.

**Summary:**
- Sources: {n} files processed
- Format: {detected format(s)}
- Created: {n} new specs
- Updated: {n} existing specs
- Skipped: {n} (already complete or identical)

**Report:** knowzcode/planning/migration-{timestamp}.md

**Next Steps:**
1. Review migrated specs for accuracy
2. Run `/kc:audit spec` to validate completeness
3. Update any `[NEEDS_REVIEW]` markers

Awaiting next goal.
```
