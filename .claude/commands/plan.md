---
description: "Research and investigate before implementing"
argument-hint: "<topic or question>"
---

# KnowzCode Plan

Research a topic, feature, or question using parallel investigation agents before committing to implementation.

**Usage**: `/kc:plan <topic or question>`

**Examples**:
```
/kc:plan "is the API using proper error handling?"
/kc:plan "add user authentication with JWT"
/kc:plan "refactor the database layer"
/kc:plan "how does caching work in this codebase?"
```

---

## What This Command Does

1. **Spawns 3 parallel research agents** (all run simultaneously):
   - `impact-analyst-quick` - Code exploration and evidence gathering
   - `architecture-reviewer-quick` - Pattern and design assessment
   - `security-officer-quick` - Security and performance implications

2. **Checks existing knowledge**:
   - Scans `knowzcode/specs/` for relevant specifications
   - Checks `knowzcode/workgroups/` for prior related work
   - Reviews `knowzcode/knowzcode_tracker.md` for historical context

3. **Synthesizes findings** into actionable options

4. **Listens for implementation intent**:
   - Say "implement", "do it", "option 1", etc. to transition to `/kc:work`
   - Investigation context is preserved and passed to implementation

---

## Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                      /kc:plan "<topic>"                      │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│              PHASE 1: Parallel Investigation                 │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │impact-analyst│  │architecture-│  │security-    │         │
│  │-quick       │  │reviewer-quick│  │officer-quick│         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
│         │                │                │                 │
│         └────────────────┼────────────────┘                 │
│                          ▼                                  │
│              Findings collected in parallel                 │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              PHASE 2: Knowledge Check                        │
│                                                             │
│  • Scan knowzcode/specs/ for relevant specs                 │
│  • Check knowzcode/workgroups/ for prior work               │
│  • Review tracker for historical context                    │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              PHASE 3: Synthesis & Options                    │
│                                                             │
│  Present:                                                   │
│  • Synthesized findings from all 3 agents                   │
│  • Relevant existing specs/WorkGroups                       │
│  • Recommended approaches (options)                         │
│  • Risks and considerations                                 │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              PHASE 4: Action Listening                       │
│                                                             │
│  User says "implement" or "option N"                        │
│         │                                                   │
│         ▼                                                   │
│  Auto-invoke /kc:work with investigation context            │
└─────────────────────────────────────────────────────────────┘
```

---

## Execution Instructions

When this command is invoked, execute the following steps:

### Step 1: Validate Input

```
IF no argument provided:
  ASK: "What would you like me to research? (feature, question, or topic)"
  WAIT for response
```

### Step 2: Check KnowzCode Initialization

```
IF knowzcode/ directory does not exist:
  INFORM: "KnowzCode not initialized. Run /kc:init first."
  STOP
```

### Step 3: Launch Parallel Investigation

**CRITICAL: Launch all 3 agents IN PARALLEL using a single message with multiple Task tool calls.**

```
PARALLEL {
  Task(impact-analyst-quick, "Investigate: {user_topic}")
  Task(architecture-reviewer-quick, "Investigate: {user_topic}")
  Task(security-officer-quick, "Investigate: {user_topic}")
}
```

### Step 4: Check Existing Knowledge (while agents run)

```
PARALLEL with Step 3 {
  Glob("knowzcode/specs/*.md") → scan for relevant specs
  Read("knowzcode/knowzcode_tracker.md") → check for related WorkGroups
  Glob("knowzcode/workgroups/*.md") → scan for prior related work
}
```

### Step 5: Synthesize Findings

Once all agents return, synthesize into a structured response:

```markdown
## Investigation: {topic}

### Code Analysis (impact-analyst-quick)
{summarized findings}

### Architecture Assessment (architecture-reviewer-quick)
{summarized findings}

### Security/Performance (security-officer-quick)
{summarized findings}

### Existing Knowledge
- **Relevant Specs**: {list or "None found"}
- **Prior WorkGroups**: {list or "None found"}

### Recommended Approaches

**Option 1**: {approach description}
- Pros: ...
- Cons: ...

**Option 2**: {approach description}
- Pros: ...
- Cons: ...

### Risks & Considerations
{synthesized risks from all agents}

---

**Ready to implement?** Say "implement", "do option 1", or "go ahead" to start `/kc:work` with this context.
```

### Step 6: Listen for Implementation Intent

After presenting findings, watch for implementation triggers:
- "implement" / "implement this" / "let's implement"
- "do it" / "go ahead" / "proceed"
- "option 1" / "option 2" / "do option N"
- "start work" / "begin" / "build this"

When triggered:
```
INVOKE /kc:work "{original_topic}"
PASS context: investigation findings, selected option (if specified)
```

---

## Output Format

The command should produce a clean, scannable output that:
1. Clearly separates findings from each research domain
2. Highlights existing relevant knowledge
3. Presents actionable options
4. Makes the path to implementation obvious

---

## Notes

- All 3 research agents use the `haiku` model for speed
- Agents have strict scope constraints (max 8-10 tool calls each)
- Investigation context is preserved when transitioning to `/kc:work`
- This command replaces the old planning types (strategy, ideas, pre-flight, etc.)
