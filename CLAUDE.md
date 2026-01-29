# KnowzCode v2.0 - Claude Code Plugin

## ⚠️ This is a Claude Code Plugin Repository

This repository is the **KnowzCode plugin** for Claude Code. It provides structured AI-powered development workflows with enforced TDD, quality gates, and multi-agent orchestration.

## What is KnowzCode?

KnowzCode is a comprehensive software development workflow framework that provides:

- **Structured TDD Workflow**: Red-Green-Refactor with quality gates
- **Multi-Agent Orchestration**: Specialized agents for different development phases
- **Living Documentation**: Auto-generated architecture, specs, and tracking
- **Quality Automation**: Automated verification, testing, and code review
- **Session Management**: WorkGroup-based feature development tracking

## Installation

### For End Users

Install KnowzCode as a plugin in Claude Code:

```bash
# Add the KnowzCode marketplace
/plugin marketplace add https://github.com/AlexHeadscarf/KnowzCode

# Install the plugin
/plugin install knowzcode

# Initialize in your project
cd my-project/
/kc:init

# Start building
/kc:work "Build user authentication"
```

**That's it!** The plugin provides all commands and agents globally.

## How It Works

### Plugin Architecture (Hybrid Model)

**Plugin (installed globally once):**
```
~/.claude/plugins/knowzcode/
├── commands/          # All /kc:* slash commands
├── agents/            # All specialized sub-agents
└── skills/            # Optional skills
```

**Project (visible directory per-project):**
```
my-project/
└── knowzcode/         # Visible, git-committable
    ├── knowzcode_project.md      # Project metadata
    ├── knowzcode_tracker.md      # WorkGroup tracker
    ├── knowzcode_log.md          # Session history
    ├── knowzcode_architecture.md # Architecture docs
    ├── specs/                    # Specifications
    └── workgroups/               # WorkGroup data
```

**Key Benefits:**
- ✅ No hidden `.claude/` directories in projects
- ✅ Install plugin once, use everywhere
- ✅ Automatic updates via marketplace
- ✅ Visible project data (git-friendly)
- ✅ Clean separation: framework vs. data

## Available Commands

After installing the plugin, you have access to:

| Command | Description |
|:--------|:------------|
| `/kc:init` | Initialize KnowzCode in current project |
| `/kc:register` | Register for KnowzCode and configure MCP automatically |
| `/kc:work <goal>` | Start new feature WorkGroup |
| `/kc:continue` | Resume current WorkGroup with context recovery |
| `/kc:step <phase>` | Execute specific workflow phase |
| `/kc:audit [type]` | Run quality audits |
| `/kc:plan [type]` | Generate development plans |
| `/kc:plan investigate <question>` | Investigate codebase with parallel research agents |
| `/kc:fix <target>` | Quick targeted fixes |
| `/kc:resolve-conflicts` | Resolve merge conflicts |
| `/kc:connect-mcp` | Configure MCP server connection |
| `/kc:status` | Check MCP connection status |
| `/kc:migrate-knowledge` | Import external knowledge into specs |
| `/kc:telemetry` | Investigate production telemetry |
| `/kc:telemetry-setup` | Configure telemetry sources |
| `/kc:learn` | Capture learnings to research vault |

## Project Structure

### What Gets Committed

The `knowzcode/` directory should be **committed to git**:

```gitignore
# Commit these (tracked by git)
knowzcode/*.md
knowzcode/specs/
knowzcode/prompts/
knowzcode/user_preferences.md  # v2.0.5+

# Protected by knowzcode/.gitignore (NOT committed)
knowzcode/environment_context.md  # Local environment details
knowzcode/workgroups/             # Session-specific data
knowzcode/*.local.md              # Personal notes
knowzcode/.scratch/               # Scratch files
```

**v2.0.5+**: A `.gitignore` file is automatically created in `knowzcode/` during initialization to protect environment-specific files from accidental commits.

### What You Edit

- **knowzcode/knowzcode_project.md** - Project goals, tech stack, architecture
- **knowzcode/specs/*.md** - Component specifications
- **knowzcode/prompts/*.md** - Project-specific prompt templates

### What KnowzCode Manages

- **knowzcode/knowzcode_tracker.md** - WorkGroup status tracking
- **knowzcode/knowzcode_log.md** - Session history and logs
- **knowzcode/workgroups/*.md** - Individual WorkGroup data

## Development Workflow

### 1. Initialize Project

```bash
cd my-new-project/
/kc:init
```

This creates the `knowzcode/` directory structure.

### 2. Investigate Before Implementing (Optional)

Have a question about the codebase? Use investigation mode:

```bash
/kc:plan investigate "is the API using proper error handling?"
```

This spawns **3 parallel research agents** to explore your question:
- `impact-analyst` - Code exploration
- `architecture-reviewer` - Pattern analysis
- `security-officer` - Risk assessment

After investigation, say "implement" or "do option 1" to auto-transition to `/kc:work` with findings pre-loaded.

### 3. Start Feature Development

```bash
/kc:work "Build user registration with email verification"
```

This:
1. Creates a new WorkGroup (e.g., `WG-001`)
2. Runs impact analysis (Phase 1A)
3. Generates specifications (Phase 1B)
4. Implements with TDD (Phase 2A)
5. Verifies quality (Phase 2B)
6. Finalizes documentation (Phase 3)

### 4. Work Through Phases

KnowzCode guides you through each phase with quality gates:

- **Phase 1A (Impact Analysis)**: Understand changes needed
- **Phase 1B (Specification)**: Define component specs
- **Phase 2A (Implementation)**: Build with TDD
- **Phase 2B (Verification)**: Quality checks
- **Phase 3 (Finalization)**: Update docs and close WorkGroup

## New in v2.0.24

### Auto-Vault Configuration After Registration

**Problem Solved:**
- After `/kc:register`, users had API key but NO configured vaults
- `mcp_config.md` showed "(not configured)" for vault IDs
- Users couldn't use `/kc:learn` or any vault-dependent features
- Dead end requiring manual `/kc:connect-mcp` and knowing vault IDs

**Solution: Fully automatic vault configuration**
1. Registration API returns a vault ID (auto-created "KnowzCode" vault)
2. `/kc:register` automatically populates `mcp_config.md` with vault ID
3. User is immediately ready to use `/kc:learn` and MCP features

**Single Vault Model (Simplified Onboarding):**
```
┌─────────────────────────────────────────────────────────┐
│                    KnowzCode Vault                       │
│                                                         │
│  Purpose: Learnings, conventions, decisions, patterns   │
│  Used by: /kc:learn, finalization-steward, agents       │
│  Code search: Uses local grep/glob (no code vault)      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Why single vault?**
- Simpler onboarding (no "what's code vault vs research vault?")
- Code search works fine with grep/glob for most projects
- MCP vault is for organizational knowledge, not code indexing
- Advanced users can add code vault later

**New Flow After Registration:**
```bash
/kc:register
# → Creates account, configures MCP, sets vault ID automatically
# → mcp_config.md shows vault configured
# → Ready to use immediately!

/kc:learn "JWT tokens better than sessions for stateless APIs"
# → Works immediately - no manual vault setup needed!
```

**Updated Commands:**
- `/kc:register` - Now parses `vault_id` from API response and auto-configures
- `/kc:connect-mcp --configure-vaults` - New flag to force vault reconfiguration
- `/kc:learn` - Improved error messages with clear setup guidance

## New in v2.0.23

### MCP Subagent for Context Isolation

Introduced dedicated **knowz-mcp-quick** subagent to handle all MCP interactions in isolated context:

**Problem Solved:**
- MCP responses (especially `ask_question` with `researchMode: true`) return 8000+ tokens
- Raw responses were polluting main agent context
- Main conversation context filling up with MCP response data

**Solution:**
- New `knowz-mcp-quick` subagent handles ALL MCP interactions
- Returns **summarized results only** (max 500 tokens)
- Uses `haiku` model for speed and efficiency
- Raw MCP responses stay isolated in subagent context

**Architecture:**
```
┌─────────────────────────────────────────────────────────────────┐
│                    MAIN CONTEXT (Clean)                         │
│                                                                 │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────────────┐   │
│  │ spec-chief  │   │ impl-lead   │   │ impact-analyst      │   │
│  └──────┬──────┘   └──────┬──────┘   └──────────┬──────────┘   │
│         │                 │                      │              │
│         └────────────────┬┴──────────────────────┘              │
│                          │                                      │
│                          ▼                                      │
│              ┌───────────────────────┐                          │
│              │   Task(knowz-mcp-     │  ← Spawn subagent        │
│              │        quick)         │                          │
│              └───────────┬───────────┘                          │
└──────────────────────────┼──────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│                 SUBAGENT CONTEXT (Isolated)                      │
│                                                                  │
│  Process 8000+ tokens → Return 500 token summary                 │
└──────────────────────────────────────────────────────────────────┘
```

**Supported Operations:**
| Operation | Input Pattern | Returns |
|-----------|--------------|---------|
| Code search | `"Search code vault for: {query}"` | File paths + brief context |
| Research query | `"Query research vault: {question}"` | Summarized answer |
| Deep research | `"Research mode: {question}"` | Key insights from 8000+ token response |
| Convention lookup | `"Conventions for: {topic}"` | Bullet list |
| Pattern search | `"Find patterns for: {desc}"` | Similar patterns + snippets |
| Create learning | `"Create learning: {content} \| Title: {title} \| Tags: {tags}"` | Confirmation |
| Check duplicate | `"Check duplicate: {summary}"` | Similar exists? Yes/No |

**Updated Agents:**
- `impact-analyst` - Now delegates MCP queries to subagent
- `spec-chief` - Now delegates MCP queries to subagent
- `implementation-lead` - Now delegates MCP queries to subagent
- `architecture-reviewer` - Now delegates MCP queries to subagent
- `finalization-steward` - Uses subagent for duplicate check + create learning

**Example Usage (in agent):**
```markdown
Task(knowz-mcp-quick, "Search code vault for: authentication middleware")
→ Returns: {"status": "success", "summary": "Found 3 files", "sources": [...]}

Task(knowz-mcp-quick, "Query research vault: What are our error handling conventions?")
→ Returns: {"status": "success", "summary": "1. Always use Result type...", "sources": [...]}
```

**Benefits:**
- Main context stays clean (no 8000+ token pollution)
- Agents work with concise summaries
- MCP queries properly isolated
- Fallback still works when MCP unavailable

## New in v2.0.22

### MCP Vault Architecture & Learning Capture

Dual-vault architecture for enhanced semantic search and organizational learning:

**Dual Vault System:**
- **Code Vault** - Indexed source code (AST-chunked) for semantic code search
- **Research Vault** - Architecture docs, conventions, learnings, best practices

**MCP Tools (11 Active):**

| Tool | Purpose | Key Parameters |
|:-----|:--------|:---------------|
| `search_knowledge` | Vector search across vaults | `query`, `vaultId`, `tags`, `limit` |
| `ask_question` | AI Q&A with research mode | `question`, `vaultId`, `researchMode` |
| `create_knowledge` | Save learnings to vault | `content`, `title`, `tags`, `vaultId` |
| `update_knowledge` | Update existing items | `id`, `content`, `title`, `tags` |
| `get_knowledge_item` | Get item by ID | `id`, `includeRelated` |
| `bulk_get_knowledge_items` | Batch fetch (max 100) | `ids[]` |
| `list_vaults` | List accessible vaults | `includeStats` |
| `list_vault_contents` | Browse vault items | `vaultId`, `tags`, `knowledgeType` |
| `list_topics` | List all topics | `limit` |
| `get_topic_details` | Topic with related items | `id` |
| `find_entities` | Find people/locations/events | `entityType`, `query` |

**New Command:**
- **`/kc:learn "insight"`** - Manually capture learnings to research vault
- Supports `--category` (pattern, decision, workaround, performance, security, convention)
- Supports `--tags` for categorization
- Auto-detects category from insight content

**Agent Enhancements:**
All key agents now support dual-vault queries:
- `impact-analyst` - Code vault for affected code + research vault for past decisions
- `spec-chief` - Code vault for examples + research vault for conventions
- `implementation-lead` - Code vault for patterns + research vault for best practices
- `architecture-reviewer` - Research vault for standards + code vault for precedents
- `finalization-steward` - Auto-detects and captures learnings to research vault

**Automatic Learning Capture:**
During WorkGroup finalization, the system detects insights worth capturing:
- Pattern signals: "created utility for", "new helper", "reusable"
- Decision signals: "chose X over Y", "decided to", "opted for"
- Workaround signals: "workaround", "limitation", "instead"
- Performance/Security signals detected automatically

**New Configuration:**
- `knowzcode/mcp_config.md` - Vault IDs and MCP configuration
- `/kc:connect-mcp` now prompts for vault configuration
- `/kc:status` shows vault connection status

**Example Flow:**
```bash
# Configure MCP with vaults
/kc:connect-mcp kz_live_abc123...
# → Prompts for Code Vault ID and Research Vault ID

# Manual learning capture
/kc:learn "Always use Repository pattern for data access" --category pattern

# Automatic capture during finalization
/kc:work "Add user auth"
# → At Phase 3, system detects "chose JWT over sessions"
# → Prompts to capture as organizational learning
```

## New in v2.0.21

### Registration Command & Production Defaults

**`/kc:register` Command:**
- Guided account registration with interactive name, email, password collection
- Calls `POST /api/v1/auth/register` endpoint
- Automatically configures MCP server with generated API key
- Supports `--scope` flag (local, project, user)
- Supports `--dev` flag for development environment
- Security: passwords transmitted via HTTPS, never stored locally

**Production Defaults:**
- Production endpoints now default for both `/kc:register` and `/kc:connect-mcp`
- Production: `https://api.knowz.io` (default)
- Development: `https://api.dev.knowz.io` (use `--dev` flag)

## New in v2.0.20

### Shell Script Installers

Fallback installation when Claude Code marketplace isn't working:

- `install.sh` for Linux/macOS (Bash)
- `install.ps1` for Windows (PowerShell)
- Options: `--target`, `--global`, `--force`, `--help`
- Installs commands, agents, and framework files

## New in v2.0.19

### Sentry MCP Support

Fallback telemetry when CLI is not available:

- Detection priority: CLI (preferred) → MCP (fallback)
- Auto-detects MCP tools: `sentry_search_issues`, `mcp__sentry__*` variants
- Method field in telemetry configuration (`cli` or `mcp`)
- Only asks user to install if BOTH CLI and MCP are unavailable

## New in v2.0.18

### Telemetry Commands

Production telemetry investigation across multiple sources:

**`/kc:telemetry` Command:**
- Query Sentry, Azure App Insights, and other telemetry sources
- Natural language parsing - describe everything in plain English
- Auto-extracts environment, timeframe, and search terms
- Examples: `/kc:telemetry "in staging in the last 20 min, error 500"`

**`/kc:telemetry-setup` Command:**
- Guided telemetry configuration
- Detects installed tools (sentry-cli, az CLI)
- Verifies authentication status
- Auto-discovers available projects and resources
- Interactive environment mapping (production, staging, dev)

**New Agents:**
- `telemetry-investigator` - Orchestrates parallel telemetry investigation
- `sentry-investigator-quick` - Focused Sentry error investigation
- `appinsights-investigator-quick` - Azure App Insights investigation

## New in v2.0.17

### Descriptive WorkGroup IDs

Meaningful slugs extracted from goal:

- New format: `kc-{type}-{slug}-YYYYMMDD-HHMMSS`
- Example: `kc-feat-user-auth-jwt-20250115-143022`
- Makes WorkGroup files easier to identify and scan

### Skills Registration Fix

- Added missing `skills` array to `marketplace.json`
- `start-work` and `continue` skills now auto-trigger properly

## New in v2.0.16

### Knowledge Migration

**`/kc:migrate-knowledge` Command:**
- Import external knowledge into KnowzCode specs
- Supports file paths, folder paths, glob patterns, direct text
- Format auto-detection: KnowzCode v1.x, Noderr output, generic markdown
- Entity extraction with NodeID inference
- Options: `--format`, `--dry-run`, `--merge`, `--overwrite`

## New in v2.0.15

### Start-Work Skill & Spec Detection

Seamless plan-to-implementation transitions and workflow optimization:

**`start-work` Skill:**
- Detects implementation intent: "implement this plan", "do option 1", "go ahead"
- Auto-extracts context from recent plans, investigations, or active WorkGroups
- Handles "option N" parsing from investigation findings
- Guards against questions and already-executing commands

**Step 4.5: Spec Detection:**
- Scans existing specs before Phase 1A discovery
- Two-tier matching: pattern-based + semantic (if MCP available)
- Quality assessment: COMPREHENSIVE / PARTIAL / INCOMPLETE

**Three Workflow Paths:**
- **A) Quick Path** - Skip discovery, use existing specs directly
- **B) Validation Path** (default) - Quick verification specs match codebase
- **C) Full Workflow** - Complete Phase 1A discovery as before

**Benefits:**
- Plan mode exits naturally flow into `/kc:work`
- Comprehensive specs skip redundant discovery
- Investigation context pre-populates Phase 1A

## New in v2.0.10

### Investigation Workflow with Parallel Research

Added codebase investigation using parallel research subagents:

- **`/kc:plan investigate "question"`** - New command for codebase investigation
- **3 parallel agents** - impact-analyst, architecture-reviewer, security-officer explore simultaneously
- **Action Listening Mode** - Say "implement" or "option 1" to auto-transition to `/kc:work`
- **Context preservation** - Investigation findings pre-load into Phase 1A
- **Question detection** - `/kc:work` suggests investigation for question-like inputs

**Example flow:**
```bash
/kc:plan investigate "is the API using proper error handling?"
# → 3 agents research in parallel
# → Findings presented with options
# → Say "implement option 1"
# → Auto-invokes /kc:work with context loaded
```

**Benefits:**
- Questions no longer consume primary context
- Research happens efficiently in parallel subagents
- Seamless handoff from investigation to implementation

## New in v2.0.11

### Enhanced Parallel Execution Philosophy

Extended "PARALLEL is DEFAULT" philosophy comprehensively across both orchestrator and agent levels:

**Two-Level Parallel Guidance:**
- **Orchestrator level** (commands) - Parallel agent spawning with file conflict analysis
- **Agent level** - Internal parallel operations guidance for each specialized agent

**Phase 2A Parallel Implementation:**
- **File Conflict Analysis** - Detects NodeID pairs that share files
- **Batch Grouping** - Non-conflicting NodeIDs grouped for parallel execution
- **Sequential Fallback** - Complex conflicts handled safely in sequence
- **Example**: 4 NodeIDs with 1 conflict → 3 parallel + 1 sequential = faster than all 4 sequential

**Agent-Specific Parallel Guidance:**
All agents now include standardized parallel execution sections:
- `implementation-lead` - NodeID batching, file analysis parallel; TDD cycle sequential
- `finalization-steward` - Prep phase parallel; final atomic writes sequential
- `spec-chief` - Multi-NodeID drafting parallel; coherence review sequential
- `impact-analyst` - File scanning, dependency tracing parallel; Change Set consolidation sequential
- `arc-auditor` - Per-NodeID verification parallel; final report sequential
- `holistic-auditor` - Integration checks parallel; cross-component analysis sequential
- `security-officer` - Vulnerability scans parallel; risk assessment sequential
- `architecture-reviewer` - Pattern detection parallel; coherence evaluation sequential

**Key Principle:**
- PARALLEL is the DEFAULT for independent operations
- SEQUENTIAL is the EXCEPTION when data dependencies exist
- TDD within NodeIDs remains strictly sequential (RED→GREEN→REFACTOR)

## New in v2.0.7

### Command-as-Orchestrator Architecture

Fixed critical issue where KnowzCode wasn't properly delegating to subagents:

- **Root cause**: Claude Code filters out agents with `Task` tool to prevent recursive spawning
- **Solution**: Commands now ARE the orchestrator - they spawn phase agents directly
- **Result**: Proper context conservation and efficient agent delegation

**Key changes:**
- Commands (`/kc:work`, `/kc:step`, `/kc:continue`, `/kc:audit`) embed orchestration logic
- Phase agents (impact-analyst, spec-chief, etc.) return results to the calling command
- Context loaded ONCE at start, maintained throughout workflow
- Anti-recursion guards prevent spawning kc-orchestrator
- `kc-orchestrator.md` moved to `docs/workflow-reference.md` as documentation

**Benefits:**
- No redundant context loading between phases
- Phase agents work in focused, isolated contexts
- Quality gates enforced by persistent main context
- Workflow completes without context loss

## New in v2.0.6

### Opus 4.5 Model Upgrade

All 32 agents now use Claude Opus 4.5 instead of Sonnet:

- **Better quality**: Opus 4.5 scores 80.9% vs Sonnet's 77.2% on SWE-bench
- **Cost-effective**: With prompt caching (90% savings on cache reads), Opus is comparable or cheaper than Sonnet
- **Simpler config**: No model-switching logic needed - consistent quality across all agents

This change improves output quality for all KnowzCode operations including implementation, specification writing, auditing, and orchestration.

## New in v2.0.5

### Environment Protection

- **Automatic .gitignore**: Prevents accidental commit of environment-specific files
- **Protected files**: `environment_context.md`, `workgroups/`, `*.local.md`
- **Committed files**: Specs, architecture docs, user preferences

### Enhanced Test Verification

- **Test infrastructure detection**: Automatically detects Jest, Playwright, PyTest, etc.
- **Helpful error messages**: Prompts installation when test frameworks are missing
- **Pattern examples**: Integration and E2E test patterns included in implementation-lead agent
- **Task breakdown guidance**: Better tracking of verification loops

### User Preferences

- **Interactive init**: Optional prompts for development preferences during `/kc:init`
- **Preference capture**: Testing frameworks, code style, quality priorities, language patterns
- **Integration**: Preferences work within KnowzCode's mandatory TDD requirements
- **Storage**: `knowzcode/user_preferences.md` (committed to git)

### Upgrading Existing Projects

Run `/kc:init` and choose "Merge" to add v2.0.5 features:

```bash
cd existing-project/
/kc:init

# Choose option: "Merge (add missing files only)"
# This will:
#  - Add knowzcode/.gitignore
#  - Prompt for user preferences (optional)
#  - Preserve all existing files
```

No data loss, fully opt-in!

## For Plugin Developers

### Repository Structure

```
knowzcode/                    # Plugin source
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace definition
├── commands/                # Slash command definitions
│   ├── work.md
│   ├── init.md
│   ├── step.md
│   └── ...
├── agents/                  # Sub-agent definitions
│   ├── kc-orchestrator.md
│   ├── impact-analyst.md
│   ├── implementation-lead.md
│   └── ...
├── skills/                  # Optional skills
├── knowzcode/               # Template files (copied on /kc:init)
│   ├── knowzcode_loop.md
│   ├── prompts/
│   └── specs/
├── docs/                    # Documentation
├── MIGRATION_GUIDE.md       # v1.x → v2.0 migration
└── README.md                # User-facing readme
```

### Development Workflow

1. **Clone this repository**:
   ```bash
   git clone https://github.com/AlexHeadscarf/KnowzCode.git
   cd KnowzCode
   ```

2. **Make changes** to:
   - `commands/*.md` - Slash commands
   - `agents/*.md` - Sub-agents
   - `skills/*.md` - Skills

3. **Test locally**:
   ```bash
   # Create test project
   mkdir test-project && cd test-project

   # Initialize (uses local plugin)
   /kc:init

   # Test commands
   /kc:work "Test feature"
   ```

4. **Update version** in:
   - `.claude-plugin/plugin.json`
   - `.claude-plugin/marketplace.json`

5. **Commit and push**:
   ```bash
   git add .
   git commit -m "feat: add new capability"
   git push
   ```

6. **Users update automatically** via plugin system

### Testing Changes

Before committing:

1. **Verify plugin manifest**:
   ```bash
   cat .claude-plugin/plugin.json
   # Check version, name, description
   ```

2. **Test commands work**:
   ```bash
   /kc:init  # Should create knowzcode/
   /kc:work "Test" # Should work with test project
   ```

3. **Verify no breaking changes**:
   - Existing commands still work
   - Project data structure unchanged
   - Backward compatibility maintained

## Migration from v1.x

If you used the old KnowzCode installation model (with `/kc-install` and `.claude/` directories), see [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for:

- Understanding architectural changes
- Migrating existing projects
- Preserving your data
- Handling customizations
- Updated command names

**Quick migration:**

1. Install plugin: `/plugin install knowzcode`
2. Your `knowzcode/` data is preserved automatically
3. Remove old `.claude/` directory (commands now in plugin)
4. Update command usage: `/kc` → `/kc:work`, etc.

## Contributing

### How to Contribute

1. **Fork** this repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Make** your changes to `commands/`, `agents/`, or `skills/`
4. **Test** thoroughly in a test project
5. **Commit** with conventional commits: `git commit -m 'feat: add amazing feature'`
6. **Push** to your fork: `git push origin feature/amazing-feature`
7. **Open** a Pull Request

### What to Contribute

- **New commands**: Additional workflow helpers
- **New agents**: Specialized sub-agents for specific tasks
- **Improvements**: Better prompts, clearer documentation
- **Bug fixes**: Resolve issues or edge cases
- **Documentation**: Tutorials, examples, guides

### Guidelines

- **Test thoroughly** before submitting
- **Follow existing patterns** for commands and agents
- **Update documentation** for user-facing changes
- **Maintain backward compatibility** when possible
- **Use semantic versioning** for breaking changes

## Philosophy

KnowzCode follows these principles:

1. **Test-Driven Development**: Every feature starts with failing tests
2. **Quality Gates**: Automated verification at each phase
3. **Living Documentation**: Architecture and specs stay current
4. **Incremental Progress**: Small, safe steps with verification
5. **Transparent State**: Visible tracking of all work
6. **Separation of Concerns**: Framework (plugin) vs. Data (project)

## Support

- **Issues**: https://github.com/AlexHeadscarf/KnowzCode/issues
- **Discussions**: https://github.com/AlexHeadscarf/KnowzCode/discussions
- **Documentation**: See `docs/` directory

## License

MIT License - See LICENSE file for details

---

**Remember:**
- This repo is the **plugin source**
- Your work happens in **your projects** (after `/kc:init`)
- Commands/agents are **global** (via plugin)
- Project data is **local** (in `knowzcode/` directory)
- Commands require namespace in Claude Code (`/kc:*`)
