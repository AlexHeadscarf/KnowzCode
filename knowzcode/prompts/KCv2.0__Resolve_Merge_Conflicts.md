---
prompt_id: KCv2.0__Resolve_Merge_Conflicts
version: 1.0
classification: Utility
description: Auto-resolve merge conflicts in KnowzCode tracker and log files from parallel WorkGroups
---

# ◆ KnowzCode v2.0: Merge Conflict Resolution

You are executing the **KnowzCode Merge Conflict Resolver** workflow. Your task is to automatically resolve merge conflicts in `knowzcode_tracker.md` and `knowzcode_log.md` that occurred when merging parallel WorkGroups.

## Context

When multiple developers work on different features in parallel (different WorkGroups), they each:
1. Update tracker rows for their NodeIDs
2. Prepend log entries for their WorkGroup completion
3. Commit to separate feature branches

When these branches merge, git creates conflicts because:
- **Tracker**: Both branches modified the table (different rows, but same file location)
- **Log**: Both branches prepended entries at the same marker line

These conflicts are **expected and safe to auto-resolve** when the NodeIDs are different.

## Your Task

### Step 1: Validate Conflict Safety

Check if auto-resolution is safe:

```bash
# Check tracker for genuine conflicts (same NodeID in both branches)
git diff --name-only --diff-filter=U
```

Read the conflict sections in both files:

1. **Tracker conflicts**: Verify that different NodeIDs were modified (safe to merge)
2. **Log conflicts**: Verify that different WorkGroupIDs are present (safe to merge)

**STOP and warn the user if:**
- The SAME NodeID was modified in both branches (genuine conflict)
- The SAME WorkGroupID appears in both logs (duplicate work)
- Conflicts exist in files other than tracker/log

### Step 2: Create Backups

Before modifying, create safety backups:

```bash
cp knowzcode_tracker.md knowzcode_tracker.md.backup
cp knowzcode_log.md knowzcode_log.md.backup
```

### Step 3: Resolve Tracker Conflicts

Extract and merge the tracker table:

1. **Parse both sides of the conflict**:
   - Extract rows from HEAD (current branch)
   - Extract rows from incoming branch
   - Combine all rows, removing duplicates (same NodeID = keep newer status)

2. **Recalculate progress**:
   ```
   Progress = (VERIFIED_count / total_NodeID_count) * 100
   ```

3. **Reconstruct the file**:
   - Keep header sections intact
   - Insert merged table
   - Remove conflict markers

**Expected output structure**:
```markdown
# ◆ KnowzCode - Status Map

---
**Progress: XX%**
---

| Status | WorkGroupID | Node ID | Label | Dependencies | Spec Link |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [All rows from both branches, no duplicates] |
```

### Step 4: Resolve Log Conflicts

Extract and merge log entries:

1. **Parse both sides of the conflict**:
   - Extract all log entries from HEAD
   - Extract all log entries from incoming branch
   - Remove duplicates (same WorkGroupID + Timestamp)

2. **Sort by timestamp** (newest first):
   - Parse timestamps from each entry
   - Sort entries in descending chronological order

3. **Reconstruct the file**:
   - Keep the `[NEWEST ENTRIES APPEAR HERE]` marker
   - Insert sorted entries below marker
   - Remove conflict markers

**Expected output structure**:
```markdown
# ◆ KnowzCode - Operational Record

---
**[NEWEST ENTRIES APPEAR HERE - DO NOT REMOVE THIS MARKER]**
---
**Type:** ARC-Completion
**Timestamp:** 2025-01-09T15:45:00Z
**WorkGroupID:** kc-feat-20250109-154500
**NodeID(s):** EmailService
**Details:** [...]
---
**Type:** ARC-Completion
**Timestamp:** 2025-01-09T14:30:00Z
**WorkGroupID:** kc-feat-20250109-143000
**NodeID(s):** UserProfile
**Details:** [...]
---
[Older entries...]
```

### Step 5: Stage and Report

After resolution:

```bash
git add knowzcode_tracker.md knowzcode_log.md
```

**Report to user**:

```
✓ Merge conflicts resolved successfully!

Tracker changes:
- Merged X NodeIDs from both branches
- Progress updated: XX%
- No duplicate NodeIDs found

Log changes:
- Merged Y log entries from both branches
- Sorted by timestamp (newest first)
- No duplicate WorkGroupIDs found

Backup files created:
- knowzcode_tracker.md.backup
- knowzcode_log.md.backup

Review the changes:
  git diff --staged knowzcode_tracker.md
  git diff --staged knowzcode_log.md

Complete the merge:
  git commit -m "Merge WorkGroups: [list WorkGroupIDs]"
```

## Error Handling

### If Genuine Conflict Detected

```
⚠️  Manual review required!

The following NodeIDs were modified in BOTH branches:
- UserAuth (modified in both WorkGroups)

This is a genuine conflict that needs manual resolution.
Auto-merge aborted.

Please review the changes:
  git diff HEAD knowzcode_tracker.md
  git diff MERGE_HEAD knowzcode_tracker.md

Resolve manually and commit.
```

### If No Conflicts Found

```
ℹ️  No merge conflicts detected in tracker or log files.

Current merge status:
  git status

If you expected conflicts, ensure you're in a merge state:
  git merge <branch-name>
```

## Implementation Notes

**Parsing strategy**:
- Use `<<<<<<< HEAD`, `=======`, `>>>>>>> branch-name` markers to split sections
- Preserve markdown table structure (alignment, pipes, headers)
- Handle multi-line log entries (entries separated by `---`)

**Deduplication logic**:
- Tracker: Same NodeID = keep the one with higher status (VERIFIED > WIP > TODO)
- Log: Same WorkGroupID + Timestamp = keep one instance

**Safety checks**:
- Validate markdown table structure after merge
- Ensure no orphaned conflict markers remain
- Verify log entry structure is intact

## Success Criteria

- ✓ All conflict markers removed
- ✓ Tracker table is valid markdown
- ✓ All NodeID changes from both branches are present
- ✓ Progress percentage is accurate
- ✓ Log entries are chronologically sorted
- ✓ All log entries from both branches are present
- ✓ Files are staged for commit
- ✓ Backup files created

---

**Proceed with the merge conflict resolution workflow. Start with Step 1: Validate Conflict Safety.**
