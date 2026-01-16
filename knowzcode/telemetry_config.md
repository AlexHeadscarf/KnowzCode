# Telemetry Configuration

> **This file configures telemetry sources for `/kc:telemetry` investigations.**
>
> Run `/kc:telemetry-setup` to auto-discover and configure sources.

---

## Sentry

| Field | Value |
|-------|-------|
| Enabled | false |
| Organization | |

### Environment Mapping

| Environment | Project |
|-------------|---------|
| production | |
| staging | |
| dev | |

---

## Azure Application Insights

| Field | Value |
|-------|-------|
| Enabled | false |
| Subscription | |
| Resource Group | |

### Environment Mapping

| Environment | App Name | App ID |
|-------------|----------|--------|
| production | | |
| staging | | |
| dev | | |

---

## Configuration Notes

- **Sentry Organization**: Your Sentry organization slug (e.g., `my-company`)
- **Sentry Project**: Format is `org-slug/project-slug` (e.g., `my-company/backend-api`)
- **App Insights App ID**: The Application ID from Azure portal (GUID format)
- **Subscription**: Your Azure subscription ID (optional, uses default if not set)

### Auto-Discovery

Run `/kc:telemetry-setup` to:
1. Detect installed telemetry tools (sentry-cli, az CLI)
2. Verify authentication status
3. Auto-discover available resources
4. Interactively configure environment mappings
5. Update this file with discovered values

### Manual Configuration

Edit the tables above directly to configure telemetry sources:

```markdown
## Sentry

| Field | Value |
|-------|-------|
| Enabled | true |
| Organization | my-company |

### Environment Mapping

| Environment | Project |
|-------------|---------|
| production | my-company/backend-prod |
| staging | my-company/backend-staging |
| dev | my-company/backend-dev |
```

---

## Last Updated

- **Date**: (not configured)
- **By**: (not configured)
