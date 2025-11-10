---
description: "◆ KnowzCode: Rollback to a previous KnowzCode installation from backup"
argument-hint: "[timestamp]"
---

# ◆ KnowzCode Rollback

Restore KnowzCode framework to a previous state from backup.

**Backup Timestamp**: $ARGUMENTS

## Safety Rollback

This command will:
- ✅ Restore from timestamped backup
- ✅ Verify restoration integrity
- ✅ Preserve current state as emergency backup
- ✅ Validate system after rollback

## Execution

Use the update-coordinator sub-agent to perform safe rollback

Context:
- Backup Timestamp: $ARGUMENTS
- Mode: Restore from backup
- Safety: Create emergency backup of current state first

Instructions:

### Phase 1: Validation

1. **Find backup**:
   ```bash
   timestamp="$ARGUMENTS"
   backup_claude=".claude.backup.$timestamp"
   backup_knowzcode="knowzcode.backup.$timestamp"

   if [ ! -d "$backup_claude" ] || [ ! -d "$backup_knowzcode" ]; then
     echo "ERROR: Backup not found for timestamp: $timestamp"
     echo "Available backups:"
     ls -d .claude.backup.* knowzcode.backup.* 2>/dev/null
     exit 1
   fi
   ```

2. **Verify backup integrity**:
   - Check backup directories are not empty
   - Verify core files exist
   - Confirm backup manifest is readable

### Phase 2: Emergency Backup

Before rollback, save current state:

```bash
emergency_timestamp=$(date -u +"%Y%m%d_%H%M%S")
mkdir -p .claude.emergency.$emergency_timestamp
mkdir -p knowzcode.emergency.$emergency_timestamp
cp -r .claude/* .claude.emergency.$emergency_timestamp/
cp -r knowzcode/* knowzcode.emergency.$emergency_timestamp/

echo "Emergency backup created: $emergency_timestamp"
```

### Phase 3: Restore

1. **Remove current installation**:
   ```bash
   rm -rf .claude/*
   rm -rf knowzcode/*
   ```

2. **Restore from backup**:
   ```bash
   cp -r $backup_claude/* .claude/
   cp -r $backup_knowzcode/* knowzcode/
   ```

3. **Verify restoration**:
   - Check file counts match backup
   - Verify agents present
   - Confirm commands exist
   - Test basic file operations

### Phase 4: Validation and Report

1. **Run validation**:
   - Verify .claude/agents/ populated
   - Check .claude/commands/ exist
   - Confirm knowzcode/ structure intact
   - Test file readability

2. **Report rollback**:

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ ROLLBACK COMPLETED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Restored From**: Backup timestamp {timestamp}
**Emergency Backup**: .claude.emergency.{emergency_timestamp}

## Restored Components

✅ Agents: {count} agents restored
✅ Commands: {count} commands restored
✅ Core docs: {count} files restored
✅ Prompts: {count} prompts restored

## Validation

✅ All components present
✅ Agents have valid format
✅ Commands functional
✅ File structure intact

## Emergency Backup

Your pre-rollback state saved at:
- .claude.emergency.{emergency_timestamp}/
- knowzcode.emergency.{emergency_timestamp}/

To re-restore if needed: `/kc-rollback emergency.{emergency_timestamp}`

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**System restored to previous state!**
```

### Error Handling

If rollback fails:

```markdown
⚠️ ROLLBACK FAILED

Error: {error_message}

Status: Emergency backup preserved at:
- .claude.emergency.{emergency_timestamp}/

Manual Recovery:
1. Your current state is in .claude.emergency.{timestamp}/
2. Original backup is in .claude.backup.{timestamp}/
3. Manually restore: cp -r .claude.backup.{timestamp}/* .claude/

Contact support if needed.
```

## Usage

**List available backups**:
```bash
ls -d .claude.backup.* knowzcode.backup.*
```

**Rollback to specific backup**:
```bash
/kc-rollback 20250104_200000
```

**Rollback to emergency backup**:
```bash
/kc-rollback emergency.20250104_203000
```
