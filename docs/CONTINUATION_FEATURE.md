# KnowzCode Continuation Feature

## Overview

The continuation feature provides robust interruption handling and context recovery for KnowzCode workflows. It ensures that the framework's disciplined patterns (TDD, quality gates, KnowzCode: prefix enforcement) are maintained even when work is interrupted.

## Components

### 1. `/knowzcode:continue` Command

**Location**: `commands/continue.md`

**Purpose**: Explicit command for resuming work with full state recovery.

**Key Features**:
- Auto-detects active WorkGroups from tracker
- Loads complete context (specs, todos, logs, tests)
- Uses multi-signal phase detection algorithm
- Re-establishes framework discipline
- Presents comprehensive status report before resuming

**Usage**:
```bash
/knowzcode:continue                    # Auto-detect active WorkGroup
/knowzcode:continue kc-feat-20250117   # Specific WorkGroup
```

**What It Does**:
1. **State Discovery**: Finds active WorkGroup(s) from tracker
2. **Full Context Loading**: Loads all relevant files in specific order
3. **Phase Detection**: Uses decision tree to determine current phase
4. **Framework Re-establishment**: Explicitly restores TDD/quality gate discipline
5. **Status Report**: Shows user exactly where we are
6. **Resume Execution**: Delegates to appropriate phase agent with full context

### 2. Continue Skill

**Location**: `skills/continue.md`

**Purpose**: Automatic interception of continuation phrases.

**Trigger Patterns**:
- "continue"
- "keep going"
- "resume"
- "carry on"
- "proceed"
- "go ahead"
- "next"

**Behavior**:
1. Detects continuation intent from user message
2. Verifies knowzcode/ directory exists
3. Acknowledges the intent to user
4. Automatically executes `/knowzcode:continue` command
5. Lets orchestrator handle full state recovery

**Benefits**:
- Natural language works seamlessly
- No need to remember command syntax
- Transparent redirection to structured workflow

### 3. Enhanced kc-orchestrator

**Location**: `agents/kc-orchestrator.md`

**New Section**: "Interruption Handling & State Recovery"

**Key Enhancements**:

#### Mandatory Recovery Protocol
When invoked via `/knowzcode:continue`, orchestrator enters **CONTINUATION MODE**:

1. **State Discovery** (6-step checklist)
2. **Full Context Loading** (6 file categories in specific order)
3. **Phase Detection Algorithm** (decision tree with 7 outcomes)
4. **Framework Discipline Re-establishment** (6-point checklist)
5. **Comprehensive Status Report** (standardized format)
6. **Resume Execution** (with monitoring)

#### Proactive Monitoring
- Detects framework deviations during execution
- Red flags: implementation without tests, quality gates skipped, etc.
- Re-anchoring protocol when deviations detected

#### Common Scenarios
Handles 5 specific interruption scenarios:
- **Scenario A**: Lost mid-implementation
- **Scenario B**: Spec approval incomplete
- **Scenario C**: Quality gate bypassed
- **Scenario D**: Multiple active WorkGroups
- **Scenario E**: Framework discipline lost

#### State Recovery Checklist
14-item verification checklist before delegation:
- WorkGroupID validation
- NodeIDs loaded
- Tracker checked
- Specs loaded
- Phase determined
- Context complete
- And more...

**Critical Rule**: "If ANY item unchecked: DO NOT PROCEED"

#### Continuous State Awareness
Even during normal flow (not just after interruption):
- Re-read workgroup file at phase transitions
- Verify todos have KnowzCode: prefix
- Check iteration count
- Update phase markers
- Log phase transitions

## Architecture

```
User says "continue"
        ↓
Continue Skill (detects pattern)
        ↓
Acknowledges & redirects
        ↓
/knowzcode:continue command
        ↓
kc-orchestrator (CONTINUATION MODE)
        ↓
    ┌───────────────────────────┐
    │  State Discovery          │
    │  Context Loading          │
    │  Phase Detection          │
    │  Discipline Re-establish  │
    │  Status Report            │
    │  Resume Execution         │
    └───────────────────────────┘
        ↓
Delegate to phase-specific agent
        ↓
Monitor for framework adherence
        ↓
Re-anchor if deviation detected
```

## Phase Detection Algorithm

Uses multiple signals to triangulate current phase:

**Signals**:
- Tracker status (all `[WIP]` vs some `[VERIFIED]`)
- Log events (last phase event type)
- Workgroup file (phase marker)
- Specs (draft vs approved vs finalized)
- Code (exists? tests exist? tests passing?)

**Decision Tree**:
```
IF no specs approved
  → Phase 1B (or earlier)

ELSE IF specs approved BUT no code
  → Phase 2A start

ELSE IF code exists AND tests failing
  → Phase 2A (Step 6A loop)

ELSE IF code + tests passing AND no audit
  → Phase 6B (start audit)

ELSE IF audit logged AND gaps found
  → Phase 2A (resume with gaps)

ELSE IF audit passed AND specs not finalized
  → Phase 3 (finalization)

ELSE IF specs finalized AND tracker still [WIP]
  → Phase 3 completion

ELSE
  → ANOMALY: ask user
```

## Framework Discipline Re-establishment

Before resuming, orchestrator explicitly verifies:

✓ TDD is mandatory
✓ Quality gates will be enforced
✓ All todos have KnowzCode: prefix
✓ Will PAUSE at approval gates
✓ Verification cycles active
✓ File update protocol will be followed

**Self-check**: "Am I maintaining the disciplined loop?"

## Status Report Format

When resuming, user sees:

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode WORKFLOW CONTINUATION
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**WorkGroupID**: kc-feat-20250117-143000
**Primary Goal**: Build user authentication
**Current Phase**: 2A - Implementation
**Change Set**: 3 NodeIDs

**NodeIDs in Change Set**:
- AUTH_001 [WIP]
- AUTH_002 [WIP]
- AUTH_003 [WIP]

**Progress Summary**:
- Specs Approved: 3/3
- Implementation: In progress
- Tests: Failing (2 failures)
- Audit: Not run
- Last Event: ImplementationStart at 2025-01-17 14:30

**Active Todos** (from workgroup file):
- KnowzCode: Implement JWT token generation
- KnowzCode: Add password hashing
- KnowzCode: Fix failing login tests

**Detected Issues**:
None

**Next Action**: Continue Phase 2A Step 6A verification cycle

**Framework Discipline Status**:
✓ TDD enforcement: ACTIVE
✓ Quality gates: ENABLED
✓ Verification cycles: ENFORCED
✓ KnowzCode: prefix: VERIFIED
✓ Approval gates: WILL PAUSE

Resuming workflow in Phase 2A...
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Benefits

### For Users
1. **Natural Language**: Just say "continue" - it works
2. **Full Transparency**: See exactly where you are before resuming
3. **No Lost Work**: Complete context recovery guaranteed
4. **Framework Enforcement**: TDD and quality gates maintained
5. **Multiple WorkGroups**: Handles concurrent work gracefully

### For Framework
1. **State Recovery**: Systematic context loading
2. **Phase Accuracy**: Multi-signal detection prevents errors
3. **Discipline Enforcement**: Explicit re-establishment of patterns
4. **Proactive Monitoring**: Detects and corrects deviations
5. **Resilience**: Works across session boundaries

### For Quality
1. **No Shortcuts**: Quality gates cannot be bypassed
2. **TDD Maintained**: Test-first discipline enforced
3. **Verification Cycles**: Continue from exact point in loop
4. **Audit Trail**: All continuations logged
5. **Consistency**: Same high standards after interruptions

## Use Cases

### After a Break
```
User takes lunch. Returns.
User: "continue"
→ Full context restored, work resumes from exact point
```

### Context Lost
```
AI starts bypassing TDD discipline.
User: "/knowzcode:continue"
→ Framework discipline re-established, TDD restored
```

### Switching Tasks
```
Working on Feature A, interrupted by urgent bug.
Fix bug, then: "/knowzcode:continue"
→ System shows active WorkGroups, user selects Feature A
→ Resumes Feature A with all context intact
```

### Multi-Session Development
```
Day 1: Start feature, complete Phase 1A-1B
Day 2: "/knowzcode:continue"
→ Loads specs, detects Phase 2A ready, resumes implementation
```

### Quality Gate Bypassed
```
Implementation claimed "done" without audit.
User: "/knowzcode:continue"
→ Detects missing audit, triggers Phase 6B immediately
```

## Testing Checklist

To verify continuation feature works:

- [ ] Command exists: `commands/continue.md`
- [ ] Skill exists: `skills/continue.md`
- [ ] Orchestrator enhanced: "Interruption Handling" section
- [ ] Natural language triggers: Say "continue"
- [ ] Auto-detection works: Finds active WorkGroup
- [ ] Phase detection accurate: Uses decision tree
- [ ] Context loading complete: All files loaded
- [ ] Status report shown: User sees comprehensive state
- [ ] Framework restored: TDD/gates enforced
- [ ] Resumes correctly: Delegates to right agent
- [ ] Multiple WorkGroups handled: Shows selection
- [ ] Anomalies caught: Asks user when uncertain
- [ ] Logs continuation: Event in knowzcode_log.md
- [ ] Documentation updated: README shows feature

## Future Enhancements

Potential improvements:
1. **Smart suggestions**: "Last worked on 3 days ago, consider reviewing specs first"
2. **Conflict detection**: "Another WorkGroup modified overlapping files"
3. **Health metrics**: "This WorkGroup has been restarted 5 times, consider simplifying"
4. **Auto-cleanup**: "Found abandoned WorkGroup from 2 weeks ago, close it?"
5. **Visual timeline**: Show progression through phases graphically

## Summary

The continuation feature provides **robust interruption recovery** for KnowzCode workflows:

✅ **Command**: `/knowzcode:continue` for explicit resumption
✅ **Skill**: Auto-triggers on "continue" phrases
✅ **Orchestrator**: Enhanced with full recovery protocol
✅ **Phase Detection**: Multi-signal algorithm for accuracy
✅ **Discipline**: Re-establishes TDD and quality gates
✅ **Transparency**: Comprehensive status before resuming
✅ **Resilience**: Works across sessions and interruptions

**Result**: Framework patterns remain intact even when work is interrupted, ensuring consistent quality and discipline throughout development.
