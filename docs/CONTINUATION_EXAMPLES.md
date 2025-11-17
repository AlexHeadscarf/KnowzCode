# Continuation Feature: Practical Examples

## Quick Reference

**Natural Language**: Just say "continue"
**Explicit Command**: `/knowzcode:continue`
**With WorkGroupID**: `/knowzcode:continue kc-feat-20250117-150000`

---

## Example 1: Simple Interruption Recovery

### Scenario
You're building a feature, get interrupted for lunch, come back.

### Before Interruption
```bash
You: /knowzcode:work "Add password reset functionality"

KnowzCode:
✓ Phase 1A: Impact Analysis → 4 NodeIDs identified
✓ Phase 1B: Specifications → All specs approved
✓ Phase 2A: Implementation starting...
   - Writing tests for PasswordResetService...

[Lunch break - close laptop]
```

### After Interruption
```bash
You: continue

KnowzCode:
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode WORKFLOW CONTINUATION
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**WorkGroupID**: kc-feat-20250117-143022
**Primary Goal**: Add password reset functionality
**Current Phase**: 2A - Implementation (Step 6A verification loop)
**Change Set**: 4 NodeIDs

**Progress Summary**:
- Specs Approved: 4/4 ✓
- Implementation: In progress
- Tests: 2 passing, 3 failing
- Last Event: ImplementationInProgress

**Active Todos**:
- KnowzCode: Fix failing password validation test
- KnowzCode: Implement email sending service
- KnowzCode: Add rate limiting for reset attempts

**Next Action**: Continue Phase 2A - Fix failing tests

Resuming workflow...
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Continuing implementation where you left off...
The tests show validation is failing on edge case: empty email.
Let's fix that with TDD approach:

1. First, let's review the failing test...
```

**Result**: Picked up exactly where you left off, with full context.

---

## Example 2: Framework Discipline Lost

### Scenario
You notice the AI started writing code without tests (TDD violation).

### Problem
```bash
You: continue working on the authentication feature

AI: I'll add the login function now...
[Starts writing production code without a failing test first]

class AuthService {
    public async login(email: string, password: string) {
        // Direct implementation without test!
        ...
```

### Solution
```bash
You: /knowzcode:continue

KnowzCode:
Analyzing current state...

**Detected Issues**:
- WARNING: TDD violation detected
- Production code written without failing test first
- Framework discipline needs re-establishment

Correcting...

✓ Removing non-test-driven code
✓ Re-establishing TDD discipline
✓ Restarting with proper Red-Green-Refactor cycle

**Framework Discipline Status**:
✓ TDD enforcement: ACTIVE (STRICT MONITORING)
✓ Quality gates: ENABLED

Let's restart with TDD:

1. First, write the failing test:

```typescript
describe('AuthService', () => {
    it('should throw error when email is invalid', async () => {
        // This test should fail (RED)
        const authService = new AuthService();
        await expect(
            authService.login('invalid', 'password')
        ).rejects.toThrow('Invalid email');
    });
});
```

Running test... ❌ FAILED (as expected)

Now let's write minimal code to make it pass...
```

**Result**: Framework discipline restored, proper TDD workflow enforced.

---

## Example 3: Multiple Projects

### Scenario
You're juggling two features in the same project.

### Situation
```bash
Project State:
- Feature A: Product reviews (Phase 2A - implementation)
- Feature B: Search filters (Phase 2B - verification)

Both are active [WIP] in tracker.
```

### Continuation
```bash
You: continue

KnowzCode:
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ MULTIPLE ACTIVE WORKGROUPS
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Found 2 active WorkGroups:

1. **kc-feat-20250117-143000** (Feature A)
   Goal: Add product review system
   Phase: 2A - Implementation
   NodeIDs: 3 (REVIEW_001, REVIEW_002, REVIEW_003)
   Last Activity: 2 hours ago

2. **kc-feat-20250117-160000** (Feature B)
   Goal: Enhanced search filters
   Phase: 2B - Verification
   NodeIDs: 2 (SEARCH_001, SEARCH_002)
   Last Activity: 15 minutes ago ← Most recent

Which would you like to continue?
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Your Options**:
```bash
Option 1: "Continue Feature B"
→ Resumes search filters verification

Option 2: "Continue Feature A"
→ Resumes product reviews implementation

Option 3: "/knowzcode:continue kc-feat-20250117-143000"
→ Explicitly selects Feature A
```

**Result**: Clear selection when multiple WorkGroups active.

---

## Example 4: Cross-Session Development

### Scenario
Multi-day feature development with proper state persistence.

### Day 1 (Friday afternoon)
```bash
You: /knowzcode:work "Implement real-time notifications"

KnowzCode:
Phase 1A: Impact Analysis
- Identified 6 NodeIDs
- WebSocket server, notification service, UI components

Phase 1B: Specifications
- All 6 specs drafted and approved

Phase 2A: Implementation
- Implemented 2/6 components
- Tests passing for completed components
- 4 components remaining

[End of workday - commit and close]
```

### Day 2 (Monday morning)
```bash
You: continue

KnowzCode:
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ WORKFLOW CONTINUATION
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**WorkGroupID**: kc-feat-20250115-160000
**Primary Goal**: Implement real-time notifications
**Current Phase**: 2A - Implementation
**Change Set**: 6 NodeIDs

**Progress Summary**:
- Specs Approved: 6/6 ✓
- Implementation: 2/6 complete
- Tests: All passing ✓
- Last Activity: Friday 5:30 PM

**Completed**:
✓ NOTIFY_001: WebSocket connection manager
✓ NOTIFY_002: Connection state handling

**Remaining**:
- NOTIFY_003: Notification queue service
- NOTIFY_004: Message formatting
- NOTIFY_005: UI notification component
- NOTIFY_006: Notification preferences

**Next Action**: Continue implementing NOTIFY_003

Resuming where you left off on Friday...
Let's implement the notification queue service with TDD...
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Result**: Seamless continuation across weekend break.

---

## Example 5: Quality Gate Enforcement

### Scenario
Someone tries to skip the audit phase.

### The Problem
```bash
Implementation finishes, tests pass.

Developer thinks: "Tests pass, I'll just finalize..."
Developer runs: /knowzcode:step 3
→ Tries to jump to finalization without audit
```

### KnowzCode Protection
```bash
KnowzCode:
⚠️  WARNING: Quality gate violation detected!

Phase 2B (Completeness Audit) was skipped.
Implementation must be audited before finalization.

Triggering mandatory audit now...

[Runs arc-auditor]

Audit Results:
- REVIEW_001: ✓ Complete (100%)
- REVIEW_002: ⚠️ Partially implemented (65%)
  Missing: Error handling for edge cases
  Missing: Input validation tests
- REVIEW_003: ✓ Complete (100%)

Overall: 88% complete

Cannot proceed to finalization.
Returning to Phase 2A to complete REVIEW_002...

**Gaps to address**:
1. Add error handling in ReviewService.submit()
2. Add validation tests for malicious input
3. Re-verify after fixes
```

### Proper Flow After Fix
```bash
You: continue

KnowzCode:
Loading context...
Previous audit found gaps in REVIEW_002.

**Next Action**: Complete REVIEW_002 implementation

Implementing missing error handling with TDD...

[After fixes]

Re-running audit...
✓ All 3 NodeIDs now 100% complete
✓ Quality gate passed

Proceeding to Phase 3 finalization...
```

**Result**: Quality gates cannot be bypassed, work is complete before finalization.

---

## Example 6: Emergency Bug Fix Interruption

### Scenario
Working on feature, production bug found, need to context switch.

### Feature Work in Progress
```bash
You: /knowzcode:work "Add shopping cart persistence"

KnowzCode:
Phase 1A: Complete
Phase 1B: Specs approved
Phase 2A: Implementation started (20% done)

[URGENT: Production bug reported!]
```

### Handle Bug Fix
```bash
You: /knowzcode:work "Fix critical payment timeout issue"

KnowzCode:
Starting new WorkGroup: kc-fix-20250117-110000
[Complete bug fix workflow...]
✓ Bug fixed and deployed

WorkGroup kc-fix-20250117-110000 finalized and closed.
```

### Return to Feature
```bash
You: continue

KnowzCode:
Found 2 WorkGroups:

1. **kc-feat-20250117-100000** (Shopping Cart)
   Status: In progress (Phase 2A, 20% complete)
   Last Activity: 2 hours ago

2. **kc-fix-20250117-110000** (Payment Bug)
   Status: [VERIFIED] ← Already complete
   Last Activity: 5 minutes ago

Which to continue?

You: Continue 1

KnowzCode:
Resuming shopping cart persistence feature...

**Where you left off**:
- Implemented CartStore interface
- Started CartPersistenceService
- Next: Add localStorage integration

Continuing implementation...
```

**Result**: Clean context switching with full state preservation.

---

## Pro Tips

### Tip 1: Regular Checkpoints
```bash
# At natural breakpoints, commit and note phase
git commit -m "WIP: Phase 2A - completed data layer"

# Later when continuing, KnowzCode uses commit history too
You: continue
→ Shows exactly what was completed based on commits
```

### Tip 2: Explicit Phase Markers
```bash
# In workgroup file, orchestrator maintains phase markers:
## Current Phase: 2A - Implementation
## Last Step Completed: Step 5.3 - Service layer tests passing
## Next Step: Step 5.4 - Repository implementation

# This makes continuation even more precise
```

### Tip 3: Use Continue After Errors
```bash
# If something goes wrong mid-implementation
Error: Build failed

You: continue
→ KnowzCode detects failure state
→ Loads context of what was attempted
→ Helps debug systematically
```

### Tip 4: Multiple Continuations
```bash
You: continue
[Works for 30 minutes]
[Another interruption]

You: continue
[Works for 15 minutes]
[Another interruption]

You: continue
→ Each continuation loads fresh, complete context
→ No state degradation across multiple resumes
```

---

## Common Patterns

### Pattern 1: Daily Standup
```bash
# Start of day
You: continue

KnowzCode shows:
- What you worked on yesterday
- Current phase and progress
- What's next today
→ Perfect daily standup prep!
```

### Pattern 2: Code Review Break
```bash
# During feature work
You need to review teammate's PR

You: [Reviews PR, gives feedback]

You: continue
→ Returns to your feature work exactly where you left off
```

### Pattern 3: Experimentation
```bash
# Want to try different approach
You: [Try experimental implementation]
Tests fail badly

You: continue
→ KnowzCode detects failing tests
→ Offers to return to last known good state
→ Helps recover from experiments
```

---

## Summary

The continuation feature makes KnowzCode resilient to real-world interruptions while maintaining strict quality standards:

✅ **Natural language** - Just say "continue"
✅ **Full context** - Nothing is lost
✅ **Framework discipline** - TDD and quality gates maintained
✅ **Transparent state** - Always know where you are
✅ **Multiple WorkGroups** - Handle concurrent work
✅ **Cross-session** - Works across days/weeks
✅ **Quality enforcement** - Gates cannot be bypassed

**The result**: Professional, disciplined development even with frequent interruptions.
