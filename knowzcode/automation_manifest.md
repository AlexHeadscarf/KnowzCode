# KnowzCode Automation Manifest

This manifest describes the Claude Code resources that support the KnowzCode workflow. Each automation lives under the `claude/` directory and is referenced by the KCv2.0 prompt library.

## Slash Commands

| Command | Purpose | Entrypoint Prompt |
| --- | --- | --- |
| `/kc` | Captures the PrimaryGoal, initializes WorkGroup state (feature / bug / refactor aliases), and launches Loop 1A | `claude/commands/kc.yaml` |
| `/kc-step` | Runs a KCv2.0 loop phase (natural aliases like "draft specs" or "verify") after loading the active WorkGroup context | `claude/commands/kc_step.yaml` |
| `/kc-audit` | Launches read-only audit routines (spec, implementation, architecture, security, integration) with friendly aliases | `claude/commands/kc_audit.yaml` |
| `/kc-plan` | Facilitates planning prompts (strategic blueprint, feature ideation, pre-flight analysis, expansion) with alias support | `claude/commands/kc_plan.yaml` |
| `/kc-microfix` | Executes the KCv2.0 micro-fix workflow | `claude/commands/kc_microfix.yaml` |

## Subagents

| Subagent | Description | Key Skills |
| --- | --- | --- |
| `impact-analyst` | Performs impact analysis and proposes Change Sets for KCv2.0 Loop 1A | `load-core-context`, `generate-workgroup-id`, `tracker-scan` |
| `spec-chief` | Drafts and validates specs for all nodes in the active Change Set | `load-core-context`, `spec-template`, `spec-quality-check` |
| `implementation-lead` | Applies Loop 2A playbook using environment-aware commands | `load-core-context`, `environment-guard`, `tracker-update` |
| `arc-auditor` | Executes Loop 2B compliance checks against ARC standards | `load-core-context`, `spec-quality-check`, `log-entry-builder` |
| `finalization-steward` | Finalizes specs, tracker, log, and architecture during Loop 3 | `load-core-context`, `tracker-update`, `log-entry-builder`, `architecture-diff` |
| `spec-quality-auditor` | Performs comprehensive spec validation audits before implementation | `load-core-context`, `spec-validator`, `workgroup-spec-validator` |
| `feature-orchestrator` | Background assistant that seeds planning tasks for new PrimaryGoals | `load-core-context`, `feature-background-orchestrator` |

## Skills

| Skill | Purpose |
| --- | --- |
| `load-core-context` | Loads project overview, architecture, tracker, log header, and current Change Set into memory |
| `generate-workgroup-id` | Produces timestamps that satisfy KnowzCode WorkGroupID conventions |
| `tracker-update` | Applies validated updates to `knowzcode/knowzcode_tracker.md` |
| `spec-template` | Seeds new or updated specs with the KCv2.0 template from `knowzcode/knowzcode_loop.md` |
| `spec-quality-check` | Verifies that specs include purpose, dependencies, interfaces, ARC criteria, and technical debt |
| `log-entry-builder` | Structures entries for `knowzcode/knowzcode_log.md` |
| `architecture-diff` | Highlights differences between specs and the Mermaid flowchart |
| `environment-guard` | Confirms that `knowzcode/environment_context.md` is complete before running commands |
| `tracker-scan` | Extracts current status, WorkGroupID assignments, and unmet specs |
| `alias-resolver` | Converts friendly natural language inputs into canonical KnowzCode values (phases, audits, plans, workgroup types) |
| `workgroup-todo-manager` | Persists KnowzCode-prefixed todo items under `knowzcode/workgroups/<WorkGroupID>.md` |
| `spec-validator` | Validates individual NodeID spec for completeness, ARC criteria quality, and placeholder-free content |
| `workgroup-spec-validator` | Validates all specs in a WorkGroupID with aggregated scores and error reporting |
| `feature-background-orchestrator` | Seeds planning notes for background orchestration of new features |
| `install-knowzcode` | **Installer skill** - Sets up KnowzCode directory structure and initial files |
| `check-installation-status` | **Installation checker** - Detects if KnowzCode is already installed and reports current component counts |
| `validate-installation` | **Post-install validator** - Verifies all components installed correctly |

## State & Backlog Files

The automation toolchain treats the following KnowzCode files as the authoritative state:

- `knowzcode/knowzcode_tracker.md` — backlog and node status board
- `knowzcode/knowzcode_log.md` — operational history and ARC references
- `knowzcode/specs/` — individual NodeID specifications (as-built blueprint)
- `knowzcode/planning/` — auxiliary planning artifacts
- `knowzcode/workgroups/` — persistent todo queues keyed by active WorkGroupID

Automations must read/write these using the skills above so that KnowzCode remains the single source of truth.
