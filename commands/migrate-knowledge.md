---
description: "Migrate external knowledge (text, files, folders) into KnowzCode's spec system"
argument-hint: "<source> [--format <type>] [--dry-run] [--merge] [--overwrite]"
---

# Migrate Knowledge

Migrate external knowledge (text, files, folders) into KnowzCode's spec system. Consolidates legacy KnowzCode, Noderr, or generic markdown analysis into current v2.0 spec patterns.

**Usage**: `/kc:migrate-knowledge <source> [options]`

**Examples**:
```
/kc:migrate-knowledge ./legacy-docs/analysis.md
/kc:migrate-knowledge ./noderr-output/
/kc:migrate-knowledge "./docs/**/*.md"
/kc:migrate-knowledge "Component: AuthService handles JWT..." --format generic
/kc:migrate-knowledge ./doc1.md ./doc2.md --merge
/kc:migrate-knowledge ./old-specs/ --dry-run
```

**Primary Input**: $ARGUMENTS

---

## Scope Guard

**Prerequisite Check** (REQUIRED - DO FIRST):

1. Check if `knowzcode/` directory exists
2. Check if required files exist:
   - `knowzcode/knowzcode_project.md`
   - `knowzcode/specs/` directory

**If any files are missing:**
```
⚠️ KnowzCode not initialized or missing required files.
Missing: [list missing files]

Please run `/kc:init` first to set up KnowzCode in this project.
```
STOP - do not proceed with migration.

**If all files exist:** Continue to argument parsing.

---

## Error Handling: No Arguments

**If $ARGUMENTS is empty or not provided:**

Display usage message and STOP:

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode MIGRATE-KNOWLEDGE
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ No source specified.

**Usage**: `/kc:migrate-knowledge <source> [options]`

**Input Types**:
- File path: `./legacy-docs/analysis.md`
- Folder path: `./noderr-output/`
- Glob pattern: `"./docs/**/*.md"`
- Direct text: `"Component: AuthService handles JWT..."`
- Multiple sources: `./doc1.md ./doc2.md`

**Options**:
- `--format <type>`: Force format detection (auto|kc-v1|noderr|generic)
- `--dry-run`: Preview extraction without writing files
- `--merge`: Auto-merge with existing specs (default for conflicts)
- `--overwrite`: Replace existing specs on conflict

**Examples**:
```
/kc:migrate-knowledge ./legacy-docs/analysis.md
/kc:migrate-knowledge ./noderr-output/ --dry-run
/kc:migrate-knowledge "./docs/**/*.md" --format generic
```
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Argument Parsing

Parse $ARGUMENTS to extract:

### Sources
- **File paths**: Paths ending in `.md`, `.txt`, `.json`, `.yaml`
- **Folder paths**: Paths without file extension OR ending in `/`
- **Glob patterns**: Paths containing `*` or `**`
- **Direct text**: Quoted strings without path indicators
- **Multiple sources**: Space-separated list of the above

### Options
| Flag | Default | Description |
|------|---------|-------------|
| `--format <type>` | `auto` | Force format: `auto`, `kc-v1`, `noderr`, `generic` |
| `--dry-run` | `false` | Preview only, no file writes |
| `--merge` | `true` | Merge with existing specs on conflict |
| `--overwrite` | `false` | Replace existing specs on conflict |

**Note**: `--merge` and `--overwrite` are mutually exclusive. If both specified, `--overwrite` takes precedence.

---

## Execution

**REQUIRED**: Delegate to the knowledge-migrator sub-agent using the Task tool.

```
subagent_type: "knowledge-migrator"
prompt: |
  Migrate external knowledge into KnowzCode specs.

  Context:
  - Sources: [parsed sources from $ARGUMENTS]
  - Format: [--format value or "auto"]
  - Dry Run: [true/false]
  - Conflict Strategy: [merge/overwrite/prompt]

  Instructions:
  1. Detect format of each source (KCv1, Noderr, generic)
  2. Extract entities and map to NodeID prefixes
  3. Check for existing specs in knowzcode/specs/
  4. Apply conflict resolution strategy
  5. Generate specs following v2.0 template
  6. Create migration report
  7. Log migration in knowzcode/knowzcode_log.md

  Return: Migration summary with:
  - Specs created/updated count
  - NodeIDs extracted
  - Conflicts resolved
  - Path to migration report
```

---

## Output Expectations

The knowledge-migrator agent will:

1. **Detect Source Format**
   - KCv1: `## Node Specification:`, `**NodeID:**`, `## ARC Criteria`
   - Noderr: `## Component:`, `## Service:`, JSON/YAML blocks
   - Generic: Freeform markdown, NLP-based extraction

2. **Extract Entities → NodeIDs**
   - Map to prefixes: `UI_`, `API_`, `SVC_`, `DB_`, `LIB_`, `CONFIG_`, `UC_`
   - Infer type from context and keywords

3. **Handle Conflicts**
   - No existing spec: Create new
   - Existing identical: Skip with note
   - Existing less complete: Merge sections
   - Divergent: Apply strategy (merge/overwrite/prompt)

4. **Write Outputs**
   - Specs: `knowzcode/specs/{NodeID}.md`
   - Report: `knowzcode/planning/migration-{timestamp}.md`
   - Log: Entry in `knowzcode/knowzcode_log.md`

---

## Success Output

After migration completes:

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode MIGRATION COMPLETE
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Sources Processed**: {count}
**Format Detected**: {KCv1|Noderr|Generic|Mixed}

**Specs Created**: {count}
**Specs Updated**: {count}
**Specs Skipped**: {count} (already up-to-date)

**NodeIDs Extracted**:
| NodeID | Source | Action |
|--------|--------|--------|
| {NodeID_1} | {source_file} | Created |
| {NodeID_2} | {source_file} | Merged |
...

**Migration Report**: knowzcode/planning/migration-{timestamp}.md

Ready for next goal.
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Context Files

- knowzcode/knowzcode_project.md
- knowzcode/prompts/KCv2.0__Migrate_Knowledge.md
