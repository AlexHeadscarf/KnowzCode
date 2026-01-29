# KnowzCode - Claude Code Development Workflow Plugin

<div align="center">

**Structured TDD • Quality Gates • Multi-Agent Orchestration • Living Documentation**

[![Install Plugin](https://img.shields.io/badge/Plugin-Install-blue)](https://github.com/AlexHeadscarf/KnowzCode)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin-purple)](https://claude.ai/code)

[Installation](#installation) • [Quick Start](#quick-start) • [Documentation](#documentation) • [Migration Guide](MIGRATION_GUIDE.md)

</div>

---

## What is KnowzCode?

KnowzCode is a **Claude Code plugin** that transforms AI-assisted development into a structured, quality-driven workflow. It provides:

- 🧪 **Test-Driven Development**: Enforced Red-Green-Refactor cycles with quality verification
- 🤖 **Multi-Agent Orchestration**: Specialized agents for analysis, specs, implementation, and auditing
- 📋 **Living Documentation**: Auto-maintained architecture diagrams and component specifications
- ✅ **Quality Gates**: Automated verification prevents proceeding until standards are met
- 📊 **WorkGroup Tracking**: Complete transparency with session history and progress tracking

**Claude Code already knows how to write code. KnowzCode teaches it how to engineer software.**

## Installation

### Step 1: Add Marketplace

```bash
/plugin marketplace add https://github.com/AlexHeadscarf/KnowzCode
```

### Step 2: Install Plugin

```bash
/plugin install knowzcode
```

### Step 3: Initialize Your Project

```bash
cd your-project/
/kc:init
```

### Step 4: Connect to KnowzCode Cloud (Optional)

Unlock enhanced AI-powered features:

```bash
/kc:connect-mcp <your-api-key>
```

**Current Environment**: Development (`api.dev.knowz.io`) - Production coming after testing

Get your API key at [knowz.io/api-keys](https://knowz.io/api-keys)

**Enhanced features:**
- 🔍 Vector search across indexed code
- 📚 Query specifications and documentation
- 🧠 Context-aware agent decisions
- 🕸️ Dependency and impact analysis

**Done!** You're ready to start building with KnowzCode.

### Alternative: Manual Installation

If the plugin marketplace isn't working, use the shell scripts:

```bash
# Clone repository
git clone https://github.com/AlexHeadscarf/KnowzCode.git
cd KnowzCode

# Install to your project
./install.sh --target /path/to/your/project      # Linux/macOS
.\install.ps1 -Target C:\path\to\your\project    # Windows
```

| Option | Bash | PowerShell | Description |
|--------|------|------------|-------------|
| Target | `--target <path>` | `-Target <path>` | Install to specific directory |
| Global | `--global` | `-Global` | Install commands to `~/.claude/` |
| Force | `--force` | `-Force` | Overwrite existing installation |

## Quick Start

### Start a New Feature

```bash
/kc:work "Build user authentication with email and password"
```

KnowzCode will:
1. ✅ **Analyze impact** - Identify components to create/modify
2. 📝 **Generate specs** - Create detailed specifications
3. 🧪 **Implement with TDD** - Guide you through test-first development
4. ✓ **Verify quality** - Run automated checks and reviews
5. 📚 **Update documentation** - Keep architecture current

### Investigate Before Implementing

Have a question about the codebase? Use investigation mode:

```bash
/kc:plan investigate "is the API using proper error handling?"
/kc:plan investigate "how is authentication implemented?"
```

KnowzCode spawns **3 parallel research agents** to explore your question efficiently. After investigation, say "implement" or select an option to auto-transition to `/kc:work` with findings pre-loaded.

### Execute Specific Phases

```bash
/kc:step 1A    # Run impact analysis only
/kc:step 2A    # Jump to implementation
/kc:step 2B    # Run verification
```

### Run Quality Audits

```bash
/kc:audit spec          # Review specifications
/kc:audit architecture  # Check architecture health
/kc:audit security      # Security assessment
/kc:audit integration   # Integration test coverage
```

### Resume Work After Interruptions

```bash
/kc:continue           # Restore context and resume current WorkGroup
# or just say: "continue"     # Automatically triggers continuation
```

KnowzCode will:
1. 🔍 **Detect active WorkGroup** - Find where you left off
2. 📥 **Load full context** - Specs, todos, phase, test status
3. 🎯 **Identify current phase** - Determine exact position in workflow
4. ✅ **Re-establish discipline** - Enforce TDD, quality gates, framework patterns
5. ▶️ **Resume execution** - Continue from exact interruption point

## How It Works

### Plugin Architecture

KnowzCode uses Claude Code's plugin system to provide a clean separation between framework and project data:

**Global Plugin** (installed once, auto-updates):
```
~/.claude/plugins/knowzcode/
├── commands/     # All /kc:* slash commands
├── agents/       # Specialized sub-agents
└── skills/       # Development skills
```

**Project Directory** (visible, version-controlled):
```
your-project/
└── knowzcode/         # Committed to git!
    ├── knowzcode_project.md      # Project metadata
    ├── knowzcode_tracker.md      # WorkGroup status
    ├── knowzcode_log.md          # Development history
    ├── knowzcode_architecture.md # Auto-updated architecture
    ├── specs/                    # Component specifications
    └── workgroups/               # Active WorkGroups
```

**Key Benefits:**
- ✅ Install once globally, use in any project
- ✅ Automatic updates via Claude Code marketplace
- ✅ No hidden directories - everything visible and git-committable
- ✅ Clean separation: framework code vs. project data
- ✅ Works seamlessly across all your projects

### Development Loop

KnowzCode follows a structured **3-phase loop**:

#### Phase 1: Planning
- **1A - Impact Analysis**: Identify affected components
- **1B - Specification**: Define detailed requirements

#### Phase 2: Implementation
- **2A - Development**: TDD implementation with agent guidance
- **2B - Verification**: Automated quality checks

#### Phase 3: Finalization
- Update architecture documentation
- Close WorkGroup
- Archive specifications

Each phase has **quality gates** that must pass before proceeding.

## Available Commands

| Command | Description | Example |
|:--------|:------------|:--------|
| `/kc:init` | Initialize KnowzCode in project | `/kc:init` |
| `/kc:register` | Register and configure MCP automatically | `/kc:register` |
| `/kc:work <goal>` | Start new feature WorkGroup | `/kc:work "Add dark mode"` |
| `/kc:continue [wg-id]` | Resume current WorkGroup with context recovery | `/kc:continue` |
| `/kc:step <phase>` | Execute specific phase | `/kc:step 2A` |
| `/kc:audit [type]` | Run quality audits | `/kc:audit security` |
| `/kc:plan [type]` | Generate development plans | `/kc:plan feature` |
| `/kc:plan investigate` | Investigate codebase with parallel agents | `/kc:plan investigate "how does auth work?"` |
| `/kc:fix <target>` | Quick targeted fix | `/kc:fix auth.js` |
| `/kc:resolve-conflicts` | Resolve merge conflicts | `/kc:resolve-conflicts` |
| `/kc:connect-mcp` | Configure MCP server | `/kc:connect-mcp <api-key>` |
| `/kc:status` | Check MCP connection status | `/kc:status` |
| `/kc:migrate-knowledge` | Import external knowledge into specs | `/kc:migrate-knowledge ./docs` |
| `/kc:telemetry` | Investigate production telemetry | `/kc:telemetry "error 500 in prod"` |
| `/kc:telemetry-setup` | Configure telemetry sources | `/kc:telemetry-setup` |

## Example Workflow

### 1. Initialize New Project

```bash
mkdir my-app && cd my-app
git init
/kc:init
```

### 2. Start First Feature

```bash
/kc:work "Build REST API with Express.js for user management"
```

**KnowzCode will:**
- Create WorkGroup `WG-001`
- Analyze what needs to be built
- Generate specifications
- Guide TDD implementation
- Verify code quality
- Update documentation

### 3. Review Progress

```bash
cat knowzcode/knowzcode_tracker.md
```

See all WorkGroups, their status, and completion.

### 4. Continue Development

```bash
/kc:work "Add JWT authentication to API"
```

Each feature gets its own WorkGroup with full tracking.

## Features

### 🧪 Test-Driven Development

KnowzCode **enforces TDD**:

1. Write failing test
2. Implement minimal code
3. Refactor if needed
4. Repeat

No production code without tests!

### 🤖 Specialized Agents

Different agents handle different tasks:

- **Impact Analyst**: Identifies affected components
- **Spec Chief**: Writes detailed specifications
- **Implementation Lead**: Guides TDD implementation
- **ARC Auditor**: Verifies code quality
- **Architecture Reviewer**: Maintains architecture health
- **Security Officer**: Performs security audits

### 📋 Living Documentation

Documentation **stays current**:

- Architecture diagrams auto-update
- Component specs track implementation
- API documentation reflects actual code
- Test coverage reports generated automatically

### 🔄 Interruption Recovery

KnowzCode handles interruptions gracefully:

- **Auto-detection**: Just say "continue" to resume
- **Full context restoration**: Loads specs, todos, phase, and test status
- **Phase identification**: Determines exact position in workflow
- **Framework re-establishment**: Restores TDD discipline and quality gates
- **Transparent recovery**: Shows you exactly where you are before resuming

**Never lose progress** - KnowzCode remembers everything and picks up exactly where you left off.

### ✅ Quality Gates

Automated checks at each phase:

- Code style (linting/formatting)
- Test coverage thresholds
- Security vulnerability scans
- Architecture compliance
- Performance benchmarks

### 🌐 MCP Integration (Optional Cloud Features)

Connect to **KnowzCode Cloud** for AI-powered enhancements via Model Context Protocol (MCP):

#### What You Get

- **Vector Knowledge Search** - Semantic search across indexed code and documentation
- **AI-Powered Q&A** - Ask questions with optional research mode (8000+ token comprehensive answers)
- **Learning Capture** - Save patterns, decisions, and conventions to your knowledge vault
- **Smart Context** - Agents automatically receive relevant context for their tasks

#### Available MCP Tools

| Tool | Purpose |
|:-----|:--------|
| `search_knowledge` | Vector search across vaults with tag/date filtering |
| `ask_question` | AI Q&A with optional `researchMode` for comprehensive answers |
| `create_knowledge` | Save learnings, notes, decisions to vault |
| `update_knowledge` | Update existing knowledge items |
| `get_knowledge_item` | Retrieve item by ID with related items |
| `bulk_get_knowledge_items` | Batch fetch up to 100 items |
| `list_vaults` | List accessible vaults with stats |
| `list_vault_contents` | Browse vault items with filters |
| `find_entities` | Find people, locations, events in your knowledge |

#### How It Works

```bash
# One-time setup per project
/kc:connect-mcp <your-api-key>

# Optional: Custom endpoint (self-hosted)
/kc:connect-mcp <your-api-key> --endpoint https://your-domain.com/mcp

# Restart Claude Code to activate

# Verify connection
/kc:status
```

Once connected, **all KnowzCode agents automatically use MCP tools**:

| Agent | Uses MCP For |
|:------|:-------------|
| **Impact Analyst** | `search_knowledge` to find related code and past decisions |
| **Spec Chief** | `ask_question` for conventions, `search_knowledge` for patterns |
| **Implementation Lead** | `search_knowledge` for similar implementations |
| **Finalization Steward** | `create_knowledge` to capture learnings automatically |

#### Configuration Scopes

Choose how to configure the MCP server:

- **local** (default): Only this project, private to you
- **project**: Shared with team via `.mcp.json` (committed to git)
- **user**: Available across all your projects

```bash
# Local scope (default)
/kc:connect-mcp <api-key>

# Project-wide (team access)
/kc:connect-mcp <api-key> --scope project

# Global (all your projects)
/kc:connect-mcp <api-key> --scope user
```

#### Graceful Degradation

**KnowzCode works perfectly without MCP** - agents simply use traditional grep/glob/read tools. MCP enhances their capabilities but isn't required.

Get your API key: [knowz.io/api-keys](https://knowz.io/api-keys)

## Why KnowzCode?

### The Problem with Traditional AI Coding

**Claude Code is powerful** - it can read your entire codebase, write complex code, and understand requirements. But without structure:

- 🔴 **No memory**: Forgets context between sessions
- 🔴 **Random changes**: Modifies files without considering impact
- 🔴 **No verification**: "Done" means "I wrote code" not "it works"
- 🔴 **Stale docs**: Documentation drifts from reality immediately
- 🔴 **Hope-driven quality**: Cross fingers that tests catch issues

### How KnowzCode Fixes This

| Challenge | KnowzCode Solution |
|-----------|-------------------|
| **Lost context** | WorkGroup tracking + complete session history |
| **Missing connections** | Living architecture + auto-updated specifications |
| **Scattered changes** | Complete Change Sets - all related pieces together |
| **Unverified code** | Quality gates at every phase + automated verification |
| **Outdated docs** | Specs updated after every change |
| **Merge chaos** | WorkGroup isolation + smart conflict resolution |
| **Unknown quality** | Pre-code spec audit + post-code ARC verification |

**Result:** Software development becomes systematic, transparent, and high-quality.

## Migration from v1.x

**Used the old KnowzCode** with `/kc-install` and `.claude/` directories?

### Quick Migration

1. **Install plugin**: `/plugin install knowzcode`
2. **Your data is safe**: `knowzcode/` directory preserved automatically
3. **Remove `.claude/`**: Commands now come from plugin
4. **Update command usage**: Old `/kc` → New `/kc:work`

See **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** for detailed migration steps.

## Project Structure

### What You Edit

These files are **yours to customize**:

- `knowzcode/knowzcode_project.md` - Project goals, tech stack
- `knowzcode/specs/*.md` - Component specifications
- `knowzcode/prompts/*.md` - Custom prompt templates

### What KnowzCode Manages

These files are **auto-generated**:

- `knowzcode/knowzcode_tracker.md` - WorkGroup tracking
- `knowzcode/knowzcode_log.md` - Session history
- `knowzcode/knowzcode_architecture.md` - Architecture docs
- `knowzcode/workgroups/*.md` - Individual WorkGroups

### Recommended `.gitignore`

```gitignore
# Commit framework data
!knowzcode/*.md
!knowzcode/specs/
!knowzcode/prompts/

# Optional: Exclude session-specific data
knowzcode/workgroups/
```

## Contributing

We welcome contributions!

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing`
3. Make changes to `commands/` or `agents/`
4. Test thoroughly
5. Submit pull request

See **[CLAUDE.md](CLAUDE.md)** for developer documentation.

## Philosophy

KnowzCode is built on these principles:

1. **Quality Over Speed**: Better code takes time
2. **Tests First**: Every feature needs tests
3. **Incremental Progress**: Small, safe steps
4. **Transparency**: Visible tracking of all work
5. **Automation**: Automate quality checks
6. **Documentation**: Keep docs current

## Multi-Session Collaboration

Work on multiple features simultaneously without conflicts:

```bash
# Developer 1
git checkout -b feature/profiles
/kc:work "Add user profiles"

# Developer 2
git checkout -b feature/notifications
/kc:work "Add email notifications"

# Merge both - conflicts auto-resolve
git merge feature/profiles          # ✓ Clean
git merge feature/notifications     # Conflict (expected)
/kc:resolve-conflicts       # Auto-resolves safely
```

## Documentation

- **[Getting Started](./docs/knowzcode_getting_started.md)** - Complete walkthrough
- **[Understanding KnowzCode](./docs/understanding-knowzcode.md)** - Deep dive into concepts
- **[Prompts Guide](./docs/knowzcode_prompts_guide.md)** - All commands and workflows
- **[Visual Guide](./docs/knowzcode_guide.md)** - File structure roadmap
- **[Developer Guide](./CLAUDE.md)** - Plugin development documentation

## Support

- **Issues**: [GitHub Issues](https://github.com/AlexHeadscarf/KnowzCode/issues)
- **Discussions**: [GitHub Discussions](https://github.com/AlexHeadscarf/KnowzCode/discussions)
- **Documentation**: See [`docs/`](docs/) directory

## Acknowledgments

KnowzCode is built upon the excellent foundation of the [Noderr project](https://github.com/kaithoughtarchitect/noderr) by [@kaithoughtarchitect](https://github.com/kaithoughtarchitect). We're grateful for their pioneering work in systematic AI-driven development.

## License

MIT License - See [LICENSE](LICENSE) file

---

<div align="center">

**Built with ❤️ for software quality**

*Welcome to systematic AI development. Welcome to KnowzCode.*

**Because great software isn't just coded. It's engineered.**

[Get Started](#installation) • [View Docs](CLAUDE.md) • [Contribute](CLAUDE.md#contributing)

</div>
