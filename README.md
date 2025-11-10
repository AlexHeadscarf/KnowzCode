# KnowzCode - AI-Powered Development Workflow Framework

<div align="center">

**Structured TDD • Quality Gates • Multi-Agent Orchestration • Living Documentation**

[![Install Plugin](https://img.shields.io/badge/Plugin-Install-blue)](https://github.com/AlexHeadscarf/KnowzCode)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[Installation](#installation) • [Quick Start](#quick-start) • [Documentation](#documentation) • [Migration Guide](MIGRATION_GUIDE.md)

</div>

---

## What is KnowzCode?

KnowzCode is a **Claude Code plugin** that transforms software development into a structured, quality-driven workflow. It provides:

- 🧪 **Test-Driven Development**: Enforced Red-Green-Refactor cycles
- 🤖 **Multi-Agent System**: Specialized AI agents for analysis, implementation, and verification
- 📋 **Living Documentation**: Auto-generated architecture diagrams and specifications
- ✅ **Quality Gates**: Automated verification at each development phase
- 📊 **WorkGroup Tracking**: Transparent progress tracking for every feature

Your AI already knows how to code. **KnowzCode teaches it how to engineer.**

## Installation

### For Claude Code

#### Step 1: Add Marketplace

```bash
/plugin marketplace add https://github.com/AlexHeadscarf/KnowzCode
```

#### Step 2: Install Plugin

```bash
/plugin install knowzcode
```

#### Step 3: Initialize Your Project

```bash
cd your-project/
/knowzcode:init
```

**Done!** You're ready to start building with KnowzCode.

### For Cursor IDE

#### Step 1: Clone the Repository

```bash
git clone https://github.com/AlexHeadscarf/KnowzCode.git ~/.cursor/knowzcode
```

#### Step 2: Link Commands

```bash
ln -s ~/.cursor/knowzcode/commands ~/.cursor/commands/knowzcode
ln -s ~/.cursor/knowzcode/agents ~/.cursor/agents/knowzcode
```

#### Step 3: Initialize Your Project

```bash
cd your-project/
/init  # Or /knowzcode:init if namespaced
```

**Note**: Cursor IDE may not require command namespacing. Test both formats to see which works in your environment.

## Quick Start

### Start a New Feature

**Claude Code:**
```bash
/knowzcode:work "Build user authentication with email and password"
```

**Cursor IDE:**
```bash
/work "Build user authentication with email and password"
```

KnowzCode will:
1. ✅ **Analyze impact** - Identify components to create/modify
2. 📝 **Generate specs** - Create detailed specifications
3. 🧪 **Implement with TDD** - Guide you through test-first development
4. ✓ **Verify quality** - Run automated checks and reviews
5. 📚 **Update documentation** - Keep architecture current

### Execute Specific Phases

**Claude Code:**
```bash
/knowzcode:step 1A    # Run impact analysis only
/knowzcode:step 2A    # Jump to implementation
/knowzcode:step 2B    # Run verification
```

**Cursor IDE:**
```bash
/step 1A    # Run impact analysis only
/step 2A    # Jump to implementation
/step 2B    # Run verification
```

### Run Quality Audits

**Claude Code:**
```bash
/knowzcode:audit spec          # Review specifications
/knowzcode:audit architecture  # Check architecture health
/knowzcode:audit security      # Security assessment
/knowzcode:audit integration   # Integration test coverage
```

**Cursor IDE:**
```bash
/audit spec          # Review specifications
/audit architecture  # Check architecture health
/audit security      # Security assessment
/audit integration   # Integration test coverage
```

## How It Works

### Plugin Architecture (Hybrid Model)

**Global Plugin** (installed once):
```
~/.claude/plugins/knowzcode/    # Claude Code
~/.cursor/knowzcode/             # Cursor IDE
├── commands/     # All commands
├── agents/       # Specialized AI agents
└── skills/       # Development skills (future)
```

**Project Directory** (visible, per-project):
```
your-project/
└── knowzcode/                    # Git-committable!
    ├── knowzcode_project.md      # Project context
    ├── knowzcode_tracker.md      # WorkGroup tracker
    ├── knowzcode_log.md          # Session history
    ├── specs/                    # Component specs
    └── workgroups/               # Feature tracking
```

**Key Benefits:**
- ✅ No hidden `.claude/` directories
- ✅ Install once, use everywhere
- ✅ Automatic plugin updates
- ✅ Visible project data
- ✅ Git-friendly workflow

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

### Claude Code (with namespace)

| Command | Description | Example |
|:--------|:------------|:--------|
| `/knowzcode:init` | Initialize KnowzCode in project | `/knowzcode:init` |
| `/knowzcode:work <goal>` | Start new feature WorkGroup | `/knowzcode:work "Add dark mode"` |
| `/knowzcode:step <phase>` | Execute specific phase | `/knowzcode:step 2A` |
| `/knowzcode:audit [type]` | Run quality audits | `/knowzcode:audit security` |
| `/knowzcode:plan [type]` | Generate development plans | `/knowzcode:plan feature` |
| `/knowzcode:fix <target>` | Quick targeted fix | `/knowzcode:fix auth.js` |
| `/knowzcode:resolve-conflicts` | Resolve merge conflicts | `/knowzcode:resolve-conflicts` |

### Cursor IDE (without namespace)

| Command | Description | Example |
|:--------|:------------|:--------|
| `/init` | Initialize KnowzCode in project | `/init` |
| `/work <goal>` | Start new feature WorkGroup | `/work "Add dark mode"` |
| `/step <phase>` | Execute specific phase | `/step 2A` |
| `/audit [type]` | Run quality audits | `/audit security` |
| `/plan [type]` | Generate development plans | `/plan feature` |
| `/fix <target>` | Quick targeted fix | `/fix auth.js` |
| `/resolve-conflicts` | Resolve merge conflicts | `/resolve-conflicts` |

## Example Workflow

### 1. Initialize New Project

**Claude Code:**
```bash
mkdir my-app && cd my-app
git init
/knowzcode:init
```

**Cursor IDE:**
```bash
mkdir my-app && cd my-app
git init
/init
```

### 2. Start First Feature

**Claude Code:**
```bash
/knowzcode:work "Build REST API with Express.js for user management"
```

**Cursor IDE:**
```bash
/work "Build REST API with Express.js for user management"
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

**Claude Code:**
```bash
/knowzcode:work "Add JWT authentication to API"
```

**Cursor IDE:**
```bash
/work "Add JWT authentication to API"
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

### ✅ Quality Gates

Automated checks at each phase:

- Code style (linting/formatting)
- Test coverage thresholds
- Security vulnerability scans
- Architecture compliance
- Performance benchmarks

## Comparison Table

| Aspect | Traditional AI Coding | KnowzCode |
|--------|----------------------|-----------|
| **Memory** | Forgets between sessions | Complete history + WorkGroup tracking |
| **Context** | Reads entire codebase or misses connections | Living architecture + specifications |
| **Changes** | Modifies random files → breaks things | Complete Change Sets → all pieces together |
| **Verification** | "Done" = "I wrote code" | Quality gates + automated verification |
| **Documentation** | Drifts from reality immediately | Specs updated after every change |
| **Collaboration** | Merge conflicts everywhere | WorkGroup system + conflict resolution |
| **Quality** | Hope tests catch issues | Pre-code spec audit + post-code verification |

## Migration from v1.x

**Used the old KnowzCode** with `/kc-install` and `.claude/` directories?

### Quick Migration

1. **Install plugin**: `/plugin install knowzcode` (Claude Code) or clone repo (Cursor IDE)
2. **Your data is safe**: `knowzcode/` directory preserved automatically
3. **Remove `.claude/`**: Commands now come from plugin
4. **Update command usage**: Old `/kc` → New `/knowzcode:work` (Claude) or `/work` (Cursor)

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

**Claude Code:**
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

**Cursor IDE:**
```bash
# Developer 1
git checkout -b feature/profiles
/work "Add user profiles"

# Developer 2
git checkout -b feature/notifications
/work "Add email notifications"

# Merge both - conflicts auto-resolve
git merge feature/profiles     # ✓ Clean
git merge feature/notifications # Conflict (expected)
/resolve-conflicts            # Auto-resolves safely
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
