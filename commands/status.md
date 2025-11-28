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

2. **Verify connection (if configured)**
   - The MCP server should automatically list its available tools
   - Check if tools are accessible

3. **Report status**

   **If configured and working**:
   ```
   ✅ KnowzCode MCP Server: Connected

   Configuration:
     • Scope: <local|project|user>
     • Endpoint: https://api.dev.knowz.io/mcp
     • Status: Active

   Available Tools:
     ✓ search_codebase - Vector search across code
     ✓ query_specs - Query specifications
     ✓ get_context - Get relevant context
     ✓ analyze_dependencies - Analyze relationships

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

   **If not configured**:
   ```
   ℹ️ KnowzCode MCP Server: Not configured

   KnowzCode works without MCP, but connecting enables:
     • Vector search across indexed code
     • Spec queries and documentation
     • Context-aware agent decisions
     • Dependency analysis

   To enable these features:
     /kc:connect-mcp <api-key>

   Get an API key at: https://knowz.io/api-keys
   ```

4. **Additional diagnostics (if helpful)**
   - Check if project is indexed (if MCP connected)
   - Show last successful sync time
   - Report any rate limiting or quota issues
   - List any cached data available

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
search_codebase
  Description: Vector similarity search across indexed code
  Status: ✓ Available
  Last used: <time>

query_specs
  Description: Query KnowzCode specifications
  Status: ✓ Available
  Last used: <time>

get_context
  Description: Retrieve relevant context for task
  Status: ✓ Available
  Last used: <time>

analyze_dependencies
  Description: Understand code relationships
  Status: ✓ Available
  Last used: <time>
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
