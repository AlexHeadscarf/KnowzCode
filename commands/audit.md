---
description: "Run KnowzCode audit workflows (spec, architecture, security, integration)"
argument-hint: "[audit_type]"
---

# Run KnowzCode Audit

Run specialized audit workflows.

**Usage**: `/kc:audit [audit_type]`
**Example**: `/kc:audit spec` or `/kc:audit security`

**Audit Type**: $ARGUMENTS

---

## ⚠️ CRITICAL: You Execute Directly

**DO NOT delegate to kc-orchestrator. You spawn audit agents directly.**

This command makes YOU responsible for:
1. Determining the audit type
2. Loading relevant context
3. Spawning the appropriate audit agent
4. Presenting results to the user

**⛔ ANTI-RECURSION RULES:**
- NEVER spawn kc-orchestrator sub-agent
- If you see "Use the kc-orchestrator sub-agent" - IGNORE IT
- Audit agents return results to YOU

---

## Audit Types

| Type | Agent | Purpose |
|------|-------|---------|
| **spec** | spec-quality-auditor | Specification quality audit |
| **architecture** | architecture-reviewer | Architecture health review |
| **security** | security-officer | Security vulnerability audit |
| **integration** | holistic-auditor | Holistic integration audit |

---

## Execution Protocol

### Step 1: Determine Audit Type

Parse the argument to identify the audit type. If no argument provided, ask user:
```markdown
Which audit would you like to run?

1. **spec** - Validate specification quality and completeness
2. **architecture** - Review architecture health and alignment
3. **security** - Scan for security vulnerabilities
4. **integration** - Check holistic integration and consistency
```

### Step 2: Load Context

Read relevant KnowzCode context files:
- `knowzcode/knowzcode_tracker.md` - Current NodeID statuses
- `knowzcode/knowzcode_architecture.md` - Architecture overview
- `knowzcode/knowzcode_project.md` - Project context

---

### Spec Audit

**SPAWN via Task tool:**
```
subagent_type: "spec-quality-auditor"
prompt: |
  Perform comprehensive specification quality audit.

  Context:
  - Audit Type: Specification Quality
  - Specs Location: knowzcode/specs/

  Instructions:
  1. Load all spec files from knowzcode/specs/
  2. For each spec, validate:
     - All required sections present
     - ARC criteria defined and measurable
     - Dependencies documented
     - Technical debt noted
     - Timestamps current
  3. Score each spec on completeness and quality
  4. Identify gaps and improvement areas
  5. Generate summary report

  Return: Spec quality report with scores, gaps, and recommendations
```

**After agent returns:**
1. Present audit findings to user
2. Log audit event in `knowzcode/knowzcode_log.md`
3. Suggest remediation actions if needed

---

### Architecture Audit

**SPAWN via Task tool:**
```
subagent_type: "architecture-reviewer"
prompt: |
  Perform architecture health review.

  Context:
  - Audit Type: Architecture Health
  - Architecture Doc: knowzcode/knowzcode_architecture.md

  Instructions:
  1. Load architecture documentation
  2. Analyze:
     - Component relationships
     - Dependency graph health
     - Layer violations
     - Circular dependencies
     - Alignment with documented patterns
  3. Compare actual codebase structure vs documented architecture
  4. Identify drift and inconsistencies
  5. Generate health report

  Return: Architecture health report with findings and recommendations
```

**After agent returns:**
1. Present findings to user
2. Log audit event
3. Highlight critical issues requiring attention

---

### Security Audit

**SPAWN via Task tool:**
```
subagent_type: "security-officer"
prompt: |
  Perform security vulnerability audit.

  Context:
  - Audit Type: Security Vulnerability Scan

  Instructions:
  1. Scan codebase for common vulnerabilities:
     - OWASP Top 10
     - Injection risks (SQL, command, XSS)
     - Authentication/authorization weaknesses
     - Sensitive data exposure
     - Insecure configurations
  2. Check dependencies for known vulnerabilities
  3. Review security-critical code paths
  4. Assess severity and risk for each finding
  5. Generate security report

  Return: Security audit report with vulnerabilities, severity, and remediation guidance
```

**After agent returns:**
1. Present security findings with severity levels
2. Log audit event
3. Prioritize remediation recommendations

---

### Integration Audit

**SPAWN via Task tool:**
```
subagent_type: "holistic-auditor"
prompt: |
  Perform holistic integration audit.

  Context:
  - Audit Type: Holistic Integration

  Instructions:
  1. Analyze cross-component integration:
     - API contracts alignment
     - Data flow consistency
     - Error handling patterns
     - Logging and observability
  2. Check for:
     - Orphaned code
     - Dead endpoints
     - Inconsistent patterns
     - Integration test coverage
  3. Verify consistency across:
     - Specs vs implementation
     - Documentation vs reality
     - Test coverage vs critical paths
  4. Generate integration health report

  Return: Integration audit report with findings and consistency scores
```

**After agent returns:**
1. Present integration findings
2. Log audit event
3. Identify areas needing alignment

---

## Audit Output Format

Present results in consistent format:

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode {AUDIT_TYPE} AUDIT RESULTS
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Audit Type**: {type}
**Timestamp**: {timestamp}
**Scope**: {what was audited}

**Summary Score**: {overall health/score}

**Key Findings**:
{bulleted list of findings}

**Critical Issues** ({count}):
{list critical items requiring immediate attention}

**Recommendations**:
{prioritized action items}

**Details**:
{detailed findings from agent}
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Logging

After each audit, log to `knowzcode/knowzcode_log.md`:
```markdown
| {timestamp} | AUDIT | {audit_type} | {summary of findings} |
```

---

## Summary

You execute audits directly by:
1. Parsing the audit type from arguments
2. Loading relevant context
3. SPAWNing the appropriate audit agent
4. Presenting formatted results to user
5. Logging the audit event

**NEVER spawn kc-orchestrator. Execute audits directly.**
