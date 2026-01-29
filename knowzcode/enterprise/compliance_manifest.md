# Enterprise Compliance Manifest

**Purpose:** Defines which enterprise guidelines are active and their enforcement level.

---

## Active Guidelines

| Guideline File | Enforcement | Applies To | Active |
|:---------------|:------------|:-----------|:-------|
| security.md | blocking | both | false |
| code-quality.md | advisory | implementation | false |

> **Note:** Set `Active` to `true` to enable a guideline. Guidelines with empty content are skipped.

---

## Enforcement Levels

| Level | Behavior |
|:------|:---------|
| **blocking** | Violations STOP workflow progression. Must be resolved before proceeding. |
| **advisory** | Violations are REPORTED but workflow can continue with documented acceptance. |

---

## Applies-To Scope

| Scope | When Checked | What Is Validated |
|:------|:-------------|:------------------|
| **spec** | Phase 1B (Specification) | Specs address required concerns, ARC criteria included |
| **implementation** | Phase 2B (Verification) | Code meets requirements, patterns compliant |
| **both** | Phase 1B AND Phase 2B | Full coverage at both stages |

---

## Custom Guidelines

Add custom guidelines to `knowzcode/enterprise/guidelines/custom/` following the template in `templates/guideline-template.md`.

To activate a custom guideline, add it to the Active Guidelines table above.

---

## Configuration

```yaml
# Enable/disable compliance checking globally (default: false)
compliance_enabled: false

# Auto-run compliance during /kc:audit when enabled
include_in_audit: true

# Require compliance sign-off before Phase 3 finalization
require_signoff_for_finalization: false

# Show advisory issues in workflow output
show_advisory_issues: true

# Skip guidelines with empty content (default: true)
skip_empty_guidelines: true
```

---

## Usage

### Check Compliance Status
```bash
/kc:compliance           # Full review (spec + implementation)
/kc:compliance spec      # Review specs only
/kc:compliance impl      # Review implementation only
```

### Configure Guidelines
```bash
/kc:compliance configure  # Interactive configuration
```

---

## Adding New Guidelines

1. Create guideline file in `guidelines/` or `guidelines/custom/`
2. Use `templates/guideline-template.md` as starting point
3. Add entry to Active Guidelines table above
4. Run `/kc:compliance` to verify guideline loads correctly
