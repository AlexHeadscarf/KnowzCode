---
description: "Execute the KCv2.0 micro-fix workflow"
argument-hint: "<target> <summary>"
---

# KnowzCode Micro-Fix

Execute a targeted micro-fix within the KnowzCode v2.0 framework.

**Usage**: `/knowzcode:fix <target> <summary>`
**Example**: `/knowzcode:fix src/auth/login.ts "Fix null reference in password validation"`

---

## Scope Guard

**This command is for micro-fixes only.** Before proceeding, verify:

| Criteria | Required |
|----------|----------|
| Change affects ≤1 file | ✓ |
| Change is <50 lines | ✓ |
| No ripple effects to other components | ✓ |
| No new dependencies introduced | ✓ |
| Existing tests cover the change area | ✓ |

**If ANY criteria fails**: Stop and suggest `/knowzcode:work` for full orchestration.

---

## Workflow Steps

### 1. Validate Scope
- Confirm the fix meets micro-fix criteria above
- If scope exceeds limits, redirect to `/knowzcode:work`

### 2. Load Context
- Read the target file to understand current implementation
- Identify existing test coverage for the affected code

### 3. Implement Fix
- Apply the minimal change required
- Follow existing code patterns and style

### 4. Verification Loop (MANDATORY)

**⛔ DO NOT skip verification. DO NOT claim "done" without passing tests.**

```
REPEAT until all checks pass:
  1. Run relevant tests:
     - Unit tests covering the changed code
     - Integration tests if the fix touches boundaries
     - E2E tests if the fix affects user-facing behavior

  2. If tests FAIL:
     - Analyze failure
     - Apply corrective fix
     - RESTART verification from step 1

  3. If tests PASS:
     - Run static analysis / linter
     - If issues found, fix and RESTART from step 1

  4. All checks pass → Exit loop
```

**Test Selection Guidance:**
| Fix Type | Required Tests |
|----------|---------------|
| Logic bug in function | Unit tests for that function |
| API endpoint fix | Unit + Integration tests |
| UI/UX fix | Unit + E2E tests |
| Configuration fix | Integration tests |
| Data handling fix | Unit + Integration tests |

### 5. Log and Commit
- Log MicroFix entry in `knowzcode/knowzcode_log.md`
- Include verification evidence (which tests passed)
- Commit with `fix:` prefix

---

## Arguments

- `target` (required): NodeID or file path that requires the micro-fix
- `summary` (required): One-line description of the requested change

## Example Usage

```
/knowzcode:fix src/auth/login.ts "Fix null reference in password validation"
/knowzcode:fix NODE_AUTH_123 "Update error message formatting"
```

## Execution

**REQUIRED**: Delegate to the microfix-specialist sub-agent using the Task tool.

```
Use the microfix-specialist sub-agent to execute a targeted micro-fix

Context:
- Target: <target from arguments>
- Summary: <summary from arguments>
- Mode: Micro-fix with verification loop

Instructions:
1. Validate scope meets micro-fix criteria
2. Implement the minimal fix
3. Execute verification loop until all tests pass
4. Log outcome with test evidence
5. Commit with fix: message
```

## Context Files

- knowzcode/automation_manifest.md
- knowzcode/prompts/KCv2.0__Execute_Micro_Fix.md
