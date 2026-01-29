---
description: "Run enterprise compliance review against specs and/or implementation"
argument-hint: "[scope]"
---

# Enterprise Compliance Review

Run compliance review against enterprise guidelines. This is an **optional** feature - if not configured, the command reports that gracefully.

**Usage**: `/kc:compliance [scope]`

**Scopes**:
- (none) - Full review (spec + implementation)
- `spec` - Review specifications only
- `impl` - Review implementation only
- `configure` - Show configuration guidance

**Examples**:
```
/kc:compliance                    # Full review
/kc:compliance spec               # Specs only
/kc:compliance impl               # Implementation only
/kc:compliance configure          # Show setup guidance
```

---

## Execution Protocol

### Step 1: Check Enterprise Configuration

```
IF knowzcode/enterprise/ directory does not exist:
  INFORM: "Enterprise compliance not configured."
  INFORM: "Run /kc:init and select enterprise setup, or create knowzcode/enterprise/ manually."
  STOP

READ knowzcode/enterprise/compliance_manifest.md

IF compliance_enabled: false:
  INFORM: "Enterprise compliance is disabled in compliance_manifest.md"
  INFORM: "Set compliance_enabled: true to enable compliance reviews."
  STOP
```

### Step 2: Handle Configure Scope

```
IF scope == "configure":
  DISPLAY current configuration from compliance_manifest.md
  LIST active guidelines with enforcement levels
  SHOW guidance for adding/editing guidelines
  STOP
```

### Step 3: Determine Review Scope

```
scope = argument OR "full"

IF scope == "spec":
  INFORM: "Reviewing specifications only..."
  filter_applies_to = ['spec', 'both']
  targets = knowzcode/specs/*.md

ELSE IF scope == "impl":
  INFORM: "Reviewing implementation only..."
  filter_applies_to = ['implementation', 'both']
  targets = source code files

ELSE (scope == "full"):
  INFORM: "Running full compliance review..."
  filter_applies_to = ['spec', 'implementation', 'both']
  targets = specs AND source code
```

### Step 4: Spawn Compliance Reviewer

```
Task(enterprise-compliance-reviewer, "
  Perform enterprise compliance review.

  Scope: {scope}
  Filter: applies_to IN {filter_applies_to}

  Instructions:
  1. Load compliance_manifest.md
  2. Load active guidelines matching filter
  3. Review targets against requirements
  4. Classify issues by enforcement level
  5. Return structured compliance report

  Handle gracefully:
  - Empty guideline files (skip)
  - Missing guideline files (skip with warning)
  - No requirements found (report clean)
")
```

### Step 5: Present Results

Display the compliance report from the reviewer agent.

```markdown
## Enterprise Compliance Report

**Scope:** {scope}
**Guidelines Checked:** {count}
**Timestamp:** {timestamp}

### Summary

| Status | Count |
|:-------|:------|
| PASSED | {n} |
| BLOCKING | {n} |
| ADVISORY | {n} |

### Blocking Issues

{list of blocking violations with remediation}

### Advisory Issues

{list of advisory violations with recommendations}

### Next Steps

- Fix blocking issues: `/kc:work "Fix compliance: {issue_id}"`
- Re-run: `/kc:compliance`
```

---

## Integration Points

### Called from /kc:audit

When `/kc:audit` includes compliance (if `include_in_audit: true` in manifest):
- Runs as parallel audit alongside other audit types
- Results merged into unified audit report

### Called from spec-chief (Phase 1B)

When specs are drafted, spec-chief may invoke compliance review:
- Only if `compliance_enabled: true`
- Filters guidelines where `applies_to: spec OR both`
- Gates on blocking issues before presenting specs for approval

### Called from arc-auditor (Phase 2B)

When Phase 2B verification runs, arc-auditor may invoke compliance:
- Only if `compliance_enabled: true`
- Filters guidelines where `applies_to: implementation OR both`
- Results merged into Phase 2B audit report

---

## Notes

- This feature is **optional** - works gracefully when not configured
- Empty guideline files are skipped (not errors)
- Blocking issues must be resolved before workflow progression
- Advisory issues are reported but don't block workflow
