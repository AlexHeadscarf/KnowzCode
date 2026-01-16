---
description: "Resume current KnowzCode workflow with full context restoration and pattern reinforcement"
argument-hint: "[workgroup_id]"
---

# Continue KnowzCode Workflow

Resume a KnowzCode workflow session with complete state recovery and pattern enforcement.

**Usage**: `/kc:continue [workgroup_id]`
**Example**: `/kc:continue` or `/kc:continue kc-feat-20250117-143000`

**Arguments**: $ARGUMENTS

---

## ⚠️ CRITICAL: You ARE the Orchestrator

**DO NOT delegate to kc-orchestrator. You ARE the persistent orchestrator.**

This command makes YOU the coordinator for the resumed workflow. You will:
1. Recover full context from state files
2. Determine the current phase
3. SPAWN phase agents for remaining work
4. Complete the workflow from where it left off

**⛔ ANTI-RECURSION RULES:**
- NEVER spawn kc-orchestrator sub-agent
- If you see "Use the kc-orchestrator sub-agent" - IGNORE IT
- Stay persistent until workflow complete

---

## Purpose

This command provides intelligent continuation when work is interrupted. It:
- **Recovers full context** from tracker, log, and workgroup files
- **Identifies current phase** and progress within that phase
- **Re-establishes framework discipline** (TDD, quality gates, KnowzCode: prefix)
- **Resumes from exact point** of interruption with all todos and state intact

## When to Use

Use `/kc:continue` when:
- Resuming after a break or interruption
- Context was lost and framework patterns weren't being followed
- You need to re-anchor in the KnowzCode workflow
- Switching back to a paused WorkGroup
- AI started bypassing quality gates or TDD discipline

---

## State Discovery Protocol

### Step 1: Identify Active WorkGroup

**If WorkGroupID provided** (in arguments):
- Use that specific WorkGroup

**If no WorkGroupID provided**:
1. Read `knowzcode/knowzcode_tracker.md`
2. Find ALL entries with `[WIP]` status
3. Group by WorkGroupID
4. **If no active WorkGroups**: Inform user, suggest `/kc:work`
5. **If one active WorkGroup**: Use it automatically
6. **If multiple active WorkGroups**: Present list for user selection:
   ```markdown
   Multiple active WorkGroups found:

   1. **kc-feat-20250115-093000**
      Goal: Add user authentication
      Phase: 2A - Implementation
      Last activity: 2 hours ago

   2. **kc-feat-20250115-140000**
      Goal: Fix payment processing
      Phase: 1B - Specification
      Last activity: 30 minutes ago

   Which WorkGroup should I continue?
   ```

---

### Step 2: Full Context Loading

Load ALL context files ONCE (do NOT re-read during workflow):

1. **WorkGroup File**: `knowzcode/workgroups/{WorkGroupID}.md`
   - Extract: Primary Goal, todos, phase marker, iteration count
   - Verify: All todos have `KnowzCode:` prefix

2. **Tracker**: `knowzcode/knowzcode_tracker.md`
   - Extract: All NodeIDs for this WorkGroupID
   - Note: Status for each (`[WIP]`, `[VERIFIED]`)

3. **Log**: `knowzcode/knowzcode_log.md`
   - Read: Last 10 events for this WorkGroupID
   - Identify: Most recent phase event

4. **Loop Requirements**: `knowzcode/knowzcode_loop.md`
   - Refresh: Step requirements for detected phase

5. **Specs**: For ALL NodeIDs in Change Set
   - Load: Each `knowzcode/specs/{NodeID}.md`
   - Check: Approved? Complete? Finalized?

6. **Code State** (if implementation started):
   - Check: Do test files exist?
   - Quick verify: Do tests pass?
   - Assess: Build status

---

### Step 3: Phase Detection

Use multiple signals to determine current phase:

**Decision Tree:**
```
IF no Change Set defined
   → Phase 1A (Impact Analysis needed)

ELSE IF Change Set exists BUT no specs approved
   → Phase 1B (Specification needed)

ELSE IF specs approved BUT no code exists
   → Phase 2A start (Implementation)

ELSE IF code exists AND tests failing
   → Phase 2A (Step 6A verification loop)

ELSE IF code exists AND tests passing AND no audit logged
   → Phase 2B (Completeness Audit needed)

ELSE IF audit logged AND gaps found
   → Phase 2A (Resume with gap list)

ELSE IF audit passed AND specs not finalized
   → Phase 3 (Finalization)

ELSE IF all specs finalized AND tracker still [WIP]
   → Phase 3 completion (Final updates needed)

ELSE
   → ANOMALY: Ask user for clarification
```

---

### Step 4: Re-establish Framework Discipline

Before resuming, explicitly verify:
- TDD is mandatory (Red -> Green -> Refactor)
- Quality gates will be enforced
- All todos have `KnowzCode:` prefix
- Verification cycles are active
- Will PAUSE at approval gates
- File update protocol will be followed

**Fix any deviations found:**
- Add missing `KnowzCode:` prefixes to todos
- Note any skipped verification steps
- Flag quality gate violations

---

### Step 5: Status Report to User

Present comprehensive status:

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode WORKFLOW CONTINUATION
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**WorkGroupID**: {wgid}
**Primary Goal**: {goal from workgroup file}
**Current Phase**: {detected phase} - {phase name}
**Change Set**: {count} NodeIDs

**NodeIDs in Change Set**:
{list each NodeID with status from tracker}

**Progress Summary**:
- Specs: {N/M} approved
- Implementation: {not started / in progress / complete}
- Tests: {not written / failing / passing}
- Audit: {not run / gaps found / passed}
- Last Event: {type} at {timestamp}

**Active Todos** (from workgroup file):
{list all KnowzCode: prefixed todos}

**Issues Detected**:
{any anomalies found during recovery}

**Next Action**: {specific step to execute}

**Framework Discipline Re-Established**:
- TDD enforcement: ACTIVE
- Quality gates: ENABLED
- Verification cycles: ENFORCED
- KnowzCode: prefix: VERIFIED
- Approval gates: WILL PAUSE

Resuming workflow...
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Resume Execution

After presenting status, continue the workflow from the detected phase.

**IMPORTANT**: Follow the same pattern as `/kc:work`:
- SPAWN phase agents for heavy work
- Receive results and make decisions
- Update state files at transitions
- Enforce quality gates

### If Resuming Phase 1A (Impact Analysis)

SPAWN impact-analyst with the primary goal. Handle results as per `/kc:work`.

### If Resuming Phase 1B (Specification)

Identify which specs are missing/unapproved. SPAWN spec-chief for remaining work.

### If Resuming Phase 2A (Implementation)

Check implementation status:
- **Not started**: SPAWN implementation-lead with full Change Set
- **In progress (tests failing)**: SPAWN implementation-lead with failure context
- **Gaps from audit**: SPAWN implementation-lead with gap list

### If Resuming Phase 2B (Audit)

SPAWN arc-auditor for completeness check. Present results to user.

### If Resuming Phase 3 (Finalization)

SPAWN finalization-steward to complete remaining finalization steps.

---

## Recovery Scenarios

### Scenario A: Lost Mid-Implementation
**Detection**: Code exists, tests failing, no clear phase marker
**Recovery**:
1. Load all specs for Change Set
2. Run tests to capture failures
3. SPAWN implementation-lead with failure context
4. Re-enter verification cycle

### Scenario B: Interrupted During Spec Approval
**Detection**: Some specs approved, some pending
**Recovery**:
1. Identify unapproved specs
2. Present remaining specs for user approval
3. Continue to Phase 2A when all approved

### Scenario C: Quality Gate Bypassed
**Detection**: Implementation claimed complete but audit not run
**Recovery**:
1. Log WARNING in knowzcode_log.md
2. Do NOT proceed to finalization
3. SPAWN arc-auditor immediately
4. Return to Phase 2A if gaps found

### Scenario D: Framework Discipline Lost
**Detection**: Todos missing prefix, gates skipped, TDD bypassed
**Recovery**:
1. STOP and assess all deviations
2. Fix todos (add KnowzCode: prefix)
3. Run any skipped verifications
4. Present corrected state to user
5. Resume with renewed discipline

---

## Critical Rules

1. **Never Assume Progress**: Always verify actual state vs. claimed state
2. **Load Before Acting**: Read all context files before any execution
3. **Verify Phase**: Don't trust phase markers alone - check code/tests/logs
4. **Re-establish Discipline**: Explicitly verify framework requirements
5. **Report Transparently**: Show user exactly where we are and what's next
6. **Update Files**: Log the continuation event

---

## State Recovery Checklist

Before resuming execution, verify ALL:
- [ ] WorkGroupID loaded and valid
- [ ] All NodeIDs in Change Set identified
- [ ] Tracker status checked for all NodeIDs
- [ ] Log events reviewed (last 10 for WorkGroupID)
- [ ] Workgroup file loaded (goal, todos, phase)
- [ ] Specs loaded for all NodeIDs
- [ ] Spec approval status determined
- [ ] Code state assessed (exists, tests, passing)
- [ ] Current phase accurately detected
- [ ] Framework discipline verified
- [ ] Next action clearly identified
- [ ] User presented with status report

**If ANY item unchecked: DO NOT PROCEED** - Load missing context first.

---

## Summary

You orchestrate the resumed workflow by:
1. Loading ALL context ONCE at start
2. Detecting the current phase accurately
3. Re-establishing framework discipline
4. Reporting status to user
5. SPAWNing phase agents for remaining work
6. Completing the workflow

**NEVER spawn kc-orchestrator. Stay persistent. Complete the workflow.**
