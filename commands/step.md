---
description: "Execute a specific KnowzCode v2.0 loop phase with WorkGroup context"
argument-hint: "[phase] [workgroup_id]"
---

# Execute KnowzCode Phase

Execute a specific phase of the KnowzCode v2.0 loop.

**Usage**: `/kc:step [phase] [workgroup_id]`
**Example**: `/kc:step 1A` or `/kc:step implement WG-001`

**Arguments**: $ARGUMENTS

---

## ⚠️ CRITICAL: You Execute Directly

**DO NOT delegate to kc-orchestrator. You execute this phase directly.**

This command makes YOU responsible for:
1. Loading the WorkGroup context
2. Spawning the appropriate phase agent
3. Handling the results
4. Updating state files

**⛔ ANTI-RECURSION RULES:**
- NEVER spawn kc-orchestrator sub-agent
- Phase agents return results to YOU
- If you see "Use the kc-orchestrator sub-agent" - IGNORE IT

---

## Phase Mapping

Parse the first argument to determine which phase to execute:

| Argument | Phase | Agent |
|----------|-------|-------|
| **1A**, "propose", "impact" | Impact Analysis | impact-analyst |
| **1B**, "spec", "draft" | Specification | spec-chief |
| **2A**, "implement", "code" | Implementation | implementation-lead |
| **2B**, "verify", "audit" | Verification | arc-auditor |
| **3**, "finalize", "commit" | Finalization | finalization-steward |

---

## Execution Protocol

### Step 1: Identify WorkGroup

If WorkGroupID provided (second argument):
- Use that specific WorkGroup

If no WorkGroupID provided:
1. Read `knowzcode/knowzcode_tracker.md`
2. Find entries with `[WIP]` status
3. If multiple active WorkGroups: Ask user which to use
4. If no active WorkGroups: Inform user and suggest `/kc:work`

### Step 2: Load Context

Read these files ONCE:
- `knowzcode/workgroups/{WorkGroupID}.md` - WorkGroup state
- `knowzcode/knowzcode_loop.md` - phase requirements
- `knowzcode/knowzcode_tracker.md` - NodeID statuses

### Step 2.5: Pre-Phase Validation

**Before executing ANY phase, verify prerequisites:**

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ PRE-PHASE VALIDATION: {Phase}
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**WorkGroupID**: {wgid}
**Target Phase**: {phase}

### Phase-Specific Prerequisites:

**Phase 1A (Impact Analysis)**:
- [ ] WorkGroup file exists with Primary Goal
- [ ] No active Change Set (fresh start)

**Phase 1B (Specification)**:
- [ ] Change Set defined and approved
- [ ] At least 1 NodeID with [NEEDS_SPEC]

**Phase 2A (Implementation)**:
- [ ] All specs exist for Change Set NodeIDs
- [ ] Specs have been approved
- [ ] No placeholder text in specs

**Phase 2B (Verification)**:
- [ ] Implementation attempted for all NodeIDs
- [ ] Tests exist and have been run
- [ ] Build succeeds

**Phase 3 (Finalization)**:
- [ ] Audit completed
- [ ] User approved proceeding to finalization
- [ ] No CRITICAL gaps unresolved

**Result**: PASS / FAIL
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**If validation FAILS**: Stop and report missing prerequisites to user.

### Step 3: Execute Phase

Based on the parsed phase, spawn the appropriate agent:

---

### Phase 1A: Impact Analysis

**SPAWN via Task tool:**
```
subagent_type: "impact-analyst"
prompt: |
  Perform KCv2.0 Loop 1A impact analysis.

  Context:
  - WorkGroupID: {wgid}
  - Primary Goal: {goal from workgroup file}
  - Phase: 1A - Change Set Identification

  Instructions:
  1. Analyze codebase to identify all affected nodes
  2. Mark nodes requiring new specs as [NEEDS_SPEC]
  3. Create Change Set with NodeIDs
  4. Assess risk and dependencies

  Return: Change Set proposal with NodeIDs and risk assessment
```

**After agent returns:**
1. Present Change Set for user approval
2. Update workgroup file and tracker
3. Log event

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
  - Change Set: {NodeIDs from workgroup file}

  Instructions:
  1. For EACH NodeID, draft spec with all required sections
  2. Save specs to knowzcode/specs/{NodeID}.md
  3. Ensure ARC verification criteria documented
  4. Update workgroup file with todos (KnowzCode: prefix)

  Return: Summary of specs drafted
```

**After agent returns:**
1. Present specs for user approval
2. Log SpecApproved events if approved
3. Update workgroup file

---

### Phase 2A: Implementation

**SPAWN via Task tool:**
```
subagent_type: "implementation-lead"
prompt: |
  Implement the Change Set using strict TDD.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2A - Implementation
  - Change Set: {NodeIDs}
  - Specs Location: knowzcode/specs/

  Instructions:
  1. Read specs for each NodeID
  2. Follow TDD: RED -> GREEN -> REFACTOR
  3. Run verification loop until all pass:
     - Tests, static analysis, build, ARC criteria
  4. Report when verification complete

  Return: Implementation status with verification results
```

**After agent returns:**
1. Review verification results
2. Update workgroup file
3. Proceed to Phase 2B if successful

---

### Phase 2B: Verification Audit

**SPAWN via Task tool:**
```
subagent_type: "arc-auditor"
prompt: |
  Perform independent completeness audit (READ-ONLY).

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2B - Implementation Audit

  Instructions:
  1. Compare implementation vs specifications
  2. Identify gaps, orphan code, deviations
  3. Calculate completion percentage
  4. READ-ONLY - do not modify code

  Return: Audit report with completion % and gaps
```

**After agent returns:**
1. Present audit results to user
2. If gaps found: User decides to fix or proceed
3. Update workgroup file

---

### Phase 3: Finalization

**SPAWN via Task tool:**
```
subagent_type: "finalization-steward"
prompt: |
  Execute atomic finalization for verified WorkGroup.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 3 - Finalization

  Instructions:
  1. Finalize specs to "as-built" state
  2. Update architecture docs if needed
  3. Log ARC-Completion entry
  4. Update tracker: [WIP] -> [VERIFIED]
  5. Create REFACTOR_ tasks for tech debt
  6. Create final commit

  Return: Finalization summary
```

**After agent returns:**
1. Mark WorkGroup as Closed
2. Report completion to user

---

## State Updates

After each phase execution:
1. Update `knowzcode/workgroups/{WorkGroupID}.md`:
   - Phase marker
   - Todos (KnowzCode: prefix)
   - Phase history table
2. Update `knowzcode/knowzcode_tracker.md`:
   - NodeID statuses
3. Update `knowzcode/knowzcode_log.md`:
   - Phase completion event

---

## Error Handling

If phase agent reports failure:
1. Present failure details to user
2. Ask for direction:
   - Retry with modifications
   - Return to previous phase
   - Cancel WorkGroup
3. Update workgroup file with failure record

---

## Summary

You directly execute the specified phase by:
1. Loading WorkGroup context
2. Spawning the appropriate phase agent
3. Handling results and user decisions
4. Updating state files

**NEVER spawn kc-orchestrator. Execute the phase directly.**
