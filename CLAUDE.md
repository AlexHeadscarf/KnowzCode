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
| `/kc:work <goal>` | Start new feature WorkGroup |
| `/kc:plan investigate <question>` | Investigate codebase with parallel research agents |
| `/kc:step <phase>` | Execute specific workflow phase |
| `/kc:audit [type]` | Run quality audits |
| `/kc:plan [type]` | Generate development plans |
| `/kc:fix <target>` | Quick targeted fixes |
| `/kc:resolve-conflicts` | Resolve merge conflicts |

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
