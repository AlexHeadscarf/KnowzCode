---
description: "Investigate telemetry data from Sentry, App Insights, and other sources"
argument-hint: "<natural language description>"
---

# KnowzCode Telemetry Investigation

Investigate production telemetry to diagnose errors, trace issues, and identify root causes.

**Usage**: `/kc:telemetry "<natural language description>"`

Describe everything in plain English - environment, timeframe, and error context will be extracted automatically.

**Examples**:
```
/kc:telemetry "in staging in the last 20 min, error 500"
/kc:telemetry "NullReferenceException in production over the past hour"
/kc:telemetry "checkout failures in dev since this morning"
/kc:telemetry "slow API responses in user service today"
```

---

## Parameter

| Parameter | Required | Description |
|-----------|----------|-------------|
| `description` | Yes | Natural language query describing what to investigate, including any context about environment, timeframe, etc. |

---

## ⚠️ CRITICAL: You ARE the Orchestrator

**DO NOT delegate to kc-orchestrator. You ARE the persistent orchestrator.**

This command makes YOU the telemetry investigation coordinator. You will:
1. Parse investigation parameters
2. Detect available telemetry sources
3. Spawn telemetry-investigator agent
4. Present synthesized findings
5. Offer next steps (link to `/kc:fix` or `/kc:work`)

**⛔ ANTI-RECURSION RULES:**
- NEVER spawn kc-orchestrator sub-agent
- telemetry-investigator returns results to YOU
- Stay in THIS context until investigation complete

---

## Workflow

### Step 1: Pass Natural Language Query

Pass the user's natural language description directly to the telemetry-investigator agent.

The agent will automatically extract:
- **Environment**: staging/production/dev (from phrases like "in staging", "in prod")
- **Timeframe**: How far back to search (from phrases like "last 20 min", "past 4 hours")
- **Search query**: The error/symptom to investigate (everything else)

### Step 2: Load Configuration and Detect Sources

Before spawning agents, load configuration and verify sources are available AND authenticated.

#### 2.1 Load Telemetry Configuration

Read `knowzcode/telemetry_config.md` to get environment-to-resource mappings:

```bash
# Check if config exists
cat knowzcode/telemetry_config.md 2>/dev/null | head -50
```

**Parse the config** to extract:
- **Sentry**: Enabled status, organization, environment→project mappings
- **App Insights**: Enabled status, subscription, environment→app ID mappings

#### 2.2 Detect Tool Installation

```bash
# Check Sentry CLI installation
which sentry-cli 2>/dev/null && echo "SENTRY_CLI_INSTALLED" || echo "NO_SENTRY_CLI"

# Check Azure CLI + App Insights extension
which az 2>/dev/null && az extension list --query "[?name=='application-insights'].name" -o tsv 2>/dev/null && echo "APPINSIGHTS_INSTALLED" || echo "NO_APPINSIGHTS"
```

#### 2.3 Verify Authentication

For each installed tool, verify it's authenticated:

```bash
# Sentry: Check authentication (quick check)
sentry-cli info 2>&1 | grep -q "Organization" && echo "SENTRY_AUTHENTICATED" || echo "SENTRY_NOT_AUTHENTICATED"

# Azure: Check authentication
az account show --query "name" -o tsv 2>/dev/null && echo "AZURE_AUTHENTICATED" || echo "AZURE_NOT_AUTHENTICATED"
```

#### 2.4 Handle Configuration Issues

**If config doesn't exist or sources not configured:**

```markdown
⚠️ Telemetry not configured.

Run `/kc:telemetry-setup` to:
1. Detect available telemetry tools
2. Verify authentication
3. Auto-discover projects/resources
4. Configure environment mappings

After setup, re-run your telemetry query.
```

**If tools not authenticated:**

```markdown
⚠️ Telemetry tools detected but not authenticated.

Sentry: {status}
App Insights: {status}

Run `/kc:telemetry-setup` to verify authentication and configure sources.
```

**Record available AND authenticated sources** for the telemetry-investigator, along with the environment→resource mappings from config.

### Step 3: Spawn Telemetry Investigator

**REQUIRED**: Delegate to the telemetry-investigator sub-agent using the Task tool.

Pass the configuration data so subagents can use the correct project/app IDs:

```
subagent_type: "kc:telemetry-investigator"
prompt: |
  Investigate telemetry for the following issue.

  **Natural Language Query**: {user's full natural language description}
  **Available Sources**: {detected sources that are installed AND authenticated}

  **Telemetry Configuration**:

  Sentry:
  - Enabled: {true/false}
  - Organization: {org-slug from config}
  - Environment Mappings:
    - production: {project for production}
    - staging: {project for staging}
    - dev: {project for dev}

  App Insights:
  - Enabled: {true/false}
  - Subscription: {subscription ID from config}
  - Environment Mappings:
    - production: {app ID for production}
    - staging: {app ID for staging}
    - dev: {app ID for dev}

  Instructions:
  1. Parse the natural language query to extract environment, timeframe, and search terms
  2. Use the environment to look up the correct project/app ID from config
  3. Spawn available source-specific subagents IN PARALLEL with resolved IDs
  4. Wait for ALL results
  5. Synthesize into unified timeline
  6. Generate root cause hypothesis
  7. Return structured findings
```

### Step 4: Present Findings

Display the synthesized telemetry investigation results:

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ KnowzCode TELEMETRY INVESTIGATION
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Original Query**: {user's natural language description}
**Extracted**:
  - Environment: {extracted env}
  - Timeframe: {extracted timeframe}
  - Search: {extracted search terms}
**Sources Queried**: {list of sources}

## Event Timeline (merged)
| Timestamp | Source | Type | Summary |
|-----------|--------|------|---------|
| ... | ... | ... | ... |

## Root Cause Hypothesis
**Most Likely**: {hypothesis}
**Evidence**: {supporting evidence}
**Confidence**: HIGH/MEDIUM/LOW

## Recommendations
1. {quick fix recommendation}
2. {proper fix recommendation}

---

**Next Steps:**
- `/kc:fix {target}` - Apply a micro-fix
- `/kc:work "Fix {issue}"` - Full implementation workflow
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Integration with Other Commands

This command can be invoked by or hand off to:

| Command | Relationship |
|---------|--------------|
| `/kc:fix` | Hand off quick fixes discovered |
| `/kc:work` | Hand off larger remediation tasks |
| `implementation-lead` | Can call telemetry-investigator during debugging |
| `microfix-specialist` | Can call telemetry-investigator for verification |

---

## Logging

After investigation, log to `knowzcode/knowzcode_log.md`:

```markdown
---
**Type:** Telemetry Investigation
**Timestamp:** {timestamp}
**Query:** {original natural language query}
**Extracted**: env={env}, timeframe={timeframe}
**Sources:** {sources queried}
**Finding:** {one-line root cause summary}
**Status:** Complete
---
```
