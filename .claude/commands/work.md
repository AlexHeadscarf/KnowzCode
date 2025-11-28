---
description: "Start a new KnowzCode development workflow with TDD, quality gates, and multi-agent orchestration"
argument-hint: "[feature_description]"
---

# Work on New Feature

Start a new KnowzCode development workflow session.

**Usage**: `/kc:work "feature description"`
**Example**: `/kc:work "Build user authentication with JWT"`

**Primary Goal**: $ARGUMENTS

## Execution

Use the kc-orchestrator sub-agent to initialize and coordinate a new KnowzCode workflow session

Context:
- Primary Goal: $ARGUMENTS
- Mode: New WorkGroup initialization
- Expected Flow: Initialize → Phase 1A → Phase 1B → Phase 2A → Phase 2B → Phase 3

Instructions for orchestrator:
1. Load KnowzCode context from knowzcode/*.md files
2. Generate a new WorkGroupID (format: kc-feat-YYYYMMDD-HHMMSS)
3. Create workgroup file at knowzcode/workgroups/{WorkGroupID}.md
4. Begin with Phase 1A (Impact Analysis)
5. Proceed through phases with user approval at each gate
6. Ensure all todos in workgroup file use "KnowzCode: " prefix

The orchestrator will coordinate with phase-specific sub-agents and maintain loop state throughout the workflow.
