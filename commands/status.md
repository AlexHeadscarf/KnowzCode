---
description: Check KnowzCode MCP server connection status and available tools
---

# KnowzCode MCP Connection Status

You are the **KnowzCode Status Agent**. Your task is to verify the KnowzCode MCP server configuration and test connectivity.

## What This Checks

- MCP server configuration status
- Connection to KnowzCode API
- Available tools and their status
- API key validity
- **Code Vault** configuration and status
- **Research Vault** configuration and status
- Project indexing status

## Your Task

Check the KnowzCode MCP server status and report findings to the user.

### Steps to Execute

1. **Check MCP server configuration**
   ```bash
   claude mcp get knowzcode
   ```

   - If configured: Extract scope, endpoint, headers
   - If not configured: Report and suggest `/kc:connect`

2. **Check vault configuration**
   - Read `knowzcode/mcp_config.md` for vault IDs
   - Extract Code Vault ID and name
   - Extract Research Vault ID and name
   - Note if either vault is not configured

3. **Verify connection (if configured)**
   - The MCP server should automatically list its available tools
   - Check if tools are accessible
   - If vault IDs configured, verify they're accessible

4. **Report status**

   **If configured and working**:
   ```
   ✅ KnowzCode MCP Server: Connected

   Configuration:
     • Scope: <local|project|user>
     • Endpoint: https://api.knowz.io/mcp
     • Status: Active

   Vaults:
     Code Vault:
       • ID: <vault-id>
       • Name: <vault-name>
       • Status: ✓ Available
       • Purpose: Indexed source code (AST-chunked)

     Research Vault:
       • ID: <vault-id>
       • Name: <vault-name>
       • Status: ✓ Available
       • Purpose: Architecture, conventions, learnings

   Available Tools:
     ✓ search_knowledge - Vector search across vaults
     ✓ ask_question - AI Q&A with research mode
     ✓ create_knowledge - Save learnings to vault
     ✓ update_knowledge - Update existing items
     ✓ find_entities - Find people/locations/events

   Project: <project-path>
   Last sync: <if available>

   All systems operational. Agents can use MCP tools.
   ```

   **If configured but not working**:
   ```
   ⚠️ KnowzCode MCP Server: Configured but unavailable

   Configuration:
     • Scope: <scope>
     • Endpoint: <endpoint>
     • Status: Cannot connect

   Possible issues:
     • API key may be invalid or expired
     • Network connectivity issues
     • KnowzCode API may be down

   Troubleshooting:
     1. Check your internet connection
     2. Verify API key: https://knowz.io/api-keys
     3. Reconfigure: /kc:connect-mcp <new-key>
     4. Check status: https://status.knowz.io
   ```

   **If MCP connected but vaults not configured**:
   ```
   ⚠️ KnowzCode MCP Server: Connected (vaults not configured)

   Configuration:
     • Scope: <scope>
     • Endpoint: <endpoint>
     • Status: Active

   Vaults:
     Code Vault: ⚠️ Not configured
     Research Vault: ⚠️ Not configured

   MCP is connected but you haven't configured your vaults yet.
   Vaults enable semantic search and learning capture.

   To configure vaults:
     /kc:connect-mcp <api-key>
     (You'll be prompted to enter vault IDs)

   Or manually edit: knowzcode/mcp_config.md
   ```

   **If not configured at all**:
   ```
   ℹ️ KnowzCode MCP Server: Not configured

   KnowzCode works fine without MCP! All core features work:
     ✓ TDD workflow (/kc:work)
     ✓ Spec generation
     ✓ Impact analysis
     ✓ Quality audits

   MCP adds enhanced capabilities:
     • Vector search across indexed code (Code Vault)
     • Convention and pattern lookups (Research Vault)
     • AI-powered Q&A with research mode
     • Automatic learning capture

   To enable these features:
     New user?     /kc:register              (creates account + configures)
     Have a key?   /kc:connect-mcp <api-key>
   ```

5. **Additional diagnostics (if helpful)**
   - Check if project is indexed (if MCP connected)
   - Show vault document counts and last sync times
   - Report any rate limiting or quota issues
   - List any cached data available
   - Show learning capture status (enabled/disabled)

## Output Format

Use clear status indicators:
- ✅ Green check: Working perfectly
- ⚠️ Warning: Configured but issues
- ℹ️ Info: Not configured
- ❌ Error: Critical failure

## Connection Details

If connection is active, optionally show:

```
Connection Details:
  • Response time: <ms>
  • Tools loaded: <count>
  • Cache status: <enabled/disabled>
  • Rate limit: <remaining/total>
```

## MCP Tool Details

For each available tool, can optionally show:

```
search_knowledge
  Description: Vector similarity search across vaults
  Vaults: Code Vault, Research Vault
  Status: ✓ Available
  Last used: <time>

ask_question
  Description: AI-powered Q&A with optional research mode
  Vaults: Research Vault (primary)
  Research Mode: Enabled (8000+ token comprehensive answers)
  Status: ✓ Available
  Last used: <time>

create_knowledge
  Description: Save learnings to research vault
  Vaults: Research Vault (write)
  Used by: finalization-steward, /kc:learn
  Status: ✓ Available
  Last used: <time>
```

## Vault Status Details

If vaults are configured, optionally show:

```
Code Vault: my-project-code
  • Documents indexed: <count>
  • Last index: <timestamp>
  • Index status: Up to date / Stale / Indexing...
  • Paths: src/, tests/, packages/

Research Vault: engineering-knowledge
  • Documents: <count>
  • Notes: <count>
  • Last updated: <timestamp>
  • Top tags: architecture, security, patterns
```

## Error States

### Invalid API Key
```
❌ Authentication Error
The API key is invalid or expired.

Update: /kc:connect-mcp <new-key>
```

### Network Issues
```
❌ Connection Error
Cannot reach KnowzCode API at <endpoint>

Check:
  • Internet connection
  • Firewall settings
  • VPN configuration
```

### Service Down
```
❌ Service Unavailable
KnowzCode API is not responding.

Status: https://status.knowz.io
```

## Usage Examples

### Basic status check
```bash
/kc:status
```

### After configuration
```bash
/kc:connect-mcp <api-key>
# ... restart Claude Code ...
/kc:status  # Verify everything works
```

### Troubleshooting
```bash
/kc:status  # Check what's wrong
# Follow suggested remediation steps
```

## Integration Notes

This command is useful:
- **After initial setup**: Verify `/kc:connect` worked
- **When tools seem unavailable**: Debug MCP connection
- **Before starting work**: Confirm enhanced features active
- **Troubleshooting**: Diagnose connectivity issues

## Related Commands

- `/kc:connect-mcp` - Configure MCP server
- `/kc:init` - Initialize KnowzCode
- `/kc:work` - Start feature (uses MCP if available)

## Important Notes

- **Restart required**: After `/kc:connect-mcp`, Claude Code must restart
- **Graceful degradation**: KnowzCode works without MCP (just less powerful)
- **No credentials shown**: Never display full API keys
- **Clear guidance**: Always suggest next steps if issues found

Execute this status check now.
