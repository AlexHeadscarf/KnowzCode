---
name: continue
description: Automatically intercept continuation phrases and redirect to /knowzcode:continue for proper workflow resumption
trigger: User says "continue", "keep going", "resume", or similar continuation intent
---

# Continue Skill

**Purpose**: Detect when user wants to continue work and redirect to the structured `/knowzcode:continue` command to ensure proper context restoration and framework discipline.

## Trigger Patterns

Activate when user message matches ANY of these patterns:
- "continue"
- "keep going"
- "resume"
- "carry on"
- "proceed"
- "go ahead"
- "next"
- "continue with this"
- "continue working on"
- "let's continue"
- "keep working"

**Context Requirements**:
- Must be in a KnowzCode-initialized project (knowzcode/ directory exists)
- Should NOT trigger if user is clearly giving new instructions
- Should NOT trigger during explicit command execution

## Detection Logic

```
IF user_message matches continuation_pattern AND
   knowzcode_directory exists AND
   NOT currently_executing_command THEN

   trigger_continue_skill()
```

## Skill Behavior

When triggered:

1. **Acknowledge the intent**:
   ```
   I notice you want to continue the current work. To ensure we maintain
   KnowzCode's disciplined workflow and restore full context, I'll use
   the /knowzcode:continue command.
   ```

2. **Check for active WorkGroup**:
   - Search knowzcode/knowzcode_tracker.md for `[WIP]` entries
   - If exactly one active WorkGroup found: auto-detect and use it
   - If multiple active: will present options via the command
   - If none active: will inform and suggest `/knowzcode:work`

3. **Execute continuation command**:
   ```
   /knowzcode:continue [auto-detected-workgroup-id]
   ```

4. **Let orchestrator handle**:
   The command will delegate to kc-orchestrator for full state recovery

## Example Interactions

### Example 1: Simple Continue
```
User: continue
Skill: I'll use /knowzcode:continue to restore context and resume the workflow.
[Executes /knowzcode:continue, orchestrator loads state and presents status]
```

### Example 2: Continue with Context Loss
```
User: let's keep going
Skill: I notice we should continue with the KnowzCode workflow. Let me restore
       the full context to ensure we follow TDD and quality gates properly.
[Executes /knowzcode:continue, orchestrator re-establishes discipline]
```

### Example 3: Continue After Interruption
```
User: resume where we left off
Skill: I'll use /knowzcode:continue to find where we left off and restore
       all WorkGroup context.
[Executes /knowzcode:continue, orchestrator detects phase and resumes]
```

## When NOT to Trigger

Do NOT trigger this skill if:
- User is giving specific new instructions (e.g., "continue with a new feature to add X")
- User is asking a question (e.g., "should we continue with this approach?")
- Already executing a /knowzcode:* command
- User says "continue" but context clearly indicates they mean something else
- knowzcode/ directory doesn't exist (not a KnowzCode project)

## Integration with Command

This skill is a **lightweight interceptor** that:
- ✓ Detects continuation intent
- ✓ Redirects to structured command
- ✓ Lets kc-orchestrator do the heavy lifting
- ✓ Ensures framework discipline is maintained

The actual state recovery, context loading, and workflow resumption is handled by `/knowzcode:continue` via the kc-orchestrator.

## Benefits

1. **User Convenience**: Natural language "continue" works seamlessly
2. **Framework Enforcement**: Automatically triggers proper workflow restoration
3. **Context Preservation**: Ensures all state is loaded before proceeding
4. **Pattern Reinforcement**: Re-establishes TDD, quality gates, KnowzCode: prefix
5. **Interruption Recovery**: Handles context loss gracefully

## Skill Configuration

**Priority**: High (should check before generic responses)
**Auto-invoke**: Yes (when pattern matches)
**Requires confirmation**: No (safe operation, just redirects to command)
**Logging**: Log skill activation in knowzcode/knowzcode_log.md as:

```markdown
---
**Type:** SkillActivation
**Timestamp:** [Generated Timestamp]
**Skill:** continue
**Trigger:** User said "{user_message}"
**Action:** Redirected to /knowzcode:continue
**Logged By:** AI-Agent
---
```
