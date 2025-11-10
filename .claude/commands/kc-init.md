---
description: Initialize KnowzCode framework in the current project
---

# KnowzCode Project Initialization

You are the **KnowzCode Initialization Agent**. Your task is to set up the KnowzCode v2.0 framework in the current working directory.

## What KnowzCode Provides

KnowzCode is an AI-powered software development workflow framework that provides:
- **Structured TDD workflow** with quality gates
- **Multi-agent orchestration** for complex tasks
- **Comprehensive tracking** of WorkGroups and specifications
- **Architecture-driven development** with living documentation

## Your Task

Initialize the `knowzcode/` directory structure in the current project with all necessary template files.

### Steps to Execute

1. **Check if already initialized**
   - Look for existing `knowzcode/` directory
   - If exists and has content, warn user and ask if they want to:
     - Abort (preserve existing)
     - Merge (add missing files only)
     - Overwrite (reset to templates)

2. **Create directory structure**
   ```
   knowzcode/
   ├── knowzcode_project.md       # Project metadata
   ├── knowzcode_tracker.md       # WorkGroup tracker
   ├── knowzcode_log.md           # Session log
   ├── knowzcode_architecture.md  # Architecture documentation
   ├── knowzcode_loop.md          # Loop phase reference
   ├── automation_manifest.md     # Automation tracking
   ├── environment_context.md     # Environment information
   ├── specs/                     # Specifications directory
   ├── workgroups/                # WorkGroup data directory
   └── prompts/                   # Project-specific prompts
   ```

3. **Copy template files**
   - Templates are embedded in the KnowzCode plugin
   - You have access to all template content
   - Copy each template file to the project's `knowzcode/` directory

4. **Generate environment context**
   - Detect project language, framework, and tools
   - Populate `environment_context.md` with discovered information
   - Include package managers, test runners, build tools

5. **Initialize git ignore (if needed)**
   - Check if `.gitignore` exists
   - Add `knowzcode/workgroups/` to gitignore (contains session-specific data)
   - Keep `knowzcode/*.md` and `knowzcode/specs/` tracked

6. **Report success**
   - List all created files
   - Show next steps for the user
   - Explain how to start using KnowzCode

### Template Files to Copy

Use these embedded templates:

#### knowzcode_project.md
```markdown
# ◆ KnowzCode Project Overview

---

**Purpose:** This document provides comprehensive project context for KnowzCode AI agents.

---

### 1. Project Goal & Core Problem

*   **Goal:** [To be filled in during first /kc session]
*   **Core Problem Solved:** [To be filled in during first /kc session]

---

### 2. Scope & Key Features (MVP Focus)

*   **MVP Description:** [To be defined]
*   **Key Features (In Scope):**
    *   [Feature 1]: [Description]
*   **Out of Scope:**
    *   [Deferred 1]: [Description]

---

### 3. Technology Stack

| Category | Technology | Version | Notes |
|:---------|:-----------|:--------|:------|
| Language(s) | [Detected] | [Detected] | [Auto-detected] |
| Testing | [Detected] | [Detected] | [Auto-detected] |

*Note: This will be populated during first KnowzCode session.*

---

### Links to Other Artifacts
* **Loop Protocol:** `knowzcode/knowzcode_loop.md`
* **Session Log:** `knowzcode/knowzcode_log.md`
* **Architecture:** `knowzcode/knowzcode_architecture.md`
* **Tracker:** `knowzcode/knowzcode_tracker.md`
* **Specifications:** `knowzcode/specs/`
```

#### knowzcode_tracker.md
```markdown
# ◆ KnowzCode Status Map (WorkGroup Tracker)

---

**Purpose:** Tracks all active and completed WorkGroups for this project.

---

## Active WorkGroups

*None yet. Run `/kc "your feature description"` to create your first WorkGroup.*

---

## Completed WorkGroups

*None yet.*

---

**Next WorkGroup ID:** WG-001
```

#### knowzcode_log.md
```markdown
# ◆ KnowzCode Operational Record

---

**Purpose:** Session log and quality criteria reference.

---

## Recent Sessions

*No sessions yet. This will be populated when you run your first `/kc` command.*

---

## Reference Quality Criteria

1. **Reliability:** Robust error handling, graceful degradation
2. **Maintainability:** Clear code structure, good naming, modularity
3. **Security:** Input validation, secure authentication, data protection
4. **Performance:** Efficient algorithms, optimized queries
5. **Testability:** Comprehensive test coverage, clear test cases

---
```

#### knowzcode_architecture.md
```markdown
# ◆ KnowzCode Architecture Documentation

---

**Purpose:** Living architecture documentation for this project.

---

## System Architecture

*To be populated during first feature development.*

## Key Components

*To be populated during implementation.*

## Data Flow

*To be populated during implementation.*

---
```

#### automation_manifest.md
```markdown
# ◆ KnowzCode Automation Manifest

---

**Purpose:** Tracks automation opportunities and implementations.

---

## Identified Automation Opportunities

*None yet.*

---
```

#### environment_context.md Template
```markdown
# ◆ KnowzCode Environment Context

---

**Purpose:** Environment and tooling information for KnowzCode agents.

---

## Detected Environment

**Platform:** [Auto-detected]
**Language:** [Auto-detected]
**Package Manager:** [Auto-detected]
**Test Runner:** [Auto-detected]

---
```

### Next Steps Message

After successful initialization, display:

```
✅ KnowzCode initialized successfully!

Created:
  • knowzcode/knowzcode_project.md
  • knowzcode/knowzcode_tracker.md
  • knowzcode/knowzcode_log.md
  • knowzcode/knowzcode_architecture.md
  • knowzcode/knowzcode_loop.md
  • knowzcode/automation_manifest.md
  • knowzcode/environment_context.md
  • knowzcode/specs/
  • knowzcode/workgroups/
  • knowzcode/prompts/

Next steps:
  1. Review knowzcode/knowzcode_project.md and add project details
  2. Start your first feature: /kc "your feature description"
  3. View available commands: /help

The knowzcode/ directory contains all project-specific KnowzCode data
and is safe to commit to version control (except workgroups/).
```

## Important Notes

- **Visible directory:** `knowzcode/` is a regular directory (not hidden)
- **Git-friendly:** Most files should be committed to track project evolution
- **Session data:** `knowzcode/workgroups/` contains session-specific data (can be gitignored)
- **Plugin separation:** Commands and agents live in the plugin, data lives here

## Error Handling

If initialization fails:
1. Report which step failed
2. Show partial progress (what was created)
3. Suggest remediation steps
4. Offer to clean up partial initialization

Execute this initialization now.
