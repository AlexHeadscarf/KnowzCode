---
description: "Run KnowzCode audit workflows (spec, architecture, security, integration)"
argument-hint: "[audit_type]"
---

# Run KnowzCode Audit

Run specialized audit workflows.

**Usage**: `/knowzcode:audit [audit_type]`
**Example**: `/knowzcode:audit spec` or `/knowzcode:audit security`

**Audit Type**: $ARGUMENTS

## Audit Types

- **spec** → Specification quality audit
- **architecture** → Architecture health review
- **security** → Security vulnerability audit
- **integration** → Holistic integration audit

## Execution

Use the kc-orchestrator sub-agent to coordinate the audit workflow

Context:
- Audit Type: $ARGUMENTS
- Mode: Quality assurance and validation

Instructions for orchestrator:
1. Determine the audit type from arguments
2. Load relevant KnowzCode context files
3. Delegate to the appropriate audit sub-agent:
   - spec → spec-quality-auditor
   - architecture → architecture-reviewer
   - security → security-officer
   - integration → holistic-auditor
4. Present audit findings to the user
5. Update knowzcode_log.md with audit results

The orchestrator will coordinate with the audit-specific sub-agent.
