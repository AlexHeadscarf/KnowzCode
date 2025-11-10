---
description: "◆ KnowzCode: Auto-resolve merge conflicts in tracker and log files"
argument-hint: ""
---

# ◆ KnowzCode Merge Conflict Resolver

Automatically resolve common merge conflicts in KnowzCode state files when merging parallel WorkGroups.

## What This Resolves

This command handles the standard merge conflicts that occur when two feature branches (WorkGroups) are merged:

1. **Tracker conflicts** (`knowzcode_tracker.md`):
   - Multiple sessions updating different NodeID rows
   - Progress percentage conflicts
   - **Resolution**: Keep all changes from both branches, recalculate progress

2. **Log conflicts** (`knowzcode_log.md`):
   - Multiple sessions prepending entries at the same marker
   - **Resolution**: Keep all entries, sort by timestamp (newest first)

## When to Use

Run this command when:
- Git shows merge conflicts in `knowzcode_tracker.md` or `knowzcode_log.md`
- You're merging two feature branches that worked on different NodeIDs
- The conflict markers show different NodeIDs or log entries (not the same NodeID modified in both branches)

## When NOT to Use

Do NOT use this command if:
- Both branches modified the SAME NodeID (genuine conflict - needs manual review)
- Conflicts are in other files (specs, architecture, etc.)
- You need to customize the merge resolution

## Usage

```bash
# After git merge shows conflicts
/kc-resolve-merge

# The command will:
# ✓ Detect conflicts in tracker and log
# ✓ Auto-resolve by keeping all changes
# ✓ Sort log entries by timestamp
# ✓ Recalculate progress percentage
# ✓ Stage the resolved files
# ✓ Show summary of resolution
```

## Example Scenario

```bash
# Session 1 (feature/user-profiles branch)
/kc "Add user profile editing"
git commit -am "feat: Complete UserProfile WorkGroup"

# Session 2 (feature/notifications branch)
/kc "Add email notifications"
git commit -am "feat: Complete EmailService WorkGroup"

# Merge both
git checkout main
git merge feature/user-profiles  # No conflict
git merge feature/notifications  # CONFLICT in tracker and log

# Auto-resolve
/kc-resolve-merge

# Conflicts resolved! ✓
git commit -m "Merge both WorkGroups"
```

## What Gets Changed

### Tracker Resolution:
- Merges all NodeID rows from both branches
- Removes duplicate rows (same NodeID)
- Recalculates progress percentage: `(VERIFIED_count / total_count) * 100`
- Preserves table structure

### Log Resolution:
- Keeps all log entries from both branches
- Sorts entries by timestamp (newest first)
- Preserves the `[NEWEST ENTRIES APPEAR HERE]` marker
- Maintains log entry structure

## Safety

- Creates backup files before modification (`.backup` extension)
- Only modifies files with conflict markers
- Shows diff before staging
- Allows manual review before committing

## Manual Review Recommended

Even after auto-resolution, review the changes:

```bash
git diff --staged knowzcode_tracker.md
git diff --staged knowzcode_log.md
```

Ensure both WorkGroups' changes are present and correctly merged.

---

## Implementation

This command executes the `KCv2.0__Resolve_Merge_Conflicts.md` prompt located in `knowzcode/prompts/`.
