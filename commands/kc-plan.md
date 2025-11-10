---
description: "◆ KnowzCode: Run KCv2.0 planning prompts"
argument-hint: "[plan_type]"
---

# ◆ KnowzCode Planning

Execute strategic planning workflows using KnowzCode v2.0 planning infrastructure.

## Workflow Steps

1. **Validate Environment** - Ensure prerequisites are met
2. **Load Core Context** - Load core KnowzCode documentation
3. **Resolve Plan Type** - Map natural language to planning workflow
4. **Run Planning Strategist** - Delegate to planning-strategist agent
5. **Render Planning Prompt** - Execute plan-specific prompt
6. **Update Caches** - Refresh internal state

## Planning Types

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
/kc-plan strategy
/kc-plan "major feature"
/kc-plan ideas
/kc-plan
```

## Context Files

- knowzcode/automation_manifest.md
- Plan-specific prompt files (resolved dynamically)
