# KnowzCode v2.0 Plugin Migration Guide

## Overview

KnowzCode v2.0 introduces a **plugin-based architecture** that eliminates hidden `.claude/` directories and provides native Claude Code distribution.

### What Changed

| Old Model (v1.x) | New Model (v2.0) |
|:-----------------|:-----------------|
| Hidden `.claude/` directory in projects | No `.claude/` in projects |
| `/kc-install` command copies files | Plugin installed globally once |
| `/kc-update` command merges changes | Plugin updates automatically |
| Commands like `/kc`, `/kc-step` | Namespaced: `/knowzcode:work`, `/knowzcode:step` |
| Clone template repo required | Install from marketplace |
| Commands/agents per-project | Commands/agents global (via plugin) |
| Project data in `.claude/` | Project data in visible `knowzcode/` |

### Architecture

**Plugin (Global, installed once):**
```
~/.claude/plugins/knowzcode/
├── commands/          # All /knowzcode:* commands
├── agents/            # All sub-agents
└── skills/            # Optional skills
```

**Project (Visible, per-project):**
```
my-project/
└── knowzcode/         # Visible directory!
    ├── knowzcode_project.md
    ├── knowzcode_tracker.md
    ├── knowzcode_log.md
    ├── specs/
    └── workgroups/
```

## Migration Paths

### Path 1: New Projects (Recommended)

Start fresh with the plugin model:

1. **Install plugin** (one time):
   ```bash
   # Add marketplace
   /plugin marketplace add https://github.com/AlexHeadscarf/knowzcode-marketplace

   # Install KnowzCode plugin
   /plugin install knowzcode
   ```

2. **Initialize in your project**:
   ```bash
   cd my-new-project/
   /knowzcode:init
   ```

3. **Start working**:
   ```bash
   /knowzcode:work "Build authentication system"
   ```

### Path 2: Existing Projects (Manual Migration)

Migrate existing KnowzCode v1.x projects:

#### Step 1: Install Plugin

```bash
# Add marketplace
/plugin marketplace add https://github.com/AlexHeadscarf/knowzcode-marketplace

# Install plugin
/plugin install knowzcode
```

#### Step 2: Preserve Your Data

Your project currently has:
```
my-project/
├── .claude/
│   ├── agents/       # These will come from plugin now
│   ├── commands/     # These will come from plugin now
│   └── (customizations?)
└── knowzcode/
    ├── knowzcode_project.md    # Keep this!
    ├── knowzcode_tracker.md    # Keep this!
    ├── specs/                  # Keep this!
    └── workgroups/             # Keep this!
```

**What to preserve:**
- ✅ Everything in `knowzcode/` directory
- ✅ Any custom agents/commands (migrate manually)
- ❌ Standard agents/commands from `.claude/` (now in plugin)

#### Step 3: Clean Up

```bash
# Back up first (optional safety)
cp -r .claude .claude.backup-pre-v2

# Remove standard .claude/ directory
rm -rf .claude/
```

#### Step 4: Handle Customizations (if any)

If you customized agents or commands in `.claude/`:

1. **Review your customizations**:
   ```bash
   # Check what you modified
   diff -r .claude.backup-pre-v2/agents/ <plugin-agents-path>
   diff -r .claude.backup-pre-v2/commands/ <plugin-commands-path>
   ```

2. **Migrate custom agents/commands**:
   - Personal commands: Move to `~/.claude/commands/`
   - Project commands: Create `.claude/commands/` in project (still supported)
   - Custom agents: Contact maintainer about contributing to plugin

#### Step 5: Verify

```bash
# Should work immediately with new command names
/knowzcode:work "Test migration"
```

### Path 3: Hybrid (Keep Both)

You can keep the old model in some projects and use the new model in others:

- **Old projects**: Continue using `/kc-install` and `.claude/` directories
- **New projects**: Use plugin model with `/knowzcode:init`

The plugin doesn't conflict with the old installation model.

## Breaking Changes

### Removed Commands

| Command | Replacement | Why |
|:--------|:------------|:----|
| `/kc-install <target>` | `/knowzcode:init` | Plugin installs globally now |
| `/kc-update <target>` | Plugin auto-update | Plugins update via marketplace |
| `/kc-rollback` | Git revert on `knowzcode/` | Simpler with visible directory |

### Renamed Commands (v2.0)

All commands have been renamed for clarity and now require the `knowzcode:` namespace prefix:

| Old Command (v1.x) | New Command (v2.0) |
|:-------------------|:-------------------|
| `/kc "goal"` | `/knowzcode:work "goal"` |
| `/kc-init` | `/knowzcode:init` |
| `/kc-step <phase>` | `/knowzcode:step <phase>` |
| `/kc-audit [type]` | `/knowzcode:audit [type]` |
| `/kc-plan [type]` | `/knowzcode:plan [type]` |
| `/kc-microfix <target>` | `/knowzcode:fix <target>` |
| `/kc-resolve-merge` | `/knowzcode:resolve-conflicts` |

**Note**: The namespace (`knowzcode:`) is required in Claude Code to prevent command conflicts with other plugins.

### Changed Behavior

1. **Commands are global**: All `/knowzcode:*` commands available everywhere after plugin install
2. **Command namespace required**: Commands need `knowzcode:` prefix to prevent conflicts
3. **No per-project agents**: Agents come from plugin, not project `.claude/` directory
4. **Visible data directory**: `knowzcode/` is visible and git-committable

### Platform Support

KnowzCode is built exclusively for **Claude Code** using its native plugin architecture, agent SDK, and command system.

**Why Claude Code only?**
- Requires Claude Code's plugin architecture for global installation
- Requires agent orchestration for multi-phase workflows
- Requires sub-agent delegation (impact-analyst, spec-chief, implementation-lead, etc.)
- Requires command namespacing for WorkGroup state management
- Requires persistent plugin storage for framework updates

Other AI coding assistants use different architectures and cannot support KnowzCode's structured workflow system.

## FAQ

### "Where did my .claude/ directory go?"

Commands and agents now live in the **plugin** (`~/.claude/plugins/knowzcode/`), not in each project. Your project data moved to the **visible** `knowzcode/` directory.

### "Can I still customize agents?"

Yes, but differently:

- **Personal customizations**: Add to `~/.claude/agents/` (user-wide)
- **Project-specific**: Create `.claude/agents/` in your project (project-local)
- **Share with community**: Contribute to KnowzCode plugin

### "What about my existing WorkGroups and specs?"

They're **preserved** in `knowzcode/`:
- `knowzcode/workgroups/` - All WorkGroup data
- `knowzcode/specs/` - All specifications
- `knowzcode/knowzcode_tracker.md` - Tracker state
- `knowzcode/knowzcode_log.md` - Session logs

Just make sure the `knowzcode/` directory exists and contains your data.

### "Do I need to reinstall in every project?"

**No!** That's the beauty of plugins:

1. Install plugin **once** globally
2. Run `/knowzcode:init` in each new project
3. All commands work immediately

### "Can I contribute to the plugin?"

Yes! The plugin is open source:

1. Fork https://github.com/AlexHeadscarf/KnowzCode
2. Make improvements to `commands/` or `agents/`
3. Submit a pull request
4. Updates distribute to all users automatically

### "What if I don't like the plugin model?"

You can continue using the old model:

1. Keep the template repo cloned locally
2. Continue using `/kc-install` and `/kc-update`
3. Keep `.claude/` directories in projects

Both models coexist peacefully.

## Troubleshooting

### "Plugin not found"

```bash
# Make sure marketplace is added
/plugin marketplace list

# If not listed:
/plugin marketplace add https://github.com/AlexHeadscarf/knowzcode-marketplace

# Then install
/plugin install knowzcode
```

### "Commands not working"

```bash
# Check plugin is enabled
/plugin list

# If disabled:
/plugin enable knowzcode
```

### "/knowzcode:init creates nothing"

Check your current directory:

```bash
pwd  # Should be in your project root
ls -la  # Verify you're in the right place

# Then retry
/knowzcode:init
```

### "Can't find knowzcode/ directory"

The plugin expects `knowzcode/` in your **current working directory**:

```bash
# Navigate to project root
cd /path/to/my-project

# Initialize if needed
/knowzcode:init

# Or check it exists
ls -la knowzcode/
```

## Benefits of Plugin Model

### For Users

✅ **One-time setup**: Install plugin once, use everywhere
✅ **Automatic updates**: Get improvements without manual merging
✅ **Cleaner projects**: No hidden directories
✅ **Discoverable**: Browse plugins via `/plugin`
✅ **Git-friendly**: Visible `knowzcode/` tracks project evolution

### For Maintainers

✅ **Easier distribution**: Native Claude Code marketplace
✅ **Version management**: Semantic versioning built-in
✅ **User feedback**: Centralized plugin updates
✅ **Collaboration**: Community contributions easier

## Next Steps

1. **Install the plugin**: `/plugin marketplace add` → `/plugin install knowzcode`
2. **Initialize a project**: `cd my-project && /knowzcode:init`
3. **Start building**: `/knowzcode:work "your feature"`
4. **Learn new command names**: See "Renamed Commands" section above
5. **Join the community**: https://github.com/AlexHeadscarf/KnowzCode

---

**Questions?** Open an issue at https://github.com/AlexHeadscarf/KnowzCode/issues
