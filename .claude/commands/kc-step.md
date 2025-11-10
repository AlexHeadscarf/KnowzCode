---
description: "◆ KnowzCode: Execute a specific KnowzCode v2.0 loop phase with WorkGroup context"
argument-hint: "[phase] [workgroup_id]"
---

# ◆ KnowzCode Phase Execution

Execute a specific phase of the KnowzCode v2.0 loop.

**Arguments**: $ARGUMENTS

## Phase Mapping

- **1A** or "propose" or "impact" → Impact Analysis (Change Set proposal)
- **1B** or "spec" or "draft" → Specification (Spec drafting)
- **2A** or "implement" or "code" → Implementation (Code writing)
- **2B** or "verify" or "audit" → Verification (Implementation audit)
- **3** or "finalize" or "commit" → Finalization (Commit and close)

## Execution

Use the kc-orchestrator sub-agent to execute the specified loop phase

Context:
- Phase: $1 (first argument)
- WorkGroupID: $2 (second argument, if provided)
- Mode: Continue existing WorkGroup or determine from context

Instructions for orchestrator:
1. Parse the phase argument to determine which phase to execute
2. Load the WorkGroup context (if WorkGroupID provided, otherwise find active WorkGroup)
3. Load knowzcode/knowzcode_loop.md for phase requirements
4. Delegate to the appropriate phase-specific sub-agent:
   - 1A → impact-analyst
   - 1B → spec-chief
   - 2A → implementation-lead
   - 2B → arc-auditor
   - 3 → finalization-steward
5. Update tracker and log after phase completes
6. Ensure all todos use "KnowzCode: " prefix in workgroup file

The orchestrator will coordinate with the phase-specific sub-agent and maintain loop state.
