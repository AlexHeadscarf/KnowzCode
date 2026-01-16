# KnowzCode v2.0: Investigate Codebase

> **Automation Path:** Run `/kc:plan investigate "your question"` to spawn parallel research agents for codebase investigation.

## Your Mission

You are performing a parallel investigation of the codebase to answer a specific question. You will spawn multiple research agents simultaneously to gather evidence from different perspectives, then synthesize findings into actionable recommendations.

**Investigation Question**: $ARGUMENTS

---

## ⚠️ CRITICAL: You ARE the Orchestrator

**DO NOT delegate to kc-orchestrator. You ARE the persistent orchestrator.**

This prompt makes YOU the investigation coordinator. You will:
1. Spawn multiple research agents IN PARALLEL
2. Wait for ALL results before proceeding
3. Synthesize findings into a cohesive answer
4. Enter "Action Listening Mode" for implementation triggers
5. Auto-invoke `/kc:work` if user wants to implement findings

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

## Phase 2: Parallel Research (SPAWN THREE AGENTS)

**PARALLEL is the DEFAULT. SEQUENTIAL is the EXCEPTION.**

Spawn THREE research agents IN PARALLEL in a SINGLE response:

| Agent | Focus | Output |
|-------|-------|--------|
| impact-analyst | Code exploration, trace patterns | Evidence and code locations |
| architecture-reviewer | Pattern assessment, design evaluation | Architecture analysis |
| security-officer | Security/performance implications | Risk assessment |

**SPAWN ALL THREE via Task tool (PARALLEL - SINGLE response with multiple Task calls):**

```
# Task 1: Code Exploration
subagent_type: "impact-analyst"
prompt: |
  Investigate the codebase to answer this question.

  Question: {$ARGUMENTS}

  Instructions:
  1. Search for relevant code areas
  2. Trace implementations and patterns
  3. Find all usages and relationships
  4. Document specific file locations with line numbers
  5. Gather concrete evidence

  Return: Code exploration findings with evidence (file paths, line numbers, code snippets)

# Task 2: Architecture & Pattern Analysis (PARALLEL with Task 1)
subagent_type: "architecture-reviewer"
prompt: |
  Analyze architecture and patterns to answer this question.

  Question: {$ARGUMENTS}

  Instructions:
  1. Assess current patterns and approaches used
  2. Compare against best practices
  3. Evaluate design decisions
  4. Identify improvements or concerns
  5. Assess consistency across codebase

  Return: Pattern analysis with conformance assessment and recommendations

# Task 3: Security & Performance Implications (PARALLEL with Tasks 1 & 2)
subagent_type: "security-officer"
prompt: |
  Analyze security and performance implications for this question.

  Question: {$ARGUMENTS}

  Instructions:
  1. Identify security-relevant aspects
  2. Assess performance implications
  3. Flag potential risks or concerns
  4. Note compliance considerations
  5. Suggest security/performance improvements

  Return: Risk assessment with severity levels and recommendations
```

**CRITICAL**: Issue ALL THREE Task tool calls in a SINGLE response. Do NOT wait for each to complete before spawning the next.

---

## Phase 3: Synthesize Findings

**When ALL agents return:**

1. Merge results into unified investigation report
2. Cross-reference findings from all three agents
3. Identify agreements and conflicts between agents
4. Formulate direct answer to the original question
5. Generate actionable recommendations

### Save Investigation Report

Save findings to `knowzcode/planning/investigation-{timestamp}.md`:

```markdown
# Investigation: {question summary}

**Question**: {$ARGUMENTS}
**Timestamp**: {timestamp}
**Agents Consulted**: impact-analyst, architecture-reviewer, security-officer

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
**Agents Consulted**: 3 (in parallel)

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
2. **SPAWNing THREE research agents IN PARALLEL** (single response)
3. Waiting for ALL results before proceeding
4. Synthesizing findings into unified answer
5. Saving investigation report to `knowzcode/planning/`
6. Presenting findings with implementation options
7. Entering Action Listening Mode for implementation triggers
8. Auto-invoking `/kc:work` when user wants to implement

**PARALLEL is the DEFAULT. NEVER spawn kc-orchestrator.**
