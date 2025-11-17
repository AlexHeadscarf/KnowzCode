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
/knowzcode:init
```

### Step 4: Connect to KnowzCode Cloud (Optional)

Unlock enhanced AI-powered features:

```bash
/knowzcode:connect-mcp <your-api-key>
```

**Current Environment**: Development (`api.dev.knowz.io`) - Production coming after testing

Get your API key at [knowz.io/api-keys](https://knowz.io/api-keys)

**Enhanced features:**
- 🔍 Vector search across indexed code
- 📚 Query specifications and documentation
- 🧠 Context-aware agent decisions
- 🕸️ Dependency and impact analysis

**Done!** You're ready to start building with KnowzCode.

## Quick Start

### Start a New Feature

```bash
/knowzcode:work "Build user authentication with email and password"
```

KnowzCode will:
1. ✅ **Analyze impact** - Identify components to create/modify
2. 📝 **Generate specs** - Create detailed specifications
3. 🧪 **Implement with TDD** - Guide you through test-first development
4. ✓ **Verify quality** - Run automated checks and reviews
5. 📚 **Update documentation** - Keep architecture current

### Execute Specific Phases

```bash
/knowzcode:step 1A    # Run impact analysis only
/knowzcode:step 2A    # Jump to implementation
/knowzcode:step 2B    # Run verification
```

### Run Quality Audits

```bash
/knowzcode:audit spec          # Review specifications
/knowzcode:audit architecture  # Check architecture health
/knowzcode:audit security      # Security assessment
/knowzcode:audit integration   # Integration test coverage
```

### Resume Work After Interruptions

```bash
/knowzcode:continue           # Restore context and resume current WorkGroup
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
├── commands/     # All /knowzcode:* slash commands
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
| `/knowzcode:init` | Initialize KnowzCode in project | `/knowzcode:init` |
| `/knowzcode:work <goal>` | Start new feature WorkGroup | `/knowzcode:work "Add dark mode"` |
| `/knowzcode:continue [wg-id]` | Resume current WorkGroup with context recovery | `/knowzcode:continue` |
| `/knowzcode:step <phase>` | Execute specific phase | `/knowzcode:step 2A` |
| `/knowzcode:audit [type]` | Run quality audits | `/knowzcode:audit security` |
| `/knowzcode:plan [type]` | Generate development plans | `/knowzcode:plan feature` |
| `/knowzcode:fix <target>` | Quick targeted fix | `/knowzcode:fix auth.js` |
| `/knowzcode:resolve-conflicts` | Resolve merge conflicts | `/knowzcode:resolve-conflicts` |
| `/knowzcode:connect-mcp` | Configure MCP server | `/knowzcode:connect-mcp <api-key>` |
| `/knowzcode:status` | Check MCP connection status | `/knowzcode:status` |

## Example Workflow

### 1. Initialize New Project

```bash
mkdir my-app && cd my-app
git init
/knowzcode:init
```

### 2. Start First Feature

```bash
/knowzcode:work "Build REST API with Express.js for user management"
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
/knowzcode:work "Add JWT authentication to API"
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

- **Vector Code Search** - Find implementations across your indexed codebase using semantic search
- **Spec Queries** - Query specifications and documentation with natural language
- **Smart Context** - Agents automatically receive relevant context for their tasks
- **Dependency Analysis** - Understand code relationships and impact before making changes

#### How It Works

```bash
# One-time setup per project
/knowzcode:connect-mcp <your-api-key>

# Optional: Custom endpoint (self-hosted)
/knowzcode:connect-mcp <your-api-key> --endpoint https://your-domain.com/mcp

# Restart Claude Code to activate

# Verify connection
/knowzcode:status
```

Once connected, **all KnowzCode agents automatically use MCP tools**:

| Agent | Uses MCP For |
|:------|:-------------|
| **Impact Analyst** | `search_codebase` to find related code<br>`analyze_dependencies` to map change ripple effects<br>`get_context` to understand the domain |
| **Spec Chief** | `query_specs` to retrieve existing specifications<br>`search_codebase` to find implementation patterns |
| **Implementation Lead** | `query_specs` to load specifications<br>`search_codebase` to find reference implementations |

#### Configuration Scopes

Choose how to configure the MCP server:

- **local** (default): Only this project, private to you
- **project**: Shared with team via `.mcp.json` (committed to git)
- **user**: Available across all your projects

```bash
# Local scope (default)
/knowzcode:connect-mcp <api-key>

# Project-wide (team access)
/knowzcode:connect-mcp <api-key> --scope project

# Global (all your projects)
/knowzcode:connect-mcp <api-key> --scope user
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
4. **Update command usage**: Old `/kc` → New `/knowzcode:work`

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
/knowzcode:work "Add user profiles"

# Developer 2
git checkout -b feature/notifications
/knowzcode:work "Add email notifications"

# Merge both - conflicts auto-resolve
git merge feature/profiles          # ✓ Clean
git merge feature/notifications     # Conflict (expected)
/knowzcode:resolve-conflicts       # Auto-resolves safely
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
