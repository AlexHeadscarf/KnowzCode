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

### Step 1: Determine Audit Scope

**PARALLEL is the DEFAULT. SEQUENTIAL is the EXCEPTION.**

Parse the argument to identify the audit type:

**If NO argument provided → PARALLEL FULL AUDIT (DEFAULT):**
- DO NOT ask the user which audit to run
- SPAWN ALL FOUR audit agents IN PARALLEL
- Present consolidated results

**If argument provided (e.g., `spec`, `security`):**
- Run only the specified audit type
- Present single audit results

### Step 2: Load Context

Read relevant KnowzCode context files:
- `knowzcode/knowzcode_tracker.md` - Current NodeID statuses
- `knowzcode/knowzcode_architecture.md` - Architecture overview
- `knowzcode/knowzcode_project.md` - Project context

---

### Parallel Full Audit (DEFAULT when no argument)

**SPAWN ALL FOUR audit agents IN PARALLEL in a SINGLE response:**

```
# Task 1: Spec Quality Audit
subagent_type: "spec-quality-auditor"
prompt: |
  Perform comprehensive specification quality audit.

  Context:
  - Audit Type: Specification Quality (part of parallel full audit)
  - Specs Location: knowzcode/specs/

  Instructions:
  1. Load all spec files from knowzcode/specs/
  2. For each spec, validate completeness and quality
  3. Score each spec
  4. Identify gaps and improvement areas

  Return: Spec quality report with scores and gaps

# Task 2: Architecture Audit (PARALLEL with Task 1)
subagent_type: "architecture-reviewer"
prompt: |
  Perform architecture health review.

  Context:
  - Audit Type: Architecture Health (part of parallel full audit)
  - Architecture Doc: knowzcode/knowzcode_architecture.md

  Instructions:
  1. Load architecture documentation
  2. Analyze component relationships and dependency health
  3. Identify drift and inconsistencies

  Return: Architecture health report with findings

# Task 3: Security Audit (PARALLEL with Tasks 1 & 2)
subagent_type: "security-officer"
prompt: |
  Perform security vulnerability audit.

  Context:
  - Audit Type: Security Vulnerability Scan (part of parallel full audit)

  Instructions:
  1. Scan codebase for common vulnerabilities (OWASP Top 10)
  2. Check dependencies for known vulnerabilities
  3. Assess severity and risk for each finding

  Return: Security audit report with vulnerabilities and severity

# Task 4: Integration Audit (PARALLEL with Tasks 1, 2 & 3)
subagent_type: "holistic-auditor"
prompt: |
  Perform holistic integration audit.

  Context:
  - Audit Type: Holistic Integration (part of parallel full audit)

  Instructions:
  1. Analyze cross-component integration
  2. Check for orphaned code and inconsistent patterns
  3. Verify consistency across specs, implementation, and docs

  Return: Integration audit report with consistency scores
```

**CRITICAL**: Issue ALL FOUR Task tool calls in a SINGLE response. Do NOT wait for each to complete.

**When ALL audit agents return:**
Present consolidated results:
```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode COMPREHENSIVE AUDIT RESULTS
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Timestamp**: {timestamp}
**Audits Completed**: 4 (parallel execution)

## Summary Scores
| Audit Type | Health Score | Critical Issues |
|------------|--------------|-----------------|
| Spec Quality | {score}% | {count} |
| Architecture | {score}% | {count} |
| Security | {score}% | {count} |
| Integration | {score}% | {count} |

## Critical Issues (All Audits)
{consolidated list of critical issues, sorted by severity}

## Detailed Reports

### Spec Quality Audit
{findings from spec-quality-auditor}

### Architecture Audit
{findings from architecture-reviewer}

### Security Audit
{findings from security-officer}

### Integration Audit
{findings from holistic-auditor}

## Prioritized Recommendations
{combined, deduplicated action items sorted by priority}
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Individual Audit Types (when argument provided)

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
1. Checking if argument provided
2. **If NO argument → SPAWN ALL FOUR audit agents IN PARALLEL (DEFAULT)**
3. If argument provided → Spawn only the specified audit agent
4. Loading relevant context
5. Presenting formatted results to user (consolidated if parallel)
6. Logging the audit event

**PARALLEL is the DEFAULT. SEQUENTIAL is the EXCEPTION.**

**NEVER spawn kc-orchestrator. Execute audits directly.**
