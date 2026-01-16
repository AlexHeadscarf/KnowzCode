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

## Input Classification (Pre-Check)

Before proceeding with full orchestration, classify the input.

### Question Detection

Analyze `$ARGUMENTS` for investigation patterns:

**Question Indicators** (suggest `/kc:plan investigate`):
- Starts with: `is`, `does`, `how`, `why`, `are`, `what`, `can`, `should`
- Contains: `properly`, `correctly`, `using`, `following`, `?`
- Phrased as inquiry: "tell me", "explain", "analyze", "check if"

**Implementation Indicators** (proceed with `/kc:work`):
- Starts with: `build`, `add`, `create`, `implement`, `fix`, `refactor`, `update`, `remove`
- Contains: `feature`, `functionality`, `endpoint`, `component`, `service`
- Action-oriented: imperative verbs requesting creation/modification

### Classification Action

```
IF question_indicators AND NOT implementation_indicators:
    SUGGEST: "This looks like an investigation question. Use:
              /kc:plan investigate '{$ARGUMENTS}'
              This spawns parallel research agents for efficient exploration.
              Then say 'implement' to proceed with findings."
    WAIT for user confirmation before proceeding

IF implementation_indicators:
    CONTINUE with orchestration below
```

### Investigation Context Loading

Check for recent investigation context:
1. Look for `knowzcode/planning/investigation-*.md` files
2. If recent investigation (< 30 min old) exists:
   ```
   Found recent investigation: investigation-{timestamp}.md
   Load this context for Phase 1A? [y/n]
   ```
3. If user confirms or uses `--from-investigation` flag:
   - Load investigation findings
   - Pre-populate Phase 1A with discovered NodeIDs
   - Skip redundant discovery - focus on validation

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

### Phase 1A: Impact Analysis (PARALLEL DISCOVERY)

**PARALLEL is the DEFAULT. SEQUENTIAL is the EXCEPTION.**

Spawn THREE discovery agents IN PARALLEL in a SINGLE response:

| Agent | Focus | Output |
|-------|-------|--------|
| impact-analyst | Change Set identification | NodeID list with [NEEDS_SPEC] markers |
| security-officer | Security implications | Security concerns for the change |
| architecture-reviewer | Architectural impact | Drift warnings, pattern violations |

**SPAWN ALL THREE via Task tool (PARALLEL - SINGLE response with multiple Task calls):**

```
# Task 1: Impact Analysis
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

  Return: Change Set proposal with NodeIDs, risk assessment, and [NEEDS_SPEC] markers

# Task 2: Security Implications (PARALLEL with Task 1)
subagent_type: "security-officer"
prompt: |
  Perform security implications analysis for proposed change.

  Context:
  - WorkGroupID: {wgid}
  - Primary Goal: {$ARGUMENTS}
  - Phase: 1A - Security Discovery (parallel with impact analysis)

  Instructions:
  1. Identify security-sensitive areas affected by this change
  2. Flag OWASP-relevant concerns
  3. Note authentication/authorization implications
  4. Assess data exposure risks

  Return: Security concerns list with severity and recommendations

# Task 3: Architecture Review (PARALLEL with Tasks 1 & 2)
subagent_type: "architecture-reviewer"
prompt: |
  Perform architecture impact analysis for proposed change.

  Context:
  - WorkGroupID: {wgid}
  - Primary Goal: {$ARGUMENTS}
  - Phase: 1A - Architecture Discovery (parallel with impact analysis)

  Instructions:
  1. Assess architectural alignment of proposed change
  2. Identify potential layer violations
  3. Check for pattern consistency
  4. Flag architectural drift concerns

  Return: Architecture assessment with alignment score and concerns
```

**CRITICAL**: Issue ALL THREE Task tool calls in a SINGLE response. Do NOT wait for each to complete before spawning the next.

**When ALL agents return:**
1. Merge results into unified Change Set proposal:
   - NodeIDs from impact-analyst (primary)
   - Security flags from security-officer (annotations)
   - Architecture concerns from architecture-reviewer (annotations)

2. Present merged Change Set for approval:
   ```markdown
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ◆ KnowzCode APPROVAL GATE #1: Change Set
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   **WorkGroupID**: {wgid}
   **Phase**: 1A - Parallel Discovery Complete
   **Agents Consulted**: impact-analyst, security-officer, architecture-reviewer

   **Proposed Change Set** ({N} nodes):
   {list NodeIDs with descriptions and [NEEDS_SPEC] markers}

   **Security Annotations**:
   {security concerns per NodeID if any}

   **Architecture Annotations**:
   {architecture concerns if any}

   **Overall Risk Assessment**: {Low/Medium/High}

   Approve this Change Set to proceed to specification?
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

3. If rejected: Re-spawn relevant agents with user feedback
4. If approved: Update workgroup file, proceed to Phase 1B
5. Update `knowzcode/knowzcode_tracker.md` - add NodeIDs with [WIP] status
6. Log event in `knowzcode/knowzcode_log.md`

---

### Phase 1B: Specification (PARALLEL PER NODEID)

**PARALLEL is the DEFAULT when Change Set has multiple NodeIDs.**

**Single NodeID**: Spawn one spec-chief agent.

**Multiple NodeIDs (2+)**: Spawn PARALLEL spec-chief instances in a SINGLE response:

```
# When Change Set has multiple NodeIDs, spawn them in PARALLEL:

# Task 1: Spec for NodeID_A
subagent_type: "spec-chief"
prompt: |
  Draft specification for a SINGLE NodeID.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 1B - Specification
  - Target NodeID: {NodeID_A}
  - Full Change Set (for reference): {list all NodeIDs}

  Instructions:
  1. Focus ONLY on {NodeID_A} specification
  2. Draft spec with all required sections:
     - Overview, Dependencies, ARC Criteria, Tech Debt, etc.
  3. Save spec to knowzcode/specs/{NodeID_A}.md
  4. Ensure ARC verification criteria are documented

  Return: Summary of spec drafted for {NodeID_A}

# Task 2: Spec for NodeID_B (PARALLEL with Task 1)
subagent_type: "spec-chief"
prompt: |
  Draft specification for a SINGLE NodeID.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 1B - Specification
  - Target NodeID: {NodeID_B}
  - Full Change Set (for reference): {list all NodeIDs}

  Instructions:
  1. Focus ONLY on {NodeID_B} specification
  2. Draft spec with all required sections
  3. Save spec to knowzcode/specs/{NodeID_B}.md
  4. Ensure ARC verification criteria are documented

  Return: Summary of spec drafted for {NodeID_B}

# Task 3, 4, etc.: One per additional NodeID (all PARALLEL)
```

**CRITICAL**: When Change Set has N NodeIDs with [NEEDS_SPEC], issue N Task tool calls in a SINGLE response.

**When ALL spec agents return:**
1. Collect all spec summaries
2. Verify all specs were created (check knowzcode/specs/)
3. Present specs for batch approval:
   ```markdown
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ◆ KnowzCode APPROVAL GATE #2: Specifications
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   **WorkGroupID**: {wgid}
   **Phase**: 1B - Parallel Specification Complete
   **Specs Written**: {N} (in parallel)

   **Specs Drafted**:
   | NodeID | File | Key ARC Criteria |
   |--------|------|------------------|
   | {NodeID_A} | specs/{NodeID_A}.md | {criteria} |
   | {NodeID_B} | specs/{NodeID_B}.md | {criteria} |
   ...

   Review specs and approve to proceed to implementation?
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```
4. If rejected: Re-spawn ONLY the specs that need revision (parallel if multiple)
5. If approved: Update workgroup file, log SpecApproved events, proceed to Phase 2A

---

### Pre-Implementation Commit

Before implementation, create a commit checkpoint:
```bash
git add knowzcode/
git commit -m "KnowzCode: Specs approved for {WorkGroupID}"
```

---

### Phase 2A: Implementation (PARALLEL When Safe)

**PARALLEL is the DEFAULT for NodeID implementation. SEQUENTIAL is the EXCEPTION.**

**Single NodeID**: Spawn one implementation-lead agent.

**Multiple NodeIDs (2+)**: Perform file conflict analysis, then spawn parallel batches.

#### Step 2A.1: File Conflict Analysis

Before spawning implementation agents, analyze file overlaps:

```
1. Read each spec to identify target files:
   FOR each NodeID in Change Set:
     target_files[NodeID] = extract files from knowzcode/specs/{NodeID}.md

2. Build overlap matrix:
   FOR each pair (NodeID_A, NodeID_B):
     IF target_files[NodeID_A] ∩ target_files[NodeID_B] ≠ ∅:
       conflicts.add((NodeID_A, NodeID_B))

3. Group into non-conflicting batches:
   Batch 1: NodeIDs with no conflicts among themselves
   Batch 2: Remaining NodeIDs that conflict with Batch 1
   ...
```

#### Step 2A.2: Parallel Batch Execution

For each batch of non-conflicting NodeIDs, spawn PARALLEL implementation-lead instances in a SINGLE response.

**CRITICAL**: Issue ALL Task tool calls for a batch in a SINGLE response.

**Example with 4 NodeIDs (2 batches):**

```
# Batch 1: Non-conflicting NodeIDs (PARALLEL - SINGLE response)

# Task 1: Implement UI_LoginForm
subagent_type: "implementation-lead"
prompt: |
  Implement a SINGLE NodeID using strict TDD.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2A - Implementation (Batch 1 of 2)
  - Target NodeID: UI_LoginForm
  - Spec: knowzcode/specs/UI_LoginForm.md

  Instructions:
  1. Read spec from knowzcode/specs/UI_LoginForm.md
  2. Follow TDD for ALL features in spec
  3. Run verification loop for this NodeID
  4. Report status when complete

  Return: Implementation status for UI_LoginForm

# Task 2: Implement SVC_EmailService (PARALLEL with Task 1)
subagent_type: "implementation-lead"
prompt: |
  Implement a SINGLE NodeID using strict TDD.

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2A - Implementation (Batch 1 of 2)
  - Target NodeID: SVC_EmailService
  - Spec: knowzcode/specs/SVC_EmailService.md

  Instructions:
  1. Read spec from knowzcode/specs/SVC_EmailService.md
  2. Follow TDD for ALL features in spec
  3. Run verification loop for this NodeID
  4. Report status when complete

  Return: Implementation status for SVC_EmailService

# Wait for Batch 1 to complete, then spawn Batch 2
```

#### Step 2A.3: Batch Completion and Continuation

**When Batch N agents return:**
1. Collect all implementation statuses
2. If ANY failed after max iterations: Present blocker for that NodeID
3. If ALL succeeded: Proceed to Batch N+1 (if exists) or Phase 2B

**After ALL batches complete:**
1. Run unified verification across all NodeIDs
2. Present consolidated implementation summary
3. Update workgroup file, proceed to Phase 2B

**Fallback for Complex Conflicts:**

If conflict analysis is uncertain or >50% of NodeIDs conflict:
```
Fall back to SEQUENTIAL execution:
- Spawn one implementation-lead per NodeID
- Wait for completion before spawning next
- Safer but slower
```

---

### Phase 2B: Completeness Audit (PARALLEL AUDIT BATTERY)

**PARALLEL is the DEFAULT. Run multiple audit types simultaneously.**

Spawn THREE audit agents IN PARALLEL in a SINGLE response:

| Agent | Focus | Output |
|-------|-------|--------|
| arc-auditor | ARC criteria compliance | Completion %, gap list |
| spec-quality-auditor | Spec completeness | Spec quality scores |
| security-officer | Security posture | Final security check |

**SPAWN ALL THREE via Task tool (PARALLEL - SINGLE response with multiple Task calls):**

```
# Task 1: ARC Verification
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

# Task 2: Spec Quality Audit (PARALLEL with Task 1)
subagent_type: "spec-quality-auditor"
prompt: |
  Perform spec quality validation (READ-ONLY).

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2B - Post-Implementation Spec Audit

  Instructions:
  1. Verify all specs have been updated to as-built state
  2. Check ARC criteria documentation is complete
  3. Validate timestamps and dependencies
  4. Flag any placeholder or incomplete sections

  Return: Spec quality scores and gaps

# Task 3: Security Posture Audit (PARALLEL with Tasks 1 & 2)
subagent_type: "security-officer"
prompt: |
  Perform post-implementation security audit (READ-ONLY).

  Context:
  - WorkGroupID: {wgid}
  - Phase: 2B - Final Security Check

  Instructions:
  1. Verify security concerns from Phase 1A were addressed
  2. Check for new vulnerabilities introduced
  3. Validate authentication/authorization implementations
  4. Scan for common security anti-patterns

  Return: Security posture report with resolved/unresolved concerns
```

**CRITICAL**: Issue ALL THREE audit Task tool calls in a SINGLE response.

**When ALL audit agents return:**
1. Merge audit results into consolidated report
2. Present unified audit gate:
   ```markdown
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ◆ KnowzCode APPROVAL GATE #3: Audit Results
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   **WorkGroupID**: {wgid}
   **Phase**: 2B - Parallel Audit Battery Complete
   **Auditors Consulted**: arc-auditor, spec-quality-auditor, security-officer

   **ARC Completion**: {X}%
   **Spec Quality Score**: {Y}/100
   **Security Posture**: {SECURE/CONCERNS}

   **Gaps Found** (total: {count}):
   - ARC Gaps: {list}
   - Spec Gaps: {list}
   - Security Gaps: {list}

   **Recommendation**: {proceed / return to implementation}

   How would you like to proceed?
   - Proceed to finalization
   - Return to implementation (fix gaps)
   - Modify specifications
   - Cancel WorkGroup
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```
3. If <100% and user chooses to fix: Return to Phase 2A with gap list
4. If acceptable and user approves: Proceed to Phase 3

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
2. **SPAWNing agents in PARALLEL by default** for discovery/audit phases
3. Spawning sequentially ONLY when data dependencies require it
4. Merging parallel results before presenting to user
5. Receiving results and making decisions
6. Maintaining state without re-reading files
7. Enforcing quality gates at each transition

**PARALLEL is the DEFAULT. SEQUENTIAL is the EXCEPTION.**

**NEVER spawn kc-orchestrator. Stay persistent. Complete the workflow.**
