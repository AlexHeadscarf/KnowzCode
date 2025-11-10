# KnowzCode Template Repository

## ⚠️ Important: This is a Template Repository

This repository is the **master template** for the KnowzCode framework. It is NOT a project to be developed in directly.

## Repository Purpose

### What This Repo Is
- ✅ **Source template** for KnowzCode framework
- ✅ **Installation source** for new projects
- ✅ **Update source** for existing KnowzCode installations
- ✅ **Reference implementation** of agents, commands, and prompts

### What This Repo Is NOT
- ❌ **NOT a project workspace** - Don't develop features here
- ❌ **NOT an installation target** - Install TO other projects, not this one
- ❌ **NOT a standalone application** - This is framework code only

## How to Use This Repository

### For Installing KnowzCode

1. **Clone this template** (one time):
   ```bash
   git clone https://github.com/AlexHeadscarf/KnowzCode.git
   cd KnowzCode
   ```

2. **Install into your project** (from this directory):
   ```bash
   # Run Claude Code from this folder
   /kc-install /path/to/your/project
   ```

3. **Switch to your project** and start using KnowzCode:
   ```bash
   cd /path/to/your/project
   /kc "Your first feature"
   ```

### For Updating Projects

When this template gets improvements:

```bash
# From this template directory
/kc-update /path/to/your/project
```

This merges template improvements into your project while preserving:
- Your project data (tracker, logs, workgroups)
- Your customizations (custom agents, commands)
- Your specs and implementation work

## Working in This Repository

### If You're Improving the Template

When editing files in this repository, remember you're changing the **template** that will be installed into projects:

1. **Agent files** (`claude/agents/*.md`):
   - These define sub-agent behaviors
   - Changes affect ALL projects that install/update
   - Test changes thoroughly before committing

2. **Command files** (`claude/commands/*.md`):
   - These define slash commands (`/kc`, `/kc-step`, etc.)
   - Changes affect command behavior across all installations
   - Ensure backward compatibility

3. **Core files** (`knowzcode/*.md`):
   - These are the framework foundations
   - `knowzcode_loop.md` - The core workflow phases
   - `knowzcode_project.md` - Template for project metadata
   - `knowzcode_tracker.md` - Template for WorkGroup tracking
   - Changes should enhance, not break, existing installations

4. **Prompts** (`knowzcode/prompts/*.md`):
   - Reusable prompt templates
   - Should be generic and project-agnostic
   - Document clearly for end users

### Testing Template Changes

Before committing changes:

1. **Install to a test project**:
   ```bash
   /kc-install /path/to/test-project
   ```

2. **Verify the installation works**:
   ```bash
   cd /path/to/test-project
   /kc-step 1A  # Test a basic workflow
   ```

3. **Test updates on existing installation**:
   ```bash
   # Back to template repo
   cd <template-directory>
   /kc-update /path/to/test-project
   ```

4. **Verify data preservation**:
   - Check that tracker, logs, workgroups weren't lost
   - Verify customizations weren't overwritten
   - Confirm new features work

### File Structure

```
<template-repository>/
├── claude/              # Template source (gets copied to .claude/)
│   ├── agents/          # Sub-agent definitions
│   └── commands/        # Slash command definitions
├── .claude/             # Working copy for testing commands locally
│   ├── agents/          # (Mirror of claude/agents)
│   └── commands/        # (Mirror of claude/commands)
├── knowzcode/           # Core framework files
│   ├── knowzcode_loop.md        # Loop phase definitions
│   ├── knowzcode_project.md     # Project metadata template
│   ├── knowzcode_tracker.md     # Tracker template
│   ├── prompts/                 # Reusable prompts
│   └── specs/                   # Example/template specs
└── docs/                # Framework documentation
```

**Note:** Both `claude/` and `.claude/` are committed to this repo:
- `claude/` is the source template that gets installed
- `.claude/` is a working copy so commands function when testing in this repo

## Installation Commands

### `/kc-install <target-path>`

Installs KnowzCode framework into a target project:
- Copies `claude/` → `.claude/` in target
- Copies `knowzcode/` → `knowzcode/` in target
- Creates initial data files
- Validates installation

### `/kc-update <target-path>`

Updates an existing KnowzCode installation:
- Detects changes between template and target
- Preserves project data (tracker, logs, workgroups, specs)
- Protects customizations (creates `.new` files for manual review)
- Updates framework files
- Validates update

Both commands require the **target path** as an argument since this repo is the source, not the target.

## Development Workflow

1. **Make changes** to template files in `claude/` or `knowzcode/`
2. **Update `.claude/`** to test locally: `cp -r claude/* .claude/`
3. **Test commands** work: Run `/kc-install` or `/kc-update` on test project
4. **Commit changes** to this template repo
5. **Users pull updates** and run `/kc-update` on their projects

## Multi-Session Support

KnowzCode **supports multiple concurrent sessions** through git branches. See [`MULTI_SESSION.md`](MULTI_SESSION.md) for:
- Working with multiple developers on the same project
- Git worktree patterns for parallel development
- How to resolve merge conflicts with `/kc-resolve-merge`
- Best practices for coordination

## Critical Rules

1. **Never develop project features in this repo** - This is template code
2. **Always test installation/update commands** before committing changes
3. **Maintain backward compatibility** - Existing installations must not break
4. **Document breaking changes** clearly in commit messages and docs
5. **Keep templates generic** - No project-specific code in the template
6. **Preserve data structures** - Don't change tracker/log formats without migration

## Questions?

- **"Can I use KnowzCode in this repo?"** - Yes, for testing template changes only
- **"Should I commit .claude/?"** - Yes, so users can test commands immediately after clone
- **"Can I customize agents here?"** - Only to improve the template for all users
- **"Where do I develop my actual project?"** - In a different repo, after running `/kc-install`

---

**Remember:** This is the **template**. Your actual work happens in projects where you've installed KnowzCode.
