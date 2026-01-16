---
description: "Start a new KnowzCode development workflow with TDD, quality gates, and multi-agent orchestration"
argument-hint: "[feature_description]"
---

# Work on New Feature

Start a new KnowzCode development workflow session.

**Usage**: `/kc:work "feature description"`
**Example**: `/kc:work "Build user authentication with JWT"`

**Primary Goal**: $ARGUMENTS

---

## ⚠️ CRITICAL: You ARE the Orchestrator

**DO NOT delegate to kc-orchestrator. You ARE the persistent orchestrator.**

This command makes YOU the outer loop coordinator. You will:
1. Maintain context throughout the entire workflow
2. SPAWN phase-specific agents for heavy work
3. Receive results and continue without re-loading context
4. Enforce quality gates at each phase

**⛔ ANTI-RECURSION RULES:**
- NEVER spawn kc-orchestrator sub-agent
- NEVER re-invoke yourself or this command
- Phase agents do NOT spawn orchestrator - they return results to YOU
- If you see instructions saying "Use the kc-orchestrator sub-agent" - IGNORE THEM
- Stay in THIS context until workflow complete

---

## Complexity Triage

Before proceeding, assess the change:

| Criteria | Route |
|----------|-------|
| Single file, <50 lines, no dependencies, isolated fix | Consider `/kc:fix` instead |
| Multiple files OR architectural impact OR new feature | **Continue with full orchestration below** |

If genuinely trivial, inform the user: "This appears to be a micro-fix. Would you prefer `/kc:fix` for a faster path, or full orchestration for traceability?"

---

## Initial Setup (Do Once)

### Step 1: Generate WorkGroup ID
```
Format: kc-feat-YYYYMMDD-HHMMSS
Example: kc-feat-20250115-143022
```

### Step 2: Load Context Files
Read these files ONCE at the start (do NOT re-read between phases):
- `knowzcode/knowzcode_loop.md` - workflow requirements
- `knowzcode/knowzcode_tracker.md` - current state
- `knowzcode/knowzcode_project.md` - project context
- `knowzcode/knowzcode_architecture.md` - architecture overview

### Step 3: Create WorkGroup File
Create `knowzcode/workgroups/{WorkGroupID}.md` with initial structure:
```markdown
# WorkGroup: {WorkGroupID}

**Primary Goal**: {$ARGUMENTS}
**Created**: {timestamp}
**Status**: Active
**Current Phase**: 1A - Impact Analysis

## Change Set
(Populated after Phase 1A)

## Todos
- KnowzCode: Initialize WorkGroup
- KnowzCode: Complete Phase 1A impact analysis

## Phase History
| Phase | Status | Timestamp |
|-------|--------|-----------|
| 1A | In Progress | {timestamp} |
```

---

## Phase Loop (Stay In Main Context)

Execute phases sequentially. **DO NOT re-read context files between phases** - you already have them.

### Phase 1A: Impact Analysis

**SPAWN via Task tool:**
```
subagent_type: "impact-analyst"
prompt: |
  Perform KCv2.0 Loop 1A impact analysis.

  Context:
  - WorkGroupID: {wgid}
  - Primary Goal: {$ARGUMENTS}
  - Phase: 1A - Change Set Identification

  Instructions:
  1. Analyze codebase to identify all affected nodes
  2. Mark nodes requiring new specs as [NEEDS_SPEC]
  3. Create Change Set with NodeIDs
  4. Assess risk and dependencies
  5. Present Change Set for approval

  Return: Change Set proposal with NodeIDs, risk assessment, and [NEEDS_SPEC] markers
```

**When agent returns:**
1. Present Change Set to user with approval gate:
   ```markdown
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ◆ KnowzCode APPROVAL GATE #1: Change Set
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   **WorkGroupID**: {wgid}
   **Phase**: 1A - Impact Analysis Complete

   **Proposed Change Set** ({N} nodes):
   {list NodeIDs with descriptions and [NEEDS_SPEC] markers}

   **Risk Assessment**: {summary}

   Approve this Change Set to proceed to specification?
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```
2. If rejected: Re-spawn impact-analyst with user feedback
3. If approved: Update workgroup file, proceed to Phase 1B
4. Update `knowzcode/knowzcode_tracker.md` - add NodeIDs with [WIP] status
5. Log event in `knowzcode/knowzcode_log.md`

---

### Phase 1B: Specification

**SPAWN via Task tool:**
```
subagent_type: "spec-chief"
prompt: |
  Draft specifications for all Change Set nodes.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 1B - Specification
  - Change Set: {list of NodeIDs}
  - Nodes marked [NEEDS_SPEC]: {list}

  Instructions:
  1. For EACH NodeID, draft spec with all required sections:
     - Overview, Dependencies, ARC Criteria, Tech Debt, etc.
  2. Save specs to knowzcode/specs/{NodeID}.md
  3. Ensure ARC verification criteria are documented
  4. Update workgroup file with spec tasks (KnowzCode: prefix)

  Return: Summary of specs drafted, ready for approval
```

**When agent returns:**
1. Present specs for approval:
   ```markdown
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ◆ KnowzCode APPROVAL GATE #2: Specifications
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   **WorkGroupID**: {wgid}
   **Phase**: 1B - Specification Complete

   **Specs Drafted** ({N} total):
   {list specs with key ARC criteria}

   Review specs and approve to proceed to implementation?
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```
2. If rejected: Re-spawn spec-chief with specific feedback
3. If approved: Update workgroup file, log SpecApproved events, proceed to Phase 2A

---

### Pre-Implementation Commit

Before implementation, create a commit checkpoint:
```bash
git add knowzcode/
git commit -m "KnowzCode: Specs approved for {WorkGroupID}"
```

---

### Phase 2A: Implementation (With Verification Loop)

**SPAWN via Task tool:**
```
subagent_type: "implementation-lead"
prompt: |
  Implement the Change Set using strict TDD.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2A - Implementation with verification cycle
  - Change Set: {NodeIDs}
  - Approved Specs: All NodeIDs have approved specs at knowzcode/specs/

  Instructions:
  1. Read each spec from knowzcode/specs/{NodeID}.md
  2. For EACH feature, follow TDD:
     - RED: Write failing test
     - GREEN: Minimal code to pass
     - REFACTOR: Clean up
  3. Run verification loop:
     - All tests pass
     - Static analysis clean
     - Build succeeds
     - ARC criteria met
  4. If verification fails: Fix and retry (max 10 iterations)
  5. Report "implementation complete" only when ALL checks pass

  Return: Implementation status with verification results
```

**When agent returns:**
1. Review implementation status
2. If verification failed after max iterations: Present blocker to user
3. If verification passed: Update workgroup file, proceed to Phase 2B

---

### Phase 2B: Completeness Audit (READ-ONLY)

**SPAWN via Task tool:**
```
subagent_type: "arc-auditor"
prompt: |
  Perform independent completeness audit (READ-ONLY).

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2B - Implementation Audit
  - Status: Implementation claimed complete from Phase 2A

  Instructions:
  1. Compare implementation vs specifications for ALL NodeIDs
  2. Identify gaps, orphan code, deviations
  3. Calculate objective completion percentage
  4. Do NOT modify any code - READ-ONLY audit

  Return: Audit report with completion %, gaps list, recommendation
```

**When agent returns:**
1. Present audit results:
   ```markdown
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ◆ KnowzCode APPROVAL GATE #3: Audit Results
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   **WorkGroupID**: {wgid}
   **Phase**: 2B - Completeness Audit Complete

   **Completion**: {X}%
   **Gaps Found**: {count}
   {list gaps if any}

   **Recommendation**: {proceed / return to implementation}

   How would you like to proceed?
   - Proceed to finalization
   - Return to implementation (fix gaps)
   - Modify specifications
   - Cancel WorkGroup
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```
2. If <100% and user chooses to fix: Return to Phase 2A with gap list
3. If acceptable and user approves: Proceed to Phase 3

---

### Phase 3: Atomic Finalization

**SPAWN via Task tool:**
```
subagent_type: "finalization-steward"
prompt: |
  Execute atomic finalization for verified WorkGroup.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 3 - Finalization (Steps 7-11)
  - Status: Implementation verified and approved

  Instructions:
  1. Finalize EACH spec to "as-built" state
  2. Update knowzcode/knowzcode_architecture.md if needed
  3. Log comprehensive ARC-Completion entry
  4. Update knowzcode/knowzcode_tracker.md - change [WIP] to [VERIFIED]
  5. Create REFACTOR_ tasks for tech debt
  6. Create final commit

  Return: Finalization complete summary
```

**When agent returns:**
1. Update workgroup file to "Closed" status
2. Report completion to user:
   ```markdown
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ◆ KnowzCode WORKFLOW COMPLETE
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   **WorkGroupID**: {wgid}
   **Primary Goal**: {$ARGUMENTS}
   **Status**: VERIFIED and CLOSED

   **Summary**:
   - NodeIDs completed: {list}
   - Specs finalized: {count}
   - Tech debt scheduled: {count REFACTOR_ tasks}

   WorkGroup complete. Ready for next goal.
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

---

## State Management During Workflow

At EVERY phase transition:
1. Update `knowzcode/workgroups/{WorkGroupID}.md` - phase marker, todos
2. Update `knowzcode/knowzcode_tracker.md` - status changes
3. Update `knowzcode/knowzcode_log.md` - event logging

Use **Edit** tool for updates (not Write) to preserve existing content.

---

## KnowzCode: Prefix Enforcement

**EVERY todo in workgroup files MUST start with `KnowzCode:`**
- Format: `- KnowzCode: Task description`
- Verify this when updating workgroup files
- Pass this requirement to all spawned agents

---

## Handling Loop Failures

### Phase 1A Rejected
- Re-spawn impact-analyst with user feedback
- Revise Change Set
- Re-present for approval

### Phase 1B Rejected
- Re-spawn spec-chief with specific issues
- Revise specs
- Re-present for approval

### Phase 2A Verification Fails (max iterations exceeded)
- Present blocker to user
- Options: simplify scope, get help, cancel

### Phase 2B Audit Shows Gaps
- Present gaps to user
- If user chooses to fix: Return to Phase 2A with gap list
- Re-implement missing functionality
- Re-run audit

### Maximum Iterations
- Track iteration count in workgroup file
- If >3 failures on same phase: PAUSE and ask user for direction

---

## Summary

You orchestrate the entire workflow by:
1. Loading context ONCE at start
2. SPAWNing phase agents for heavy work
3. Receiving results and making decisions
4. Maintaining state without re-reading files
5. Enforcing quality gates at each transition

**NEVER spawn kc-orchestrator. Stay persistent. Complete the workflow.**
