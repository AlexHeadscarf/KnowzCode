# Changelog

All notable changes to KnowzCode will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.15] - 2026-01-16

### Added
- **`start-work` skill** for seamless plan-to-implementation transitions
  - Detects implementation intent phrases: "implement this plan", "do option 1", "go ahead", etc.
  - Auto-extracts context from recent plans, investigations, or active WorkGroups
  - Handles "option N" parsing from investigation findings
  - Guards against questions and already-executing commands
- **Step 4.5: Spec Detection & Context Optimization** in `/kc:work`
  - Scans for existing specs matching the goal before Phase 1A
  - Two-tier matching: pattern-based (always) + semantic (if MCP available)
  - Quality assessment: COMPREHENSIVE / PARTIAL / INCOMPLETE
  - Three workflow paths:
    - **A) Quick Path**: Skip discovery, use existing specs directly
    - **B) Validation Path** (default): Quick verification that specs match codebase
    - **C) Full Workflow**: Complete Phase 1A discovery as before
  - Investigation context pre-loading for reduced redundant discovery

### Changed
- `/kc:work` mandatory execution order now includes Step 4.5
- WorkGroup files now include "Workflow Optimization" section tracking path chosen
- Investigation context can now pre-populate Phase 1A NodeIDs

---

## [2.0.14] - 2026-01-16

### Added
- **Quick agent variants** for investigation workflow
  - `impact-analyst-quick.md` - Max 10 tool calls, haiku model
  - `security-officer-quick.md` - Max 8 tool calls, haiku model
  - `architecture-reviewer-quick.md` - Max 8 tool calls, haiku model
- **Efficiency constraints** added to full agents for `/kc:work` Phase 1A
  - `impact-analyst.md` - Max 20 tool calls, smart historical context scanning
  - `security-officer.md` - Max 15 tool calls, task-scoped OWASP analysis
  - `architecture-reviewer.md` - Max 12 tool calls, focused layer analysis
- **Selective agent spawning** in investigation prompt (1-3 agents based on question type)

### Changed
- Investigation workflow now uses two-tier token targets:
  - `/kc:plan investigate` uses quick agents (~60-90k tokens)
  - `/kc:work` Phase 1A uses full agents with efficiency constraints (~120-150k tokens)
  - `/kc:audit *` uses full agents without constraints (~200-300k tokens)
- Full agents now distinguish between task-scoped analysis and full audit mode
- Historical context scanning is now relevance-based (not time-limited or reading all files)

---

## [2.0.13] - 2026-01-16

### Fixed
- **Git commit contradictions** in finalization phase
  - Pre-Implementation Commit (Step 4.3) now clearly commits `knowzcode/` directory only
  - Final Implementation Commit (Step 10.4) explicitly includes both source code AND knowzcode/ files
  - Added `git add -A` instruction to stage all changes before final commit
  - Resolved ambiguity between "commit all changes" vs "commit knowzcode/ only"

### Changed
- `knowzcode/knowzcode_loop.md` - Clarified two distinct commit points with explicit scopes
- `agents/finalization-steward.md` - Added `git add -A` step before commit in example flow
- `knowzcode/prompts/KCv2.0__[LOOP_3]__Finalize_And_Commit.md` - Updated to mention staging all changes

---

## [2.0.10] - 2026-01-16

### Added
- **Investigation workflow** with parallel research subagents
  - New `/kc:plan investigate "question"` command for codebase investigation
  - New prompt: `KCv2.0__Investigate_Codebase.md`
  - Spawns 3 research agents in parallel: impact-analyst, architecture-reviewer, security-officer
  - Synthesizes findings into actionable recommendations
- **Action Listening Mode** after investigation
  - Detects implementation triggers: "implement", "do it", "fix it", "option 1"
  - Auto-invokes `/kc:work` with investigation findings pre-loaded
  - Skips redundant Phase 1A discovery when context is available
- **Question detection** in `/kc:work`
  - Detects investigation questions (starts with "is", "how", "why", contains "?")
  - Suggests `/kc:plan investigate` for efficient parallel research
  - Supports `--from-investigation` flag for context loading

### Changed
- `/kc:plan` command now supports "investigate" as a planning type
- `/kc:work` includes input classification pre-check before orchestration
- Documentation updated with investigation workflow in README.md and CLAUDE.md

### Notes
- Investigation findings saved to `knowzcode/planning/investigation-{timestamp}.md`
- Seamless handoff from research to implementation via action triggers
- Questions no longer consume primary context - research happens in subagents

---

## [2.0.9] - 2026-01-16

### Added
- Parallel Execution Philosophy section in `docs/workflow-reference.md`
- Detailed parallel spawning patterns and decision flowchart
- Error handling guidance for partial parallel failures

### Changed
- **PARALLEL is now the DEFAULT, SEQUENTIAL is the EXCEPTION**
- Phase 1A: Now spawns impact-analyst, security-officer, architecture-reviewer in parallel
- Phase 1B: Multi-NodeID specs now drafted in parallel (one agent per NodeID)
- Phase 2B: Audit battery now runs arc-auditor, spec-quality-auditor, security-officer in parallel
- `/kc:audit` without arguments now runs all 4 audits in parallel by default
- Added "Parallel-First Execution" to core principles in knowzcode_loop.md
- Consolidated audit results presentation with merged scores and findings

---

## [2.0.8] - 2026-01-16

### Added
- NodeID granularity rules section in impact-analyst agent
- Pre-spec verification checklist in spec-chief agent
- Change Set format example in knowzcode_loop.md

### Changed
- Clarified NodeID creation: only for NEW capabilities, not every file touched
- Files that integrate/use a capability are now "affected files" (no NodeIDs needed)
- Reduced spec proliferation by distinguishing capabilities from integration work

## [2.0.7] - 2025-01-15

### Changed
- Complete rewrite of orchestration architecture - commands now ARE the orchestrator
- `commands/work.md` - embeds full workflow loop with direct phase agent spawning
- `commands/step.md` - single-phase execution with direct agent delegation
- `commands/continue.md` - state recovery with inline orchestration
- `commands/audit.md` - direct delegation to audit agents

### Fixed
- **Critical**: KnowzCode now properly delegates to subagents
  - Root cause: Claude Code filters out agents with `Task` tool to prevent recursion
  - kc-orchestrator was never available as a spawnable agent
  - Commands were executing orchestrator logic inline, causing context bloat
- **Spec Conceptual Model**: NodeIDs now must be domain concepts, not tasks
  - Specs are permanent documentation, not work items
  - Two valid spec types: Component Specs (`UI_`, `API_`, `SVC_`, etc.) and Use Case Specs (`UC_`)
  - Invalid patterns (`FIX-001`, `TASK-X`, `UI-FIX-002`) now explicitly prohibited
  - Historical context check added - scan completed WorkGroups before proposing Change Sets
  - Updated files: `agents/impact-analyst.md`, `agents/spec-chief.md`, `knowzcode/knowzcode_loop.md`

### Removed
- `kc-orchestrator` removed from agents array in marketplace.json
- Moved `agents/kc-orchestrator.md` to `docs/workflow-reference.md` as documentation

### Notes
- Anti-recursion guards added to all commands
- Context loaded ONCE at workflow start, maintained throughout
- Phase agents work in isolated contexts, return results to calling command

---

## [2.0.6] - 2025-12-29

### Changed
- All 32 agents now use `model: opus` instead of `model: sonnet`
- Opus 4.5 offers better quality (80.9% vs 77.2% on SWE-bench)
- With prompt caching, Opus 4.5 is cost-comparable or cheaper than Sonnet (90% cache read savings)

### Notes
- This change affects all agents in both `.claude/agents/` and `agents/` directories
- No breaking changes - agents work identically, just with higher quality model

---

## [2.0.5] - 2025-01-XX

### Added
- Automatic `.gitignore` creation in `knowzcode/` directory for environment protection
- Interactive user preferences capture during `/kc:init` with optional configuration
- Enhanced test verification guidance in implementation-lead agent with:
  - Test infrastructure requirements checking
  - Integration test patterns and examples
  - E2E test patterns with Playwright examples
  - Task breakdown guidance for verification loops
- Test framework detection in environment_context.md template
- User preferences integration in environment_context.md template
- `knowzcode/user_preferences.md` template for capturing development preferences
- Helpful error messages when test infrastructure is missing (e.g., Playwright)

### Changed
- Init command now includes interactive prompt for user preferences (optional, can skip)
- Init command creates `.gitignore` automatically to prevent accidental env commits
- Environment context template includes test framework detection in discovery sequence
- Success message updated to reflect new files created during initialization

### Fixed
- None

### For Existing Projects
Run `/kc:init` and choose "Merge" option to add new features without affecting existing files.
This will:
- Add `knowzcode/.gitignore` (if missing)
- Prompt for user preferences (optional)
- Update to latest templates

### Breaking Changes
None - all changes are additive and backward compatible.

### Notes
- Version detection system and proactive upgrade prompts planned for v2.1.0
- Template files in existing projects won't auto-upgrade; use merge mode to opt-in
- Agents gracefully handle missing new features for backward compatibility

---

## [2.0.4] - 2024-12-XX

### Fixed
- Added explicit commands/agents arrays to marketplace.json for proper registration

---

## [2.0.3] - 2024-12-XX

### Fixed
- Changed plugin name from 'knowzcode' to 'kc' for namespace to work correctly

---

## [2.0.2] - 2024-12-XX

### Changed
- Renamed command namespace from `/knowzcode:*` to `/kc:*` for better UX
- All 27 files updated with 221 occurrences
- Commands now use shorter format: `/kc:work`, `/kc:init`, `/kc:step`, etc.

---

## [2.0.1] - 2024-12-XX

### Fixed
- Enforced orchestration and verification loops in workflow

---

## [2.0.0] - 2024-12-XX

### Added
- Initial release as Claude Code marketplace plugin
- Hybrid plugin architecture with global commands/agents
- Visible `knowzcode/` project directory structure
- All core workflow commands: work, init, step, audit, plan, fix, resolve-conflicts
- Multi-agent orchestration system
- TDD-enforced implementation workflow
- Quality gates and verification loops
- Living documentation system
- MCP server integration support

---

[2.0.15]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.14...v2.0.15
[2.0.14]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.13...v2.0.14
[2.0.13]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.10...v2.0.13
[2.0.10]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.9...v2.0.10
[2.0.9]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.8...v2.0.9
[2.0.8]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.7...v2.0.8
[2.0.7]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.6...v2.0.7
[2.0.6]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.5...v2.0.6
[2.0.5]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.4...v2.0.5
[2.0.4]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.3...v2.0.4
[2.0.3]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.2...v2.0.3
[2.0.2]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/AlexHeadscarf/KnowzCode/releases/tag/v2.0.0
