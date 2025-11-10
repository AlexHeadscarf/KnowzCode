---
description: "◆ KnowzCode: Execute the KCv2.0 micro-fix workflow"
argument-hint: "<target> <summary>"
---

# ◆ KnowzCode Micro-Fix

Execute a targeted micro-fix within the KnowzCode v2.0 framework.

## Workflow Steps

1. **Validate Environment** - Ensure prerequisites are met
2. **Load Core Context** - Load core KnowzCode documentation
3. **Run Microfix Specialist** - Delegate to specialized agent
4. **Execute Fix** - Apply the micro-fix using KCv2.0__Execute_Micro_Fix.md prompt
5. **Update Caches** - Refresh internal state

## Arguments

- `target` (required): NodeID or file path that requires the micro-fix
- `summary` (required): One-line description of the requested change

## Example Usage

```
/kc-microfix src/auth/login.ts "Fix null reference in password validation"
/kc-microfix NODE_AUTH_123 "Update error message formatting"
```

## Context Files

- knowzcode/automation_manifest.md
- knowzcode/prompts/KCv2.0__Execute_Micro_Fix.md
