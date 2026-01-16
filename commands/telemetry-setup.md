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

Check which telemetry CLI tools are installed:

```bash
# Check Sentry CLI
which sentry-cli 2>/dev/null && echo "SENTRY_CLI_INSTALLED" || echo "NO_SENTRY_CLI"

# Check Azure CLI
which az 2>/dev/null && echo "AZURE_CLI_INSTALLED" || echo "NO_AZURE_CLI"

# Check App Insights extension
az extension list --query "[?name=='application-insights'].name" -o tsv 2>/dev/null || echo "NO_APPINSIGHTS_EXTENSION"
```

**Report detected tools** before proceeding.

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

**Example result**:

```markdown
## Sentry

| Field | Value |
|-------|-------|
| Enabled | true |
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

### Step 6: Confirm Setup

After saving, show a summary:

```markdown
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
◆ TELEMETRY CONFIGURATION COMPLETE
◆━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Sentry**: ✓ Configured
- Organization: my-company
- Environments mapped: production, staging, dev

**App Insights**: ✓ Configured
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

```markdown
⚠️ No telemetry tools detected.

To enable telemetry investigation, install at least one:

**For Sentry**:
\`\`\`bash
npm install -g @sentry/cli
sentry-cli login
\`\`\`

**For Azure App Insights**:
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
