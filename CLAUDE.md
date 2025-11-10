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
/knowzcode:init

# Start building
/knowzcode:work "Build user authentication"
```

**That's it!** The plugin provides all commands and agents globally.

## How It Works

### Plugin Architecture (Hybrid Model)

**Plugin (installed globally once):**
```
~/.claude/plugins/knowzcode/
├── commands/          # All /knowzcode:* slash commands
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
| `/knowzcode:init` | Initialize KnowzCode in current project |
| `/knowzcode:work <goal>` | Start new feature WorkGroup |
| `/knowzcode:step <phase>` | Execute specific workflow phase |
| `/knowzcode:audit [type]` | Run quality audits |
| `/knowzcode:plan [type]` | Generate development plans |
| `/knowzcode:fix <target>` | Quick targeted fixes |
| `/knowzcode:resolve-conflicts` | Resolve merge conflicts |

## Project Structure

### What Gets Committed

The `knowzcode/` directory should be **committed to git**:

```gitignore
# Commit these
knowzcode/*.md
knowzcode/specs/
knowzcode/prompts/

# Optional: Exclude session-specific data
knowzcode/workgroups/
```

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
/knowzcode:init
```

This creates the `knowzcode/` directory structure.

### 2. Start Feature Development

```bash
/knowzcode:work "Build user registration with email verification"
```

This:
1. Creates a new WorkGroup (e.g., `WG-001`)
2. Runs impact analysis (Phase 1A)
3. Generates specifications (Phase 1B)
4. Implements with TDD (Phase 2A)
5. Verifies quality (Phase 2B)
6. Finalizes documentation (Phase 3)

### 3. Work Through Phases

KnowzCode guides you through each phase with quality gates:

- **Phase 1A (Impact Analysis)**: Understand changes needed
- **Phase 1B (Specification)**: Define component specs
- **Phase 2A (Implementation)**: Build with TDD
- **Phase 2B (Verification)**: Quality checks
- **Phase 3 (Finalization)**: Update docs and close WorkGroup

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
├── knowzcode/               # Template files (copied on /knowzcode:init)
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
   /knowzcode:init

   # Test commands
   /knowzcode:work "Test feature"
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
   /knowzcode:init  # Should create knowzcode/
   /knowzcode:work "Test" # Should work with test project
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
4. Update command usage: `/kc` → `/knowzcode:work`, etc.

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
- Your work happens in **your projects** (after `/knowzcode:init`)
- Commands/agents are **global** (via plugin)
- Project data is **local** (in `knowzcode/` directory)
- Commands require namespace in Claude Code (`/knowzcode:*`)
