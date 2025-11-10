---
description: "◆ KnowzCode: Update KnowzCode framework from this template into a target project"
argument-hint: "<target_path>"
---

# ◆ KnowzCode Framework Update

Update framework files (agents, commands, prompts) from this template into your target project.

**Target Path**: $1

## What Gets Updated

- ✅ **Agents**: Sub-agent definitions
- ✅ **Commands**: Slash commands
- ✅ **Prompts**: Reusable templates
- ✅ **Core Files**: Framework documentation

## What Gets Preserved

- ✅ **Project Data**: tracker, logs, workgroups, specs
- ✅ **Customizations**: Custom agents, commands, or prompts
- ✅ **Environment**: environment_context.md, knowzcode_project.md

## Execution

Use the update-coordinator sub-agent to orchestrate the update process.

Context:
- Source Path: $(pwd) (current directory - this template repository)
- Target Path: $1
- Mode: Framework file updates only

Instructions for update-coordinator:

### Step 1: Validate Paths

```bash
TARGET_PATH="$1"
SOURCE_PATH="$(pwd)"

# Check arguments
if [ -z "$TARGET_PATH" ]; then
  echo "ERROR: Target path required"
  echo "Usage: /kc-update <target_path>"
  exit 1
fi

# Validate source template
if [ ! -d "$SOURCE_PATH/claude/agents" ] || [ ! -d "$SOURCE_PATH/knowzcode" ]; then
  echo "ERROR: Not in template repository"
  exit 1
fi

# Validate target has KnowzCode installed
if [ ! -d "$TARGET_PATH/.claude" ] || [ ! -d "$TARGET_PATH/knowzcode" ]; then
  echo "ERROR: KnowzCode not installed in target. Use /kc-install first."
  exit 1
fi
```

### Step 2: Identify Changes

Compare template to target and identify what needs updating:

```bash
cd "$SOURCE_PATH"

# Find differences in agents
echo "Checking agents..."
for agent in claude/agents/*.md; do
  agent_name=$(basename "$agent")
  target_agent="$TARGET_PATH/.claude/agents/$agent_name"

  if [ ! -f "$target_agent" ]; then
    echo "NEW: $agent_name"
  elif ! diff -q "$agent" "$target_agent" >/dev/null 2>&1; then
    echo "MODIFIED: $agent_name"
  fi
done

# Find differences in commands
echo "Checking commands..."
for cmd in claude/commands/*.md; do
  cmd_name=$(basename "$cmd")
  target_cmd="$TARGET_PATH/.claude/commands/$cmd_name"

  if [ ! -f "$target_cmd" ]; then
    echo "NEW: $cmd_name"
  elif ! diff -q "$cmd" "$target_cmd" >/dev/null 2>&1; then
    echo "MODIFIED: $cmd_name"
  fi
done

# Find differences in prompts
echo "Checking prompts..."
for prompt in knowzcode/prompts/*.md; do
  prompt_name=$(basename "$prompt")
  target_prompt="$TARGET_PATH/knowzcode/prompts/$prompt_name"

  if [ ! -f "$target_prompt" ]; then
    echo "NEW: $prompt_name"
  elif ! diff -q "$prompt" "$target_prompt" >/dev/null 2>&1; then
    echo "MODIFIED: $prompt_name"
  fi
done

# Check core framework files (knowzcode_loop.md, etc.)
for core in knowzcode/knowzcode_loop.md knowzcode/README.md; do
  if [ -f "$core" ]; then
    core_name=$(basename "$core")
    target_core="$TARGET_PATH/$core"

    if [ ! -f "$target_core" ]; then
      echo "NEW: $core_name"
    elif ! diff -q "$core" "$target_core" >/dev/null 2>&1; then
      echo "MODIFIED: $core_name"
    fi
  fi
done
```

### Step 3: Apply Updates

Update only framework files, preserve all project data:

```bash
cd "$SOURCE_PATH"

# Update agents
for agent in claude/agents/*.md; do
  agent_name=$(basename "$agent")
  target_agent="$TARGET_PATH/.claude/agents/$agent_name"

  if [ ! -f "$target_agent" ] || ! diff -q "$agent" "$target_agent" >/dev/null 2>&1; then
    cp "$agent" "$target_agent"
    echo "✅ Updated: agents/$agent_name"
  fi
done

# Update commands
for cmd in claude/commands/*.md; do
  cmd_name=$(basename "$cmd")
  target_cmd="$TARGET_PATH/.claude/commands/$cmd_name"

  if [ ! -f "$target_cmd" ] || ! diff -q "$cmd" "$target_cmd" >/dev/null 2>&1; then
    cp "$cmd" "$target_cmd"
    echo "✅ Updated: commands/$cmd_name"
  fi
done

# Update prompts
for prompt in knowzcode/prompts/*.md; do
  prompt_name=$(basename "$prompt")
  target_prompt="$TARGET_PATH/knowzcode/prompts/$prompt_name"

  if [ ! -f "$target_prompt" ] || ! diff -q "$prompt" "$target_prompt" >/dev/null 2>&1; then
    mkdir -p "$TARGET_PATH/knowzcode/prompts"
    cp "$prompt" "$target_prompt"
    echo "✅ Updated: prompts/$prompt_name"
  fi
done

# Update core files (SKIP data files like tracker, log, project, environment_context)
for core in knowzcode/knowzcode_loop.md knowzcode/README.md; do
  if [ -f "$core" ]; then
    core_name=$(basename "$core")
    target_core="$TARGET_PATH/$core"

    if [ ! -f "$target_core" ] || ! diff -q "$core" "$target_core" >/dev/null 2>&1; then
      cp "$core" "$target_core"
      echo "✅ Updated: $core_name"
    fi
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Framework files updated"
echo ""
echo "Preserved (not touched):"
echo "  - knowzcode/knowzcode_tracker.md"
echo "  - knowzcode/knowzcode_log.md"
echo "  - knowzcode/knowzcode_project.md"
echo "  - knowzcode/environment_context.md"
echo "  - knowzcode/workgroups/"
echo "  - knowzcode/specs/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

## Files Never Modified

These files are ALWAYS preserved:
- `knowzcode/knowzcode_tracker.md` - WorkGroup tracking
- `knowzcode/knowzcode_log.md` - Event history
- `knowzcode/knowzcode_project.md` - Project metadata
- `knowzcode/environment_context.md` - Environment config
- `knowzcode/workgroups/*.md` - All WorkGroup files
- `knowzcode/specs/*.md` - All specification files
