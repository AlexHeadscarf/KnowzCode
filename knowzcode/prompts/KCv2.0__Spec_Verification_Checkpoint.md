# KnowzCode v2.0: Spec Verification Checkpoint

**WorkGroupID for Verification:**
[Orchestrator: Re-state the `WorkGroupID` that requires specification verification.]

> **Automation Path:** Use `/kc-audit audit=spec workgroup_id=<ID>` to run the `arc-auditor` subagent against the draft specs before implementation.

**WorkGroupID:** `[wip-timestamp-to-verify]`

---

## Your Mission
This is a **READ-ONLY** quality gate to ensure all specifications for the given `WorkGroupID` are complete and ready for implementation. You must systematically check every spec file associated with the WorkGroupID against the quality criteria.

**CRITICAL RULE: You MUST NOT modify any files during this check. This is a verification step, not a correction step.**

**Reference:** Your actions are governed by `knowzcode_loop.md`, executing the quality check defined in **Step 3.5**.

---

### Execution Protocol

1.  **Identify Scope:**
    *   Using the `WorkGroupID`, identify all `NodeID`s from `knowzcode_tracker.md` that are part of this verification task.

2.  **Systematic Spec Review:**
    *   For **each** `NodeID` in the scope, read its corresponding `specs/[NodeID].md` file.
    *   Verify the following for each file:
        *   **Existence:** Does the spec file actually exist?
        *   **Completeness:** Are all sections of the spec template filled out? (e.g., no empty "Purpose" or "Core Logic" sections).
        *   **Clarity:** Are the `ARC Verification Criteria` specific, testable, and unambiguous?
        *   **Consistency:** Do the dependencies listed in the spec align with the Change Set?

3.  **Synthesize Findings & Report:**
    *   After reviewing all specs, compile a single report summarizing the overall quality.

### Reporting

*   **On Success:** If all specs are present, complete, and meet quality standards.
    *   **Success Report:**
    > "Specification Verification Checkpoint for `WorkGroupID: [ID]` is complete. All specs are present, complete, and meet quality standards. Ready to proceed to implementation. Awaiting the `KCv2.0__[LOOP_2A]__Implement_Change_Set.md` command."

*   **On Issues Found:** If any specs are missing, incomplete, or have quality issues.
    *   **Issues Report:**
    > "Specification Verification Checkpoint for `WorkGroupID: [ID]` is complete. The following issues were found:
    >
    > *   **Missing Specs:**
    >     *   `[NodeID_X]`
    > *   **Incomplete Specs:**
    >     *   `[NodeID_Y]`: Section '7. ARC Verification Criteria' is empty.
    >     *   `[NodeID_Z]`: Section '4. Core Logic & Processing Steps' contains only placeholder text.
    >
    > Recommendation: Return to `LOOP 1B` to address these specification issues before proceeding with implementation."

### Final State

*   Upon completion of your report, you will **PAUSE**.
*   The Orchestrator will decide whether to proceed to Loop 2A or return to Loop 1B to fix the specs.
---
