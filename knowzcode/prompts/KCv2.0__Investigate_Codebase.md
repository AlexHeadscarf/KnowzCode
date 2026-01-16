# KnowzCode v2.0: Investigate Codebase

> **Automation Path:** Run `/kc:plan investigate "your question"` to spawn parallel research agents for codebase investigation.

## Your Mission

You are performing a focused investigation of the codebase to answer a specific question. You will spawn 1-3 quick research agents (based on question relevance) to gather evidence, then synthesize findings into actionable recommendations.

**Investigation Question**: $ARGUMENTS

---

## ⚠️ CRITICAL: You ARE the Orchestrator

**DO NOT delegate to kc-orchestrator. You ARE the persistent orchestrator.**

This prompt makes YOU the investigation coordinator. You will:
1. Analyze the question and select relevant agents (1-3)
2. Spawn selected agents IN PARALLEL (quick variants)
3. Wait for ALL results before proceeding
4. Synthesize findings into a cohesive answer
5. Enter "Action Listening Mode" for implementation triggers
6. Auto-invoke `/kc:work` if user wants to implement findings

**⛔ ANTI-RECURSION RULES:**
- NEVER spawn kc-orchestrator sub-agent
- Research agents return results to YOU
- Stay in THIS context until investigation complete or handoff to `/kc:work`

---

## Phase 1: Context Loading (Do Once)

Read these files ONCE at the start:
- `knowzcode/knowzcode_project.md` - project context
- `knowzcode/knowzcode_architecture.md` - architecture overview
- `knowzcode/knowzcode_tracker.md` - existing NodeIDs

---

## Phase 2: Selective Agent Spawning

**PARALLEL is the DEFAULT. But spawn ONLY agents that are relevant to the question.**

### Step 1: Determine Which Agents Are Needed

Analyze the question and select agents based on relevance:

| Agent | When to Include | Skip When |
|-------|-----------------|-----------|
| **impact-analyst-quick** | ALWAYS (provides code evidence) | Never skip - always needed |
| **architecture-reviewer-quick** | Question involves patterns, design, structure, consistency, layers | Simple lookup questions, bug hunts, "where is X?" |
| **security-officer-quick** | Question involves auth, security, performance, data handling, risk | Code organization questions, refactoring questions |

**Question Type → Agent Selection Guide:**

| Question Type | Example | Agents |
|---------------|---------|--------|
| Code location | "Where is user auth handled?" | impact-analyst-quick only |
| Implementation check | "How is error handling done?" | impact-analyst-quick + architecture-reviewer-quick |
| Security concern | "Is the API properly secured?" | impact-analyst-quick + security-officer-quick |
| Full assessment | "Is the auth system well designed and secure?" | All 3 agents |
| Pattern consistency | "Are we consistent in how we handle dates?" | impact-analyst-quick + architecture-reviewer-quick |

### Step 2: Spawn Selected Agents (PARALLEL)

**Use the quick variants** - they are optimized for investigation (low-token, focused):

```
# Task 1: Code Exploration (ALWAYS INCLUDE)
subagent_type: "kc:impact-analyst-quick"
prompt: |
  Quick investigation: Find code evidence to answer this question.

  Question: {$ARGUMENTS}

  Constraints: Max 10 tool calls. Focus on 5 most relevant files.

  Return: Code evidence with file paths and line numbers.

# Task 2: Architecture & Pattern Analysis (INCLUDE IF RELEVANT)
subagent_type: "kc:architecture-reviewer-quick"
prompt: |
  Quick assessment: Evaluate patterns and design for this question.

  Question: {$ARGUMENTS}

  Constraints: Max 8 tool calls. Focus on pattern consistency.

  Return: Pattern observations with examples.

# Task 3: Security & Performance (INCLUDE IF RELEVANT)
subagent_type: "kc:security-officer-quick"
prompt: |
  Quick assessment: Check security/performance aspects for this question.

  Question: {$ARGUMENTS}

  Constraints: Max 8 tool calls. Only check relevant OWASP categories.

  Return: Risk observations with severity levels.
```

**CRITICAL**:
- Issue selected Task calls IN PARALLEL (single response)
- Use `kc:*-quick` agents, NOT the full agents
- Omit agents that aren't relevant to the question

---

## Phase 3: Synthesize Findings

**When ALL spawned agents return:**

1. Merge results into unified investigation report
2. Cross-reference findings from agents consulted
3. Identify agreements and conflicts (if multiple agents)
4. Formulate direct answer to the original question
5. Generate actionable recommendations

### Save Investigation Report

Save findings to `knowzcode/planning/investigation-{timestamp}.md`:

```markdown
# Investigation: {question summary}

**Question**: {$ARGUMENTS}
**Timestamp**: {timestamp}
**Agents Consulted**: {list agents actually spawned}

## Executive Summary

{Direct 2-3 sentence answer to the question}

## Detailed Findings

### Code Exploration (impact-analyst)
{findings}

### Pattern Analysis (architecture-reviewer)
{findings}

### Security/Performance Assessment (security-officer)
{findings}

## Synthesis

**Key Findings**:
{consolidated bullet points}

**Cross-Agent Agreements**:
{where agents agree}

**Areas of Concern**:
{issues identified}

## Recommendations

| # | Action | Priority | Effort |
|---|--------|----------|--------|
| 1 | {action} | HIGH/MED/LOW | S/M/L |
| 2 | {action} | HIGH/MED/LOW | S/M/L |
| 3 | {action} | HIGH/MED/LOW | S/M/L |
```

---

## Phase 4: Present Findings

Present investigation results to user:

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode INVESTIGATION COMPLETE
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Question**: {$ARGUMENTS}
**Agents Consulted**: {N} (quick variants, in parallel)

## Summary

{Direct answer to the question}

## Key Findings

{3-5 bullet points summarizing discoveries}

## Recommendations

{numbered list of actionable improvements}

---

**Implementation Options:**

1. {First recommendation action}
2. {Second recommendation action}
3. {Third recommendation action}

Say "implement", "do it", or select an option (e.g., "option 1") to proceed with implementation.
Or say "that's all" if you just needed the information.
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Phase 5: Action Listening Mode

**After presenting findings, enter Action Listening Mode.**

Monitor subsequent user messages for implementation triggers:

### Implementation Triggers (Auto-invoke `/kc:work`)

Detect these patterns in user's next message:

| Pattern | Example | Action |
|---------|---------|--------|
| Imperative verbs | "implement", "fix", "build", "add", "create" | Extract goal, invoke `/kc:work` |
| Confirmation words | "do it", "go ahead", "proceed", "yes", "let's do it" | Use top recommendation |
| Option selection | "option 1", "the first one", "#2", "do number 2" | Use selected recommendation |
| "Fix it" / "Make it work" | "fix it", "make it work", "just do it" | Use top recommendation |

### When Trigger Detected:

1. Extract implementation goal from:
   - User's specific request (if provided)
   - Selected option (if option number given)
   - Top recommendation (if generic "do it")

2. Log investigation context for handoff:
   ```
   Investigation findings available at: knowzcode/planning/investigation-{timestamp}.md
   ```

3. Invoke `/kc:work` with context:
   ```markdown
   **Transitioning to implementation...**

   Goal extracted: "{extracted goal}"
   Investigation context: Pre-loaded from investigation findings

   [INVOKE /kc:work "{extracted goal}"]
   ```

4. Pass investigation findings to Phase 1A:
   - NodeIDs already identified → pre-populate Change Set
   - Security concerns → carry forward as annotations
   - Architecture observations → carry forward as annotations
   - Skip redundant discovery → focus Phase 1A on validation

### Non-Trigger Responses

If user message does NOT contain implementation trigger:
- "ok thanks" → End gracefully: "Investigation complete. Run `/kc:work` when ready to implement."
- "tell me more about X" → Provide additional detail from findings
- "what about Y?" → Follow-up investigation (can spawn additional agents)

---

## Logging

After investigation, log to `knowzcode/knowzcode_log.md`:

```markdown
---
**Type:** Investigation
**Timestamp:** {timestamp}
**Question:** {$ARGUMENTS}
**Finding:** {one-line summary}
**Status:** {Complete | Handoff to /kc:work}
---
```

---

## Summary

You orchestrate investigations by:
1. Loading context ONCE at start
2. Analyzing the question to select relevant agents (1-3)
3. **SPAWNing selected QUICK agents IN PARALLEL** (single response)
4. Waiting for ALL results before proceeding
5. Synthesizing findings into unified answer
6. Saving investigation report to `knowzcode/planning/`
7. Presenting findings with implementation options
8. Entering Action Listening Mode for implementation triggers
9. Auto-invoking `/kc:work` when user wants to implement

**PARALLEL is the DEFAULT. NEVER spawn kc-orchestrator.**
