# KnowzCode Workflow Reference

> **Note**: This document describes the KnowzCode orchestration workflow. The orchestration logic is now embedded directly in commands (`/kc:work`, `/kc:step`, `/kc:continue`) rather than implemented as a spawnable agent. This file serves as **reference documentation** for the workflow phases and patterns.

---

## Orchestration Model

### Why Commands ARE the Orchestrator

Claude Code filters out agents that have the `Task` tool to prevent recursive agent spawning. Since effective orchestration requires spawning phase agents, the orchestration logic must live in the **main conversation context** (via commands) rather than in a spawnable agent.

**Architecture:**
```
Main Conversation (Command)    ← Persistent context, acts as orchestrator
├── Load context ONCE
├── SPAWN impact-analyst       → Heavy work in isolated context
├── Receive results, update state
├── SPAWN spec-chief           → Heavy work in isolated context
├── Receive results, update state
└── ... continue through phases
```

**Key Benefits:**
- Context loaded once, maintained throughout
- Phase agents work in focused, isolated contexts
- No redundant context loading between phases
- Quality gates enforced by persistent orchestrator

---

## The Complete Workflow Loop

```
START LOOP (for WorkGroupID)
  ├─ Step 1: Initialize WorkGroup
  ├─ Step 2: Phase 1A - Impact Analysis
  │    ├─ Delegate to impact-analyst
  │    ├─ PAUSE for user approval
  │    └─ If rejected: restart Step 2
  ├─ Step 3: Phase 1B - Specification
  │    ├─ Delegate to spec-chief
  │    ├─ PAUSE for user approval
  │    ├─ If rejected: return to Step 3
  │    └─ Optional: Run spec verification checkpoint for large Change Sets
  ├─ Step 4: Pre-Implementation Commit
  ├─ Step 5: Phase 2A - Implementation
  │    └─ Delegate to implementation-lead
  ├─ Step 6A: Initial Verification (Inner Loop)
  │    ├─ Build, test, verify
  │    ├─ If FAILS: return to Step 5 (Implementation)
  │    ├─ Repeat until tests pass
  │    └─ Report "implementation complete"
  ├─ Step 6B: Completeness Audit
  │    ├─ Delegate to arc-auditor (READ-ONLY audit)
  │    ├─ Calculate completion percentage
  │    ├─ PAUSE for user decision:
  │    │    ├─ If <100%: return to Step 5
  │    │    ├─ If acceptable: proceed to Step 7
  │    │    └─ Or modify specs/cancel
  │    └─ Quality gate enforced
  ├─ Step 7-11: Atomic Finalization Loop
  │    ├─ Finalize specs to "as-built"
  │    ├─ Update architecture
  │    ├─ Log ARC-Completion
  │    ├─ Update tracker to [VERIFIED]
  │    ├─ Schedule tech debt
  │    └─ Final commit
  └─ COMPLETE: Report and await next goal
```

---

## Phase Agent Delegation Patterns

### Phase 1A - Impact Analysis
```
subagent_type: "impact-analyst"
prompt: |
  Perform KCv2.0 Loop 1A impact analysis.

  Context:
  - WorkGroupID: {wgid}
  - Primary Goal: {goal}
  - Phase: 1A - Change Set Identification

  Instructions:
  1. Load knowzcode_loop.md for Step 1 requirements
  2. Identify complete Change Set (primary + all dependencies)
  3. Mark [NEEDS_SPEC] dependencies
  4. Create workgroup file with KnowzCode: prefixed discovery tasks
  5. Present Change Set for approval

  Return: Change Set proposal with NodeIDs and risk assessment
```

**PAUSE POINT**: Wait for user approval. If rejected, repeat Phase 1A with feedback.

### Phase 1B - Specification
```
subagent_type: "spec-chief"
prompt: |
  Draft specifications for all Change Set nodes.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 1B - Specification
  - Change Set: {list of NodeIDs}

  Instructions:
  1. Load knowzcode_loop.md Step 3 template
  2. For EACH NodeID in Change Set, draft spec with:
     - All 8 required sections
     - ARC verification criteria
     - Technical debt notes (mirror in workgroup with KnowzCode: prefix)
  3. Present specs for approval

  Return: Complete spec set ready for review
```

**PAUSE POINT**: Wait for user approval. If rejected, revise specs with feedback.

### Phase 2A - Implementation (With Inner Verification Loop)
```
subagent_type: "implementation-lead"
prompt: |
  Implement the Change Set using strict TDD.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2A - Implementation with verification cycle
  - Approved Specs: All NodeIDs have approved specs

  Instructions:
  1. Load knowzcode_loop.md Steps 5-6A
  2. Implement ALL nodes in Change Set
  3. INNER LOOP: After implementation, verify:
     - Build passes
     - Tests pass
     - Static analysis clean
     - ARC criteria met
  4. If ANY verification fails:
     - Fix the issue
     - RESTART verification from beginning
     - Repeat until all checks pass
  5. Report "implementation complete" when verification cycle succeeds

  CRITICAL: Do NOT claim complete until Step 6A verification loop succeeds
  Return: Implementation status and verification results
```

### Phase 2B - Completeness Audit (READ-ONLY)
```
subagent_type: "arc-auditor"
prompt: |
  Perform independent completeness audit (READ-ONLY).

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2B - Implementation Audit
  - Status: Implementation claimed complete from Phase 2A

  Instructions:
  1. Load knowzcode_loop.md Step 6B requirements
  2. READ-ONLY audit: Compare implementation vs specifications
  3. For EACH NodeID in Change Set:
     - Check if specified functionality exists
     - Identify gaps, orphan code, deviations
  4. Calculate objective completion percentage
  5. Assess risk of proceeding

  Return: Audit report with completion %, gaps, and recommendation
```

**PAUSE POINT**: Present audit results and wait for user decision:
- If <100% complete: Return to Phase 2A with gap list
- If acceptable: Proceed to Finalization
- Or: Modify specs / Cancel WorkGroup

### Phase 3 - Atomic Finalization
```
subagent_type: "finalization-steward"
prompt: |
  Execute atomic finalization for verified WorkGroup.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 3 - Finalization (Steps 7-11)
  - Status: Implementation verified and approved

  Instructions:
  1. Load knowzcode_loop.md Steps 7-11
  2. Execute atomic finalization loop:
     Step 7: Finalize EACH spec to "as-built" state
     Step 8: Check and update architecture
     Step 9: Log comprehensive ARC-Completion entry
     Step 10: Update tracker to [VERIFIED], schedule tech debt
     Step 11: Create final commit
  3. Report completion with any REFACTOR_ tasks created

  Return: Finalization complete, WorkGroup closed
```

---

## Critical Rules

### 1. State Persistence
- ALWAYS read `knowzcode/workgroups/{WorkGroupID}.md` at workflow start
- Track current phase in workgroup file
- Record approval decisions
- Count iteration attempts

### 2. Quality Verification Cycles
- **Step 6A Inner Loop**: Repeat Step 5 → Step 6A until tests pass
- **Step 6B Gate**: If audit fails, return to Step 5 with gap report
- **Never skip verification**: Quality gates are mandatory

### 3. User Approval Gates
**MUST PAUSE and wait for explicit approval at:**
- After Phase 1A (Change Set approval)
- After Phase 1B (Spec approval)
- After Phase 6B (Completeness audit decision)
- Any critical unresolvable issue

**Display clear status at each gate:**
```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode APPROVAL GATE #{number}: {Title}
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**WorkGroupID**: kc-{wgid}
**Phase**: {phase}
**Status**: {status}

{Detailed information for decision}

Decision: [Approve/Reject/Modify]
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 4. KnowzCode: Prefix Enforcement
**EVERY todo in workgroup file MUST start with `KnowzCode:`**
- Format: `- KnowzCode: Task description`
- Verify this in each sub-agent delegation
- Check when reading workgroup file

### 5. File Update Protocol
At EVERY phase transition:
1. Update `knowzcode/knowzcode_tracker.md` (status changes)
2. Update `knowzcode/knowzcode_log.md` (event logging)
3. Update `knowzcode/workgroups/{WorkGroupID}.md` (phase progress, todos)

Use Read → Edit → Verify pattern for all file updates.

---

## Handling Loop Failures

### If Phase 1A Rejected
- Return to impact analysis with user feedback
- Revise Change Set
- Re-present for approval

### If Phase 1B Rejected
- Return to spec-chief with specific issues
- Revise specs
- Re-present for approval

### If Step 6A Fails (tests/build fail)
- Sub-agent automatically returns to Step 5
- Fix implementation
- Retry verification
- Repeat until passing

### If Step 6B Audit Fails (<100% complete)
- Present audit gaps to user
- Return to Phase 2A with gap list
- Re-implement missing functionality
- Re-run audit

### Maximum Iterations
- Track iteration count in workgroup file
- If >3 failures on same phase, PAUSE and ask user:
  - Continue trying?
  - Simplify Change Set?
  - Cancel WorkGroup?

---

## State Recovery (for /kc:continue)

### Recovery Protocol
1. **State Discovery**: Find active WorkGroups from tracker
2. **Full Context Loading**: Read all relevant files
3. **Phase Detection**: Use multiple signals to determine current phase
4. **Framework Re-establishment**: Verify TDD, quality gates, prefix enforcement
5. **Status Report**: Present comprehensive state to user
6. **Resume Execution**: Continue from detected phase

### Phase Detection Signals
- Tracker: All nodes [WIP] vs some [VERIFIED]
- Log: Last event type (SpecApproved, ImplementationStart, etc)
- Workgroup: Phase marker or last completed step
- Specs: Draft vs approved vs finalized state
- Code: Exists? Tests exist? Tests passing?

---

## Example Complete Loop Execution

```
User: /kc:work "Add user authentication"

Command (as Orchestrator):
1. Generate WorkGroupID: kc-feat-20250104-193000
2. Create knowzcode/workgroups/kc-feat-20250104-193000.md

3. Phase 1A:
   → SPAWN impact-analyst
   → Receive Change Set: 5 NodeIDs
   → PAUSE: Present Change Set for approval
   → User: Approve
   → Update tracker: 5 NodeIDs to [WIP]

4. Phase 1B:
   → SPAWN spec-chief
   → Receive 5 drafted specs
   → PAUSE: Present specs for approval
   → User: Reject - need more detail on security
   → SPAWN spec-chief again with feedback
   → Receive revised specs
   → PAUSE: Re-present for approval
   → User: Approve
   → Log SpecApproved events

5. Pre-Implementation Commit

6. Phase 2A (Implementation):
   → SPAWN implementation-lead
   → Agent implements + enters Step 6A loop:
      - Implements code
      - Runs tests → FAIL
      - Fixes issue
      - Runs tests → FAIL
      - Fixes issue
      - Runs tests → PASS
      - Reports "implementation complete"

7. Phase 2B (Audit):
   → SPAWN arc-auditor
   → Receive audit: 80% complete (2 NodeIDs missing)
   → PAUSE: Present audit results
   → User: Return to implementation
   → SPAWN implementation-lead with gap list
   → Agent completes missing NodeIDs
   → SPAWN arc-auditor again
   → Receive audit: 100% complete
   → PAUSE: Present updated audit
   → User: Approve

8. Phase 3 (Finalization):
   → SPAWN finalization-steward
   → Finalize all specs to "as-built"
   → Update architecture
   → Log ARC-Completion
   → Update tracker to [VERIFIED]
   → Create REFACTOR_ tasks for tech debt
   → Final commit
   → Report complete

9. WorkGroup closed, await next goal
```

---

## Summary

The KnowzCode workflow is orchestrated by **commands** (not a spawnable agent) that:
- Load context once at start
- SPAWN phase agents for heavy isolated work
- Receive results and update state
- Enforce quality gates with user approval
- Maintain persistent context throughout

This architecture ensures efficient context management and prevents the recursive agent spawning issue.
