# KnowzCode Prompts Guide

Welcome to the command center for KnowzCode. This guide is your quick reference for all the prompts you'll use to orchestrate the AI agent.

---

> Before running the loop prompts, you can now launch the automation with `/kc` to capture the PrimaryGoal, initialize the WorkGroup todo log, and automatically enter Loop 1A.

## The Core Development Loop

This verification-driven sequence is the heart of KnowzCode. You use these prompts in order for every new feature or significant fix. The process starts after you provide a `PrimaryGoal` in a work session.

| Step | Loop Prompt | What It Does | Your Action |
| :--: | :--- | :--- | :--- |
| **1A** | `knowzcode/prompts/KCv2.0__[LOOP_1A]__Propose_Change_Set.md` | Agent analyzes impact and proposes a "Change Set" of all affected nodes. | **Approve the scope.** |
| **1B** | `knowzcode/prompts/KCv2.0__[LOOP_1B]__Draft_Specs.md` | Agent drafts all required specifications for the Change Set. | **Review the specs.** |
| **Gate**| `knowzcode/prompts/KCv2.0__Spec_Verification_Checkpoint.md`| **(Optional)** A read-only check to verify spec completeness before coding. | **Run for large Change Sets.** |
| **2A** | `knowzcode/prompts/KCv2.0__[LOOP_2A]__Implement_Change_Set.md` | Agent writes code for the Change Set and runs initial verification. | **Authorize implementation.** |
| **Gate**| `knowzcode/prompts/KCv2.0__[LOOP_2B]__Verify_Implementation.md`| A **mandatory** read-only audit that compares code to specs and reports a completion %. | **Review audit & decide.** |
| **3** | `knowzcode/prompts/KCv2.0__[LOOP_3]__Finalize_And_Commit.md` | Agent updates docs to "as-built," logs work, and commits to the repository. | **Authorize finalization.** |

> **Note**: The `[LOOP_X]` notation indicates the step number in the development cycle.

---

## Workflow & Maintenance Prompts

These are the commands you'll use to manage the project's lifecycle.

### Initial Setup
| Prompt | Purpose | When to Use |
|:-------|:--------|:------------|
| `knowzcode/prompts/KCv2.0__Strategic_Blueprint_Designer.md` | Create strategic foundation | Before building, to establish rich context |
| `knowzcode/prompts/KCv2.0__Install_And_Reconcile.md` | Install KnowzCode after initial build | Once, after extracting ZIP |
| `knowzcode/prompts/KCv2.0__Post_Installation_Audit.md` | Verify system integrity and complete architecture | Immediately after Install_And_Reconcile |

### Daily Operations

| Category | Prompt | When to Use |
| :--- | :--- | :--- |
| **Setup** | `knowzcode/prompts/KCv2.0__Install_And_Reconcile.md` | Once, after initial build and ZIP extraction |
| **Session** | `knowzcode/prompts/KCv2.0__Start_Work_Session.md` | At the beginning of every work session to sync the agent. |
| **Session** | `knowzcode/prompts/KCv2.0__Resume_Active_Loop.md` | If a work session was interrupted, to reconstruct context and resume. |
| **Quality** | `knowzcode/prompts/KCv2.0__Spec_Verification_Checkpoint.md`| Before Loop 2A, to verify specs for large (10+ node) Change Sets. |
| **Quick Fix** | `knowzcode/prompts/KCv2.0__Execute_Micro_Fix.md` | For tiny, localized fixes (< 50 lines) that don't require the full loop. |
| **Bugs** | `knowzcode/prompts/KCv2.0__Handle_Critical_Issue.md` | When something is broken. Guides a formal triage and diagnosis process. |
| **Tech Debt**| `knowzcode/prompts/KCv2.0__Refactor_Node.md` | To execute a `REFACTOR_` task from the tracker and improve code quality. |

---

## Strategic Planning & Expansion Prompts

Use these high-level prompts to manage the project's long-term roadmap and health.

| Category | Prompt | When to Use |
| :--- | :--- | :--- |
| **Blueprint** | `knowzcode/prompts/KCv2.0__Strategic_Blueprint_Designer.md` | To create rich strategic context before project setup |
| **Ideation** | `knowzcode/prompts/KCv2.0__Feature_Idea_Breakdown.md` | To turn a raw list of ideas into a prioritized, structured plan. |
| **Planning** | `knowzcode/prompts/KCv2.0__Pre_Flight_Feature_Analysis.md`| To perform a detailed analysis of a single feature *before* starting the loop. |
| **Expansion**| `knowzcode/prompts/KCv2.0__Major_Mid_Project_Feature_Addition.md`| To add a major new feature to a project that is already in progress. |
| **Versioning**| `knowzcode/prompts/KCv2.0__Expand_Completed_Project.md`| To plan the next version (e.g., v1.1) after the project reaches 100% completion. |

---

## Quality Assurance & Auditing Prompts

These prompts are for setting up and verifying projects, or for performing deep quality checks.

| Category | Prompt | When to Use |
| :--- | :--- | :--- |
| **Onboarding**| `knowzcode/prompts/KCv2.0__Retrofit_Existing_Project.md` | To apply KnowzCode to a pre-existing codebase. |
| **Validation**| `knowzcode/prompts/KCv2.0__Onboarding_Audit_Verification.md` | To perform a quality check after a `Retrofit` operation. |
| **Security** | `knowzcode/prompts/KCv2.0__Advanced_Security_Audit.md` | To conduct a comprehensive security audit based on OWASP standards. |
| **Quality** | `knowzcode/prompts/KCv2.0__Architecture_Health_Review.md` | To conduct a periodic, deep audit of the entire project's health. |
| **Deep Dive** | `knowzcode/prompts/KCv2.0__Holistic_Integration_Audit.md` | To perform a detailed quality and integration check on a single completed feature. |

---

## Quick Decision Tree

*   **Starting a new project?** → `knowzcode/prompts/Strategic_Blueprint_Designer` → Create project files → Build → Install
*   **Just built initial prototype?** → Extract ZIP → `knowzcode/prompts/Install_And_Reconcile`
*   **Starting your work day?** → `knowzcode/prompts/Start_Work_Session`
*   **Resuming interrupted work?** → `knowzcode/prompts/KCv2.0__Resume_Active_Loop.md`
*   **Large Change Set (10+ NodeIDs)?** → Run `Spec_Verification_Checkpoint` after Loop 1B.
*   **Finished with Loop 2A?** → Always run `[LOOP_2B]__Verify_Implementation` audit.
*   **Have a new feature idea?** → `knowzcode/prompts/Pre_Flight_Feature_Analysis` → (then start the loop).
*   **Found a small typo?** → `knowzcode/prompts/Execute_Micro_Fix`
*   **Something is broken?** → `knowzcode/prompts/Handle_Critical_Issue`
*   **Want to improve existing code?** → `knowzcode/prompts/Refactor_Node`
*   **Time for a security check?** → `knowzcode/prompts/Advanced_Security_Audit`

---

## Best Practices

1. **Always start with** `knowzcode/prompts/KCv2.0__Start_Work_Session.md` - it syncs the AI with your project state
2. **The 4-step loop must be followed completely** - don't skip steps, they ensure quality at each phase
3. **Use planning prompts** before diving into code - they save time by thinking through complexity upfront
4. **Regular audits** (Architecture Health, Security) prevent technical debt accumulation
5. **Maintain the WorkGroup todo file** (`knowzcode/workgroups/<WorkGroupID>.md`) and prefix every entry with `KnowzCode:` so automation keeps tasks on-screen
