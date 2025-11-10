# ◆ KnowzCode - Status Map

**Purpose:** This document tracks the development status of all implementable components (NodeIDs) defined in `knowzcode_architecture.md`. It guides task selection, groups related work via `WorkGroupID`, and provides a quick overview of project progress. It is updated by the KnowzCode AI Agent as per `knowzcode_loop.md`.

**Note:** All paths are relative to the project root where the knowzcode files reside. The specs/ directory is within your project directory alongside other knowzcode files.

---
**Progress: 0%**
---

| Status | WorkGroupID | Node ID | Label | Dependencies | Logical Grouping | Spec Link | Classification | Notes / Issues |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| ⚪️ `[TODO]` | | `[ExampleNodeID]` | `[Example Node Label]` | `[DepNodeID1]` | `[Example Group]` | `[Spec](knowzcode/specs/ExampleNodeID.md)` | `[Standard]` | |
| | | | | | | | | |
| | | | | | | | | |

---
### ◆ KnowzCode Status Legend:

*   ⚪️ **`[TODO]`**: Task is defined and ready to be picked up if dependencies are met. This status also applies to `REFACTOR_` tasks created from technical debt.
*   📝 **`[NEEDS_SPEC]`**: Node has been identified in the architecture but requires a detailed specification to be drafted.
*   ◆ **`[WIP]`**: ◆ **KnowzCode Working** - Work In Progress. The KnowzCode AI Agent is currently working on this node as part of the specified `WorkGroupID`.
*   🟢 **`[VERIFIED]`**: The primary completion state. The node has been implemented, all ARC Verification Criteria are met, the spec is finalized to "as-built", and all outcomes are logged.
*   ❗ **`[ISSUE]`**: A significant issue or blocker has been identified, preventing progress. Details should be in `knowzcode_log.md` or linked in the "Notes / Issues" column.

---
### Notes on Columns:

*   **Status**: The current state of the NodeID (see Legend above).
*   **WorkGroupID**: A unique ID assigned to a "Change Set" of nodes being worked on together. This is blank unless the `Status` is `[WIP]`.
*   **Node ID**: The unique identifier for the component, matching the ID used in `knowzcode/knowzcode_architecture.md`.
*   **Label**: A concise, human-readable name for the NodeID.
*   **Dependencies**: A comma-separated list of `NodeID`s that must be `[VERIFIED]` before work on this node can begin. Only reference NodeIDs that exist in the architecture diagram. If a dependency's spec doesn't exist, that dependency must be `[NEEDS_SPEC]` status.
*   **Logical Grouping**: An optional tag to categorize nodes by feature, module, or layer (e.g., "Authentication", "UserAPI").
*   **Spec Link**: A relative Markdown link to the corresponding specification file in the `knowzcode/specs/` directory.
*   **Classification**: Optional tag (e.g., `Critical`, `Complex`, `Standard`) to influence planning and review intensity.
*   **Notes / Issues**: Brief comments, or a reference to a more detailed issue in `knowzcode/knowzcode_log.md`.

---
*(This table will be populated based on `knowzcode_architecture.md`. The AI Agent will then update the `Status` and `WorkGroupID` columns as it processes each Change Set according to `knowzcode_loop.md`.)*
