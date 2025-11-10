# KnowzCode v2.0: Expand Completed Project

**New Features for Next Version:**
[Orchestrator: List the new features, capabilities, or major updates for the project's next version, e.g., v1.1 or v2.0.]

> **Automation Path:** Call `/kc-plan plan=expansion` to prime the `planning-strategist` subagent with the verified backlog before outlining the next milestone.

---

## Your Mission
The project has reached 100% completion for its current scope. You are tasked with formally documenting this milestone and then planning the integration of the new features for the project's next version.

**CRITICAL RULE: This prompt is for planning and documentation updates ONLY. You MUST NOT write or modify any application source code. All new implementation will be handled by subsequent, standard KnowzCode loops.**

---

### Phase 1: Document Milestone & Propose Expansion Plan

1.  **Verify Completion:**
    *   Confirm that all nodes in `knowzcode_tracker.md` are marked `[VERIFIED]` and that the progress is at 100%.

2.  **Log Milestone:**
    *   Prepend a `MilestoneAchieved` entry to `knowzcode_log.md`. This formally closes out the previous version. The entry **MUST** use the following format and an environment-sourced timestamp:
        ```markdown
        ---
        **Type:** MilestoneAchieved
        **Timestamp:** [Generated Timestamp]
        **NodeID(s):** Project-Wide
        **Logged By:** AI-Agent
        **Details:**
        - **Milestone:** Project reached 100% completion for its initial scope (v1.0).
        - **Completed Components:** [Total number of NodeIDs].
        - **Recommendation:** This is an ideal point to create a version tag in git, e.g., `git tag v1.0`.
        ---
        ```

3.  **Analyze & Design Expansion:**
    *   Perform a full impact analysis of the new feature requirements.
    *   Decompose the new features into a set of new `NodeID`s.
    *   Design the necessary changes for `knowzcode_architecture.md`, using subgraphs to clearly demarcate the new version's components (e.g., `subgraph "v1.1 Additions"`).

4.  **Propose Expansion Plan for Review:**
    *   Present your complete expansion plan to the Orchestrator. This **MUST** include:
        *   The new Mermaid syntax for the architecture update.
        *   A complete list of all new `NodeID`s to be added.
        *   A dependency-sorted build order for the new nodes.
    *   **PAUSE and await Orchestrator approval of the plan.**

---

### Phase 2: Execute Expansion Plan (After Orchestrator Approval)

*Once the Orchestrator approves your plan, execute the following documentation updates.*

1.  **Update `knowzcode_architecture.md`:**
    *   Integrate the approved Mermaid syntax changes.
2.  **Update `knowzcode_tracker.md`:**
    *   Add a new row for **every new `NodeID`**.
    *   Set the `Status` for all new nodes to `[TODO]`.
    *   Define their `Dependencies` and add a note like "v1.1 Expansion".
3.  **Recalculate and Update Progress:**
    *   Update the `%% Progress: X% %%` line. Acknowledge that this percentage will decrease from 100%.
4.  **Log Expansion Operation:**
    *   Prepend a `ProjectExpansion` entry to `knowzcode_log.md`:
        ```markdown
        ---
        **Type:** ProjectExpansion
        **Timestamp:** [Generated Timestamp]
        **NodeID(s):** [List ALL new NodeIDs added]
        **Logged By:** AI-Agent
        **Details:**
        - **Expansion:** Project scope expanded from v1.0 to v1.1.
        - **Scope Change:** Previous NodeID count: [Old Total]. New nodes added: [New Total - Old Total]. New total nodes: [New Total].
        - **Progress Adjusted:** 100% -> [New %]%.
        - **Implementation Plan:** The recommended build order for the new nodes is: [List the first 3-5 nodes].
        ---
        ```

---

### Final Report & Next Steps

*   Provide a summary of the actions taken.
*   State what the Orchestrator should do next to begin implementation of the new version.

**Example Response:**
> "The project's v1.0 milestone has been formally documented and logged. The expansion plan for v1.1 has been approved and all KnowzCode artifacts have been updated.
> 
> *   `knowzcode_architecture.md` has been updated.
> *   `knowzcode_tracker.md` now includes [X] new `[TODO]` tasks.
> *   Project progress is now [New %]%.
> 
> The project is ready for implementation of v1.1.
> 
> **Recommendation:** To begin, initiate the KnowzCode loop for the first component in the v1.1 implementation plan.
> **Next Command:** Use `KnowzCode v2.0: Start Work Session` and provide the `PrimaryGoal`: "Implement `[First_NodeID_from_v1.1_plan]`"."
