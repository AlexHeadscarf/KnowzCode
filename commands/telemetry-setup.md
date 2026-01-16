---
description: "Configure telemetry sources (Sentry, App Insights) for /kc:telemetry"
argument-hint: "[sentry|appinsights|all]"
---

# KnowzCode Telemetry Setup

Configure telemetry sources for `/kc:telemetry` investigations.

**Usage**: `/kc:telemetry-setup [scope]`

| Scope | Description |
|-------|-------------|
| `all` | Configure all detected sources (default) |
| `sentry` | Configure Sentry only |
| `appinsights` | Configure Azure App Insights only |

**Examples**:
```
/kc:telemetry-setup
/kc:telemetry-setup sentry
/kc:telemetry-setup appinsights
```

---

## Workflow

### Step 1: Detect Available Tools

Check which telemetry tools are available. **CLI is preferred when properly configured; MCP is a fallback.**

#### 1.1 Check Sentry CLI (Preferred)

```bash
# Check Sentry CLI installation
which sentry-cli 2>/dev/null && echo "SENTRY_CLI_INSTALLED" || echo "NO_SENTRY_CLI"
```

If installed, verify authentication:
```bash
# Verify Sentry CLI is authenticated
sentry-cli info 2>&1 | grep -q "Organization" && echo "SENTRY_AUTHENTICATED" || echo "SENTRY_NOT_AUTHENTICATED"
```

**If Sentry CLI installed + authenticated → use CLI method, skip MCP check for Sentry.**

#### 1.2 Check Sentry MCP (Fallback)

**Only check MCP if CLI is not available or not authenticated.**

Attempt to detect MCP by checking if Sentry MCP tools respond. The agent should:
1. Try to use `sentry_search_issues` or `mcp__sentry__search_issues` with a minimal test query
2. If it responds (even with "no results") → MCP is available
3. If it errors with "tool not found" → MCP not configured

**If MCP available → use MCP method for Sentry.**

#### 1.3 Check Azure CLI + App Insights

```bash
# Check Azure CLI
which az 2>/dev/null && echo "AZURE_CLI_INSTALLED" || echo "NO_AZURE_CLI"

# Check App Insights extension
az extension list --query "[?name=='application-insights'].name" -o tsv 2>/dev/null || echo "NO_APPINSIGHTS_EXTENSION"
```

**Report detected tools and methods** before proceeding:

```markdown
**Detection Results:**

| Source | Status | Method |
|--------|--------|--------|
| Sentry | ✓ Available | CLI (preferred) |
| App Insights | ✓ Available | CLI |

or

| Source | Status | Method |
|--------|--------|--------|
| Sentry | ✓ Available | MCP (CLI not configured) |
| App Insights | ✗ Not available | - |
```

### Step 2: Verify Authentication

For each installed tool, verify authentication:

```bash
# Sentry: Check if authenticated
sentry-cli info 2>&1 | head -5

# Azure: Check if authenticated
az account show --query "{name:name, user:user.name}" -o table 2>&1 | head -5
```

**If not authenticated**, provide setup instructions and stop for that source:

**For Sentry**:
```markdown
⚠️ Sentry CLI is installed but not authenticated.

Run these commands to authenticate:
\`\`\`bash
sentry-cli login
# OR set the auth token directly
export SENTRY_AUTH_TOKEN="your-token-here"
\`\`\`

Then run `/kc:telemetry-setup sentry` again.
```

**For Azure**:
```markdown
⚠️ Azure CLI is installed but not authenticated.

Run these commands to authenticate:
\`\`\`bash
az login
az extension add --name application-insights  # If not installed
\`\`\`

Then run `/kc:telemetry-setup appinsights` again.
```

### Step 3: Auto-Discover Resources

For each authenticated source, discover available resources:

**Sentry**:
```bash
# List organizations
sentry-cli organizations list 2>/dev/null

# List projects (for each org)
sentry-cli projects list --org {org-slug} 2>/dev/null
```

**Azure App Insights**:
```bash
# List all App Insights resources
az monitor app-insights component list \
  --query "[].{name:name, appId:appId, resourceGroup:resourceGroup}" \
  -o table 2>/dev/null
```

**Report discovered resources** in a clear format.

### Step 4: Interactive Configuration

Present discovered resources and ask user to map environments:

```markdown
## Discovered Resources

### Sentry Projects
| # | Organization | Project |
|---|--------------|---------|
| 1 | my-company | backend-api |
| 2 | my-company | frontend-web |
| 3 | my-company | worker-service |

### App Insights Resources
| # | Name | App ID | Resource Group |
|---|------|--------|----------------|
| 1 | appinsights-prod | abc-123-def | rg-production |
| 2 | appinsights-staging | ghi-456-jkl | rg-staging |
| 3 | appinsights-dev | mno-789-pqr | rg-development |

---

**Please map each environment to a resource:**

For Sentry:
- Production → (enter project number or skip)
- Staging → (enter project number or skip)
- Dev → (enter project number or skip)

For App Insights:
- Production → (enter resource number or skip)
- Staging → (enter resource number or skip)
- Dev → (enter resource number or skip)
```

Use the AskUserQuestion tool to collect mappings if multiple resources exist.

### Step 5: Save Configuration

Update `knowzcode/telemetry_config.md` with the discovered and mapped values.

**Include the detection method** (cli or mcp) for each source.

**Example result** (CLI method):

```markdown
## Sentry

| Field | Value |
|-------|-------|
| Enabled | true |
| Method | cli |
| Organization | my-company |

### Environment Mapping

| Environment | Project |
|-------------|---------|
| production | my-company/backend-api |
| staging | my-company/backend-staging |
| dev | my-company/backend-dev |

## Azure Application Insights

| Field | Value |
|-------|-------|
| Enabled | true |
| Subscription | 12345678-1234-1234-1234-123456789012 |
| Resource Group | rg-production |

### Environment Mapping

| Environment | App Name | App ID |
|-------------|----------|--------|
| production | appinsights-prod | abc-123-def |
| staging | appinsights-staging | ghi-456-jkl |
| dev | appinsights-dev | mno-789-pqr |
```

**Example result** (MCP method - when CLI not available):

```markdown
## Sentry

| Field | Value |
|-------|-------|
| Enabled | true |
| Method | mcp |
| Organization | my-company |

### Environment Mapping

| Environment | Project |
|-------------|---------|
| production | my-company/backend-api |
| staging | my-company/backend-staging |
| dev | my-company/backend-dev |
```

### Step 6: Confirm Setup

After saving, show a summary **including the detection method**:

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ TELEMETRY CONFIGURATION COMPLETE
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Sentry**: ✓ Configured
- Method: CLI (preferred)
- Organization: my-company
- Environments mapped: production, staging, dev

**App Insights**: ✓ Configured
- Method: CLI
- Subscription: my-subscription
- Environments mapped: production, staging, dev

**Configuration saved to**: knowzcode/telemetry_config.md

You can now run:
  /kc:telemetry "error 500 in staging in the last hour"

The telemetry investigator will automatically use the correct
project/resource for the specified environment.
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Error Handling

### No Tools Installed

If NEITHER CLI nor MCP is available for a source, ask which to install:

```markdown
⚠️ No Sentry connection detected.

Would you like to set up Sentry? Choose an option:

**Option 1: Sentry CLI** (Recommended)
- Better error details and breadcrumbs
- Full issue management capabilities
\`\`\`bash
npm install -g @sentry/cli
sentry-cli login
\`\`\`

**Option 2: Sentry MCP**
- Configure Sentry MCP server in Claude Code settings
- Tools: `sentry_search_issues`, `sentry_get_issue_details`, `sentry_list_events`
- See: https://github.com/modelcontextprotocol/servers/tree/main/sentry

---

⚠️ No Azure App Insights connection detected.

**For Azure App Insights** (CLI only):
\`\`\`bash
# Install Azure CLI (if not installed)
brew install azure-cli  # macOS
# or see https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

az login
az extension add --name application-insights
\`\`\`

Then run `/kc:telemetry-setup` again.
```

### No Resources Found

```markdown
⚠️ Authenticated but no resources found.

**Sentry**: No projects found for your account.
- Create a project at https://sentry.io

**App Insights**: No Application Insights resources found.
- Create one in Azure portal or via CLI:
  \`\`\`bash
  az monitor app-insights component create \
    --app my-app-name \
    --location eastus \
    --resource-group my-rg
  \`\`\`
```

---

## Configuration File Location

The configuration is saved to:
- **Path**: `knowzcode/telemetry_config.md`
- **Git**: Should be committed (shared team configuration)
- **Override**: Team members can edit locally if needed

For sensitive tokens, use environment variables instead of the config file:
- `SENTRY_AUTH_TOKEN` - Sentry authentication
- `AZURE_*` - Azure CLI uses `az login` session

---

## Verification

After setup, test the configuration:

```bash
/kc:telemetry "test query in production in the last 5 min"
```

This should:
1. Load the config from `knowzcode/telemetry_config.md`
2. Map "production" to the configured project/app
3. Query the correct telemetry source
4. Return results (or "no events found" if no matching errors)
