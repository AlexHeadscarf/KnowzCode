---
description: "Run KCv2.0 planning prompts"
argument-hint: "[plan_type]"
---

# KnowzCode Planning

Execute strategic planning workflows using KnowzCode v2.0 planning infrastructure.

**Usage**: `/kc:plan [plan_type]`
**Example**: `/kc:plan strategy` or `/kc:plan "major feature"`

## Workflow Steps

1. **Validate Environment** - Ensure prerequisites are met
2. **Load Core Context** - Load core KnowzCode documentation
3. **Resolve Plan Type** - Map natural language to planning workflow
4. **Execute Planning Workflow**:
   - If `investigate`: Run `KCv2.0__Investigate_Codebase.md` directly (spawns parallel research agents)
   - Otherwise: Delegate to planning-strategist agent, then render plan-specific prompt
5. **Update Caches** - Refresh internal state

### Special Handling: Investigate Type

When `plan_type` is `investigate` (or detected as a question):

1. Skip planning-strategist agent
2. Load and execute `KCv2.0__Investigate_Codebase.md` prompt directly
3. This prompt spawns 3 research agents in PARALLEL:
   - impact-analyst (code exploration)
   - architecture-reviewer (pattern analysis)
   - security-officer (risk assessment)
4. Synthesize results and present findings
5. Enter "Action Listening Mode" for implementation triggers
6. If user says "implement" / "do it" → auto-invoke `/kc:work`

### Question Detection

Auto-detect investigation questions even when `investigate` not explicitly specified:
- Starts with: `is`, `does`, `how`, `why`, `are`, `what`, `can`, `should`
- Contains: `properly`, `correctly`, `using`, `following`, `?`
- If detected → treat as `investigate` type

## Planning Types

- **investigate** - Codebase investigation with parallel research agents (auto-detects questions)
- **strategy** - High-level strategic planning
- **ideas** - Brainstorming and ideation
- **pre-flight** - Pre-implementation validation
- **project overview** - Project-wide analysis
- **major feature** - Large feature planning
- **expansion** - System expansion planning

## Arguments

- `plan_type` (optional): Planning workflow type - accepts values above or natural language description

## Example Usage

```
/kc:plan investigate "is the API using proper error handling?"
/kc:plan investigate "how is authentication implemented?"
/kc:plan "why is the dashboard loading slowly?"    # Auto-detected as investigate
/kc:plan strategy
/kc:plan "major feature"
/kc:plan ideas
```

## Context Files

- knowzcode/automation_manifest.md
- Plan-specific prompt files (resolved dynamically)
