---
description: "Start a new KnowzCode development workflow with TDD, quality gates, and multi-agent orchestration"
argument-hint: "[feature_description]"
---

# Work on New Feature

Start a new KnowzCode development workflow session.

**Usage**: `/knowzcode:work "feature description"`
**Example**: `/knowzcode:work "Build user authentication with JWT"`

**Primary Goal**: $ARGUMENTS

---

## ⛔ MANDATORY ENFORCEMENT - READ BEFORE PROCEEDING

**YOU MUST DELEGATE TO THE ORCHESTRATOR. NO EXCEPTIONS.**

The following actions are **BLOCKED** until the kc-orchestrator sub-agent has:
1. Created a WorkGroup file at `knowzcode/workgroups/{WorkGroupID}.md`
2. Completed Phase 1A (Impact Analysis) with user approval
3. Completed Phase 1B (Specification) with user approval

**BLOCKED ACTIONS** (until orchestrator completes phases 1A and 1B):
- ❌ Reading project source code (except `knowzcode/*.md` context files)
- ❌ Using `Edit` tool on any non-knowzcode file
- ❌ Using `Write` tool to create implementation files
- ❌ Running implementation commands via `Bash`
- ❌ Proposing code changes or fixes directly

**WHY**: Even "obvious" fixes have hidden ripple effects. The orchestration process catches dependencies, documents decisions, and ensures verification. Skipping it creates technical debt and breaks traceability.

---

## Complexity Triage

Before invoking the orchestrator, assess the change:

| Criteria | Route |
|----------|-------|
| Single file, <50 lines, no dependencies, isolated fix | Consider `/knowzcode:fix` instead |
| Multiple files OR architectural impact OR new feature | **Continue with full orchestration below** |

If genuinely trivial, inform the user: "This appears to be a micro-fix. Would you prefer `/knowzcode:fix` for a faster path, or full orchestration for traceability?"

---

## Execution

**REQUIRED FIRST ACTION**: Invoke the kc-orchestrator sub-agent using the Task tool.

```
Use the kc-orchestrator sub-agent to initialize and coordinate a new KnowzCode workflow session

Context:
- Primary Goal: $ARGUMENTS
- Mode: New WorkGroup initialization
- Expected Flow: Initialize → Phase 1A → Phase 1B → Phase 2A → Phase 2B → Phase 3

Instructions for orchestrator:
1. Load KnowzCode context from knowzcode/*.md files
2. Generate a new WorkGroupID (format: kc-feat-YYYYMMDD-HHMMSS)
3. Create workgroup file at knowzcode/workgroups/{WorkGroupID}.md
4. Begin with Phase 1A (Impact Analysis)
5. Proceed through phases with user approval at each gate
6. Ensure all todos in workgroup file use "KnowzCode: " prefix
```

**DO NOT** attempt to perform any of the orchestrator's work yourself. Delegate completely.

The orchestrator will coordinate with phase-specific sub-agents and maintain loop state throughout the workflow.
