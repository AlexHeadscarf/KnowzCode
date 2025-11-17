---
description: "Resume current KnowzCode workflow with full context restoration and pattern reinforcement"
argument-hint: "[workgroup_id]"
---

# Continue KnowzCode Workflow

Resume a KnowzCode workflow session with complete state recovery and pattern enforcement.

**Usage**: `/knowzcode:continue [workgroup_id]`
**Example**: `/knowzcode:continue` or `/knowzcode:continue kc-feat-20250117-143000`

**Arguments**: $ARGUMENTS

## Purpose

This command provides intelligent continuation when work is interrupted. It:
- **Recovers full context** from tracker, log, and workgroup files
- **Identifies current phase** and progress within that phase
- **Re-establishes framework discipline** (TDD, quality gates, KnowzCode: prefix)
- **Resumes from exact point** of interruption with all todos and state intact

## When to Use

Use `/knowzcode:continue` when:
- Resuming after a break or interruption
- Context was lost and framework patterns weren't being followed
- You need to re-anchor in the KnowzCode workflow
- Switching back to a paused WorkGroup
- AI started bypassing quality gates or TDD discipline

## Execution

Use the kc-orchestrator sub-agent to restore and continue the workflow

Context:
- WorkGroupID: $1 (if provided, otherwise auto-detect active WorkGroup)
- Mode: State recovery and continuation
- Critical: Must restore ALL context before proceeding

Instructions for orchestrator:
1. **State Discovery**:
   - If WorkGroupID provided, load that specific workgroup
   - Otherwise, search knowzcode/knowzcode_tracker.md for active `[WIP]` entries
   - If multiple active WorkGroups, present list for user selection
   - If no active WorkGroups, inform user and suggest `/knowzcode:work`

2. **Full Context Loading**:
   - Read `knowzcode/workgroups/{WorkGroupID}.md` (todos, phase, history)
   - Read `knowzcode/knowzcode_tracker.md` (NodeID status, Change Set scope)
   - Read `knowzcode/knowzcode_log.md` (last 5 events for this WorkGroupID)
   - Read `knowzcode/knowzcode_loop.md` (workflow requirements)
   - Load all specs for NodeIDs in this WorkGroup's Change Set

3. **Phase Detection**:
   Determine current phase by analyzing:
   - Tracker status: All nodes still `[WIP]` indicates pre-verification
   - Log events: Last logged phase event (e.g., "SpecApproved" → post-1B)
   - Workgroup file: Phase marker or last completed step
   - Code state: Run quick checks (do tests exist? do they pass?)

   Phase inference rules:
   - If specs not all approved → Phase 1B (or earlier)
   - If specs approved but no code → Phase 2A (Implementation)
   - If code exists but failing tests → Phase 2A (Implementation loop)
   - If tests passing but not audited → Phase 6A complete, start 6B
   - If audit shows gaps → Phase 2A (Implementation with gap list)
   - If audit passed but not finalized → Phase 3 (Finalization)

4. **Pattern Reinforcement**:
   Before resuming, explicitly remind yourself:
   - ✓ TDD is mandatory (Red → Green → Refactor)
   - ✓ Quality gates cannot be skipped
   - ✓ All todos MUST have `KnowzCode:` prefix
   - ✓ Verification cycle runs after implementation
   - ✓ PAUSE at approval gates
   - ✓ Update tracker/log at phase boundaries

5. **Status Report**:
   Present a comprehensive status report to user:
   ```markdown
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ◆ KnowzCode WORKFLOW CONTINUATION
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   **WorkGroupID**: {wgid}
   **Primary Goal**: {goal from workgroup file}
   **Current Phase**: {detected phase} - {phase name}
   **Change Set**: {count} NodeIDs [{list of NodeIDs}]

   **Progress Summary**:
   - Specs: {N/M approved}
   - Implementation: {status}
   - Tests: {passing/failing/not yet written}
   - Last Event: {most recent log entry}

   **Active Todos** (from workgroup file):
   {list all KnowzCode: prefixed todos with completion status}

   **Next Action**: {specific next step from knowzcode_loop.md}

   **Framework Discipline Re-Established**:
   ✓ TDD enforcement active
   ✓ Quality gates will be respected
   ✓ Verification cycles enabled
   ✓ KnowzCode: prefix enforced

   Resuming workflow now...
   ◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

6. **Resume Execution**:
   - Delegate to the appropriate phase-specific sub-agent
   - Pass ALL loaded context to the sub-agent
   - Ensure sub-agent understands this is a CONTINUATION, not a fresh start
   - Monitor that framework patterns are being followed
   - If sub-agent starts deviating, intervene and re-establish discipline

## Recovery Scenarios

### Scenario: Lost Context Mid-Implementation
**Detection**: Code exists, tests failing, no clear phase marker
**Recovery**:
- Load all specs for Change Set
- Run tests to identify failures
- Resume Phase 2A with failure context
- Re-enter Step 6A verification cycle

### Scenario: Interrupted During Spec Approval
**Detection**: Some specs approved, some pending
**Recovery**:
- Present remaining specs for approval
- Resume Phase 1B from last unapproved spec
- Ensure all specs approved before proceeding

### Scenario: Quality Gate Bypassed
**Detection**: Implementation claimed complete but audit not run
**Recovery**:
- Immediately trigger Phase 6B audit
- Present audit results with completion percentage
- Return to Phase 2A if gaps found

### Scenario: Multiple Active WorkGroups
**Detection**: Tracker shows multiple `[WIP]` entries with different WorkGroupIDs
**Recovery**:
- List all active WorkGroups with their goals
- Ask user which to continue
- Load selected WorkGroup context
- Optionally suggest closing abandoned WorkGroups

## Critical Rules

1. **Never Assume Progress**: Always verify actual state vs. claimed state
2. **Load Before Acting**: Read all context files before any execution
3. **Verify Phase**: Don't trust phase markers alone - check code/tests/logs
4. **Re-establish Discipline**: Explicitly remind yourself of framework requirements
5. **Report Transparently**: Show user exactly where we are and what's next
6. **Update Files**: Ensure tracker/log/workgroup reflect continuation event

## State Recovery Checklist

Before resuming execution, verify:
- [ ] WorkGroupID loaded and valid
- [ ] All NodeIDs in Change Set identified
- [ ] Specs loaded for all NodeIDs
- [ ] Current phase accurately determined
- [ ] Todos loaded from workgroup file
- [ ] Last log events reviewed
- [ ] Framework patterns re-established
- [ ] Next action clearly identified
- [ ] User presented with status report

Only proceed when ALL items checked.
