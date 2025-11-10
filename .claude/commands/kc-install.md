---
description: "◆ KnowzCode: Install KnowzCode framework into a target project from this template repository"
argument-hint: "<target_path>"
---

# ◆ KnowzCode Installation

Install the KnowzCode framework into a target project directory.

**Target Path**: $1

## What Gets Installed

- ✅ **Agents**: All specialized sub-agents for orchestration
- ✅ **Commands**: Slash commands for workflow execution
- ✅ **Prompts**: Reusable prompt templates
- ✅ **Core Files**: knowzcode/ directory structure

## Execution

Use the update-coordinator sub-agent to orchestrate the installation process.

Context:
- Source Path: $(pwd) (current directory - this template repository)
- Target Path: $1
- Mode: Fresh installation

Instructions for update-coordinator:

### Step 1: Validate Target

1. **Check target path**:
   ```bash
   TARGET_PATH="$1"
   SOURCE_PATH="$(pwd)"

   if [ -z "$TARGET_PATH" ]; then
     echo "ERROR: Target path required"
     echo "Usage: /kc-install <target_path>"
     exit 1
   fi

   if [ ! -d "$TARGET_PATH" ]; then
     echo "ERROR: Target path does not exist: $TARGET_PATH"
     exit 1
   fi
   ```

2. **Check for existing installation**:
   ```bash
   if [ -d "$TARGET_PATH/.claude" ] || [ -d "$TARGET_PATH/knowzcode" ]; then
     echo "KnowzCode already installed. Use /kc-update to update."
     exit 1
   fi
   ```

### Step 2: Copy Framework Files

1. **Copy agents, commands, and prompts**:
   ```bash
   cd "$TARGET_PATH"

   # Copy .claude directory (agents, commands)
   cp -r "$SOURCE_PATH/claude" .claude
   echo "✅ Installed agents and commands"
   ```

2. **Copy knowzcode directory**:
   ```bash
   # Copy knowzcode structure
   cp -r "$SOURCE_PATH/knowzcode" .
   echo "✅ Installed knowzcode framework"
   ```

3. **Initialize project data files** (if they don't exist):
   ```bash
   [ ! -f "knowzcode/knowzcode_tracker.md" ] && cat > knowzcode/knowzcode_tracker.md <<'EOF'
# KnowzCode Tracker

## Active WorkGroups
None

## Completed WorkGroups
None
EOF

   [ ! -f "knowzcode/knowzcode_log.md" ] && cat > knowzcode/knowzcode_log.md <<EOF
# KnowzCode Event Log

**$(date -u +"%Y-%m-%d %H:%M:%S UTC")**: KnowzCode framework installed
EOF

   echo "✅ Initialized project data"
   ```

### Step 3: Report Success

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ KNOWZCODE INSTALLATION SUCCESSFUL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Target**: $TARGET_PATH

## Components Installed

- Agents: $(ls -1 $TARGET_PATH/.claude/agents/*.md 2>/dev/null | wc -l) sub-agents
- Commands: $(ls -1 $TARGET_PATH/.claude/commands/*.md 2>/dev/null | wc -l) slash commands
- Prompts: $(ls -1 $TARGET_PATH/knowzcode/prompts/*.md 2>/dev/null | wc -l) templates

## Available Commands

- \`/kc\` - Start KnowzCode workflow
- \`/kc-step <phase>\` - Execute specific phases
- \`/kc-update <source>\` - Update framework

## Next Steps

1. Edit \`knowzcode/environment_context.md\` with project details
2. Edit \`knowzcode/knowzcode_project.md\` with project metadata
3. Run \`/kc "your first feature"\`

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
