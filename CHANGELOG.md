# Changelog

All notable changes to KnowzCode will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.24] - 2026-01-28

### Added
- **Auto-vault configuration** after `/kc:register`
  - Registration API now returns `vault_id` (auto-created "KnowzCode" vault)
  - `/kc:register` automatically populates `knowzcode/mcp_config.md` with vault ID
  - Users immediately ready to use `/kc:learn` without manual configuration
- **Single vault model** for new users
  - Research Vault (Primary): Learnings, conventions, decisions, patterns
  - Code Vault (Optional): For large codebases (50k+ LOC)
  - Code search uses local grep/glob by default (works well for most projects)
- **`--configure-vaults` flag** for `/kc:connect-mcp`
  - Forces vault configuration prompts even if already configured
  - Useful for reconfiguring or adding code vault later

### Changed
- **`/kc:register`** now parses `vault_id` from API response and auto-configures
  - Success message includes vault configuration status
  - Suggests `/kc:learn` as next step
- **`/kc:connect-mcp`** skips vault prompts if already configured from registration
  - Detects existing Research Vault configuration
  - Shows current vault status and suggests `--configure-vaults` to reconfigure
- **`knowzcode/mcp_config.md`** template updated
  - Research Vault marked as "Primary"
  - Code Vault marked as "Optional" with guidance
  - Added "Single Vault Model" section explaining the approach
- **`knowz-mcp-quick`** agent updated for single vault model
  - Code search operations return grep/glob guidance when code vault not configured
  - Research vault operations require vault configuration
  - Pattern search tries research vault first, then code vault if available
- **`/kc:learn`** improved error messages
  - Clear guidance to run `/kc:register` for vault setup
  - Distinguishes between "MCP not connected" and "vault not configured"

### Fixed
- Dead end after registration where users had API key but no vault configured
- Unclear error messages when trying to use `/kc:learn` without vault setup

---

## [2.0.23] - 2026-01-28

### Added
- **`knowz-mcp-quick` subagent** for MCP context isolation
  - Handles ALL MCP interactions in isolated context
  - Returns summarized results only (max 500 tokens)
  - Uses `haiku` model for speed and efficiency
  - Supported operations: code search, research query, deep research, convention lookup, pattern search, create learning, check duplicate
  - Keeps raw MCP responses (8000+ tokens) out of main agent context

### Changed
- **`impact-analyst`** now delegates MCP queries to `knowz-mcp-quick` subagent
  - Replaced direct MCP tool instructions with subagent delegation pattern
  - Maintains fallback mode for when MCP unavailable
- **`spec-chief`** now delegates MCP queries to `knowz-mcp-quick` subagent
  - Uses subagent for implementation examples and convention lookups
- **`implementation-lead`** now delegates MCP queries to `knowz-mcp-quick` subagent
  - Pattern discovery flow updated to use subagent
- **`architecture-reviewer`** now delegates MCP queries to `knowz-mcp-quick` subagent
  - Architecture compliance checks via isolated subagent
- **`finalization-steward`** now uses subagent for learning capture
  - Duplicate checking via `Task(knowz-mcp-quick, "Check duplicate: ...")`
  - Learning creation via `Task(knowz-mcp-quick, "Create learning: ...")`

### Fixed
- Main agent context no longer polluted by 8000+ token MCP responses
- Agents work with concise summaries instead of raw MCP data
- Better context conservation across multi-phase workflows

---

## [2.0.21] - 2026-01-28

### Added
- **`/kc:register` command** for guided account registration and MCP configuration
  - Collects name, email, password interactively
  - Calls `POST /api/v1/auth/register` endpoint
  - Automatically configures MCP server with generated API key
  - Supports `--scope` flag (local, project, user)
  - Supports `--dev` flag to use development environment
  - Security: passwords transmitted via HTTPS, never stored locally
  - Handles all error cases: email exists, validation errors, rate limiting

### Changed
- **Production endpoints now default** for both `/kc:register` and `/kc:connect-mcp`
  - Production: `https://api.knowz.io` (default)
  - Development: `https://api.dev.knowz.io` (use `--dev` flag)
- **`/kc:connect-mcp`** updated with `--dev` flag for development environment
  - Default endpoint changed from dev to production
  - Use `--dev` flag explicitly for development/testing
- **`/kc:init`** now suggests `/kc:register` alongside `/kc:connect-mcp` for new users
- **`/kc:status`** "not configured" message now includes `/kc:register` option
- **CLAUDE.md** command table updated with `/kc:register`

---

## [2.0.20] - 2026-01-26

### Added
- **Shell script installers** as fallback when Claude Code marketplace isn't working
  - `install.sh` for Linux/macOS (Bash)
  - `install.ps1` for Windows (PowerShell)
  - Options: `--target`, `--global`, `--force`, `--help`
  - Installs commands, agents, and framework files
  - Initializes fresh tracker and log with timestamp
- **Alternative installation section** in README
  - Documents manual installation via shell scripts
  - Provides command reference table

### Changed
- **README simplified** to plugin-focused format
  - Cleaner structure with badges and navigation
  - Emphasizes marketplace installation as primary method
  - Shell scripts as documented fallback option

---

## [2.0.19] - 2026-01-16

### Added
- **Sentry MCP support** as fallback when CLI is not available
  - Detection priority: CLI (preferred) → MCP (fallback)
  - Auto-detects MCP tools: `sentry_search_issues`, `mcp__sentry__*` variants
  - Only asks user to install if BOTH CLI and MCP are unavailable
- **Method field** in telemetry configuration (`cli` or `mcp`)
  - Stored in `knowzcode/telemetry_config.md` Sentry section
  - Passed through telemetry-investigator to sentry-investigator-quick
- **MCP tools in sentry-investigator-quick** agent header
  - Supports both `mcp__sentry__*` and `sentry_*` tool name patterns
  - Agent uses whichever method is configured

### Changed
- **`/kc:telemetry-setup`** now checks for MCP when CLI unavailable
  - Step 1 restructured: CLI check → MCP fallback check → ask user
  - Presents both CLI and MCP installation options if neither available
- **`sentry-investigator-quick`** Query Methods section restructured
  - Method: CLI section (when `Method: cli` in config)
  - Method: MCP section (when `Method: mcp` in config)
  - Fallback: API section (if neither work)
- **Configuration examples** now include Method field

---

## [2.0.18] - 2026-01-16

### Added
- **`/kc:telemetry` command** for investigating production telemetry across multiple sources
  - Query Sentry, Azure App Insights, and other telemetry sources
  - **Natural language parsing** - describe everything in plain English
  - Auto-extracts environment, timeframe, and search terms from description
  - Examples:
    - `/kc:telemetry "in staging in the last 20 min, error 500"`
    - `/kc:telemetry "NullReferenceException in production over the past hour"`
    - `/kc:telemetry "checkout failures in dev since this morning"`
- **`/kc:telemetry-setup` command** for guided telemetry configuration
  - Detects installed telemetry tools (sentry-cli, az CLI)
  - Verifies authentication status for each tool
  - Auto-discovers available Sentry projects and App Insights resources
  - Interactive environment mapping (production, staging, dev)
  - Persists configuration to `knowzcode/telemetry_config.md`
- **`knowzcode/telemetry_config.md`** configuration file template
  - Stores environment-to-resource mappings for Sentry and App Insights
  - Team-shareable (git-committable) telemetry configuration
  - Supports organization, project, subscription, and App ID settings
- **`telemetry-investigator` parent agent** that orchestrates parallel telemetry investigation
  - **Phase 0: NLP extraction** - parses environment, timeframe, search query from natural language
  - **Phase 0.5: Configuration resolution** - maps environment to specific project/App ID
  - Spawns source-specific subagents in parallel (single response)
  - Passes resolved resource IDs (not placeholders) to subagents
  - Synthesizes findings into unified timeline
  - Generates root cause hypothesis with confidence levels
  - Callable by other agents (e.g., implementation-lead during debugging)
- **`sentry-investigator-quick` agent** for focused Sentry error investigation
  - Max 8 tool calls, haiku model
  - Returns: errors, stack traces, breadcrumbs, affected users
  - Supports Sentry CLI, MCP, and API methods
  - Uses configured organization and project from entry context
- **`appinsights-investigator-quick` agent** for Azure App Insights investigation
  - Max 10 tool calls, haiku model
  - Returns: exceptions, failed requests, failed dependencies
  - Supports Azure CLI with KQL queries
  - Uses configured App ID from entry context

### Changed
- **`/kc:telemetry` command** enhanced with configuration loading
  - Loads `knowzcode/telemetry_config.md` before investigation
  - Verifies tool authentication (not just installation)
  - Passes environment→resource mappings to telemetry-investigator
  - Reports helpful setup instructions if not configured
- **Subagents use resolved IDs** instead of placeholders
  - Sentry queries use actual `org/project` from config
  - App Insights queries use actual `app-id` from config
  - Error handling includes configuration troubleshooting guidance

### Integration
- Other agents can spawn `telemetry-investigator` for debugging support
- Results link to `/kc:fix` or `/kc:work` for remediation

---

## [2.0.17] - 2026-01-16

### Added
- **Descriptive WorkGroup IDs** with meaningful slugs extracted from goal
  - New format: `kc-{type}-{slug}-YYYYMMDD-HHMMSS`
  - Example: `kc-feat-user-auth-jwt-20250115-143022` instead of `kc-feat-20250115-143022`
  - Slug extraction removes common words and takes 2-4 key descriptive terms
  - Makes WorkGroup files easier to identify and scan

### Fixed
- **Skills not auto-triggering** - added missing `skills` array to `marketplace.json`
  - `start-work` skill: triggers on "implement this plan", "go ahead", "let's implement", etc.
  - `continue` skill: triggers on "continue", "keep going", "resume", "carry on", etc.
  - Root cause: skill files existed but were never registered with the plugin system

---

## [2.0.16] - 2026-01-16

### Added
- **`/kc:migrate-knowledge` command** for importing external knowledge into KnowzCode specs
  - Supports multiple input types: file paths, folder paths, glob patterns, direct text
  - Format auto-detection: KnowzCode v1.x, Noderr output, generic markdown analysis
  - Entity extraction with NodeID inference (UI_, API_, SVC_, DB_, LIB_, CONFIG_, UC_)
  - Consolidation with existing specs (skip/merge/overwrite strategies)
  - Options: `--format`, `--dry-run`, `--merge`, `--overwrite`
  - Migration reports saved to `knowzcode/planning/`
- **`knowledge-migrator` agent** for format detection, extraction, and consolidation
- **`KCv2.0__Migrate_Knowledge.md` prompt** with detailed extraction rules
- **`CLAUDE.local.md`** (gitignored) for local release/versioning instructions

### Changed
- `.gitignore` updated to exclude `CLAUDE.local.md`

---

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

[2.0.24]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.23...v2.0.24
[2.0.23]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.22...v2.0.23
[2.0.22]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.21...v2.0.22
[2.0.21]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.20...v2.0.21
[2.0.20]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.19...v2.0.20
[2.0.19]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.18...v2.0.19
[2.0.18]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.17...v2.0.18
[2.0.17]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.16...v2.0.17
[2.0.16]: https://github.com/AlexHeadscarf/KnowzCode/compare/v2.0.15...v2.0.16
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
