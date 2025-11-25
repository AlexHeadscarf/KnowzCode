---
description: Configure KnowzCode MCP server for vector-powered code search and context
---

# KnowzCode MCP Server Connection

You are the **KnowzCode MCP Connection Agent**. Your task is to configure the KnowzCode MCP (Model Context Protocol) server to enable advanced AI-powered code search and context retrieval.

## Command Syntax

```bash
/knowzcode:connect-mcp <api-key> [--endpoint <url>] [--scope <local|project|user>]
```

**Parameters:**
- `<api-key>` - Required. Your KnowzCode API key (or omit for interactive prompt)
- `--endpoint <url>` - Optional. Custom MCP endpoint (default: https://api.dev.knowz.io/mcp)
- `--scope <scope>` - Optional. Configuration scope: local (default), project, or user

**Current Environment:**
- **Development** (default): `https://api.dev.knowz.io/mcp` - Active for testing
- **Production** (future): `https://api.knowz.io/mcp` - Available after dev testing completes

**Examples:**
```bash
# Basic usage (uses dev environment by default)
/knowzcode:connect-mcp kz_test_abc123...

# Interactive mode
/knowzcode:connect-mcp

# Production environment (when available)
/knowzcode:connect-mcp kz_live_abc123... --endpoint https://api.knowz.io/mcp

# Self-hosted endpoint
/knowzcode:connect-mcp kz_live_abc123... --endpoint https://your-domain.com/mcp

# Project-wide dev testing
/knowzcode:connect-mcp kz_test_team456... --scope project
```

## What This Enables

Once connected, you gain access to powerful vector-based tools:

- **`search_codebase`** - Vector similarity search across indexed code
- **`query_specs`** - Query KnowzCode specifications and documentation
- **`get_context`** - Retrieve relevant context for the current task
- **`analyze_dependencies`** - Understand code relationships and impact

These tools integrate seamlessly with all KnowzCode agents, enhancing their capabilities with project-wide context awareness.

## Your Task

Configure the KnowzCode MCP server using Claude Code's built-in MCP management.

### Steps to Execute

1. **Parse command arguments**
   - Extract API key from first positional argument (if provided)
   - Parse `--endpoint <url>` flag (default: `https://api.dev.knowz.io/mcp`)
   - Parse `--scope <scope>` flag (default: `local`)
   - Store parsed values for use in configuration

2. **Check for existing configuration**
   - Check if MCP server already configured: `claude mcp get knowzcode`
   - If already configured, ask if user wants to reconfigure
   - If yes, run `claude mcp remove knowzcode` first

3. **Prompt for API key (if not provided)**
   - If no API key in arguments, prompt user interactively:
     ```
     Enter your KnowzCode API key
     (Get one at https://knowz.io/api-keys)
     ```
   - Validate format (should start with `kz_live_` or `kz_test_`)
   - Never display the full API key back to user

4. **Confirm scope (if not provided)**
   - If `--scope` not provided, ask user which scope to use:
     - **local** (default): Only this project, private to you
     - **project**: Shared with team via `.mcp.json` (committed to git)
     - **user**: Available across all your projects

   Present as options to user if not specified in command.

5. **Validate endpoint URL (if custom)**
   - If custom endpoint provided via `--endpoint`, validate it's a valid URL
   - Ensure it starts with `https://` (or `http://` for local dev)
   - Show which endpoint will be used

6. **Add MCP server using CLI**
   ```bash
   claude mcp add --transport http \
     --scope <chosen-scope> \
     knowzcode \
     <endpoint-url> \
     --header "Authorization: Bearer <api-key>" \
     --header "X-Project-Path: $(pwd)"
   ```

7. **Verify configuration**
   - Run: `claude mcp get knowzcode`
   - Confirm server appears in the list
   - Check for any error messages

8. **Test connection (optional)**
   - If verification succeeds, optionally test with a simple tool call
   - This validates the API key is valid

9. **Report success**
   ```
   ✅ KnowzCode MCP server configured!

   Scope: <chosen-scope>
   Endpoint: <endpoint-url>

   🔄 Please restart Claude Code to activate these features:
      • search_codebase - Vector search across code
      • query_specs - Query specifications
      • get_context - Get relevant context
      • analyze_dependencies - Analyze relationships

   After restart, these tools will be available to all KnowzCode agents.

   Check connection status: /knowzcode:status
   ```

## Configuration Details

### Scope Comparison

**Local (default)**:
- ✅ Private to you
- ✅ Project-specific
- ❌ Not shared with team
- **Use when:** Personal API key, working solo

**Project**:
- ✅ Shared with team
- ✅ Committed to git via `.mcp.json`
- ⚠️ API key visible to team
- **Use when:** Team API key, collaborative project

**User**:
- ✅ Available everywhere
- ✅ Set once, works across projects
- ❌ Not project-specific
- **Use when:** Single API key for all your work

### Security Considerations

- **Never log API keys** in command output
- **Mask displayed keys**: Show only first/last 4 chars (e.g., `kz_live_abc...xyz`)
- **Warn about project scope**: API key will be in git-committed `.mcp.json`
- **Suggest environment variables**: For team setups, recommend storing in CI/CD secrets

### MCP Server Details

The KnowzCode MCP server (default: `https://api.dev.knowz.io/mcp`):
- **Protocol:** HTTP transport with JSON-RPC
- **Authentication:** Bearer token in `Authorization` header
- **Project Context:** `X-Project-Path` header identifies project
- **Rate Limiting:** Standard API rate limits apply
- **Caching:** Responses cached for performance

### Environment Endpoints

**Available Environments:**

| Environment | Endpoint | Status | Use Case |
|:------------|:---------|:-------|:---------|
| **Development** | `https://api.dev.knowz.io/mcp` | ✅ Active | Current testing environment |
| **Production** | `https://api.knowz.io/mcp` | 🚧 Pending | After dev testing completes |

**Switching Environments:**
```bash
# Development (default for testing)
/knowzcode:connect-mcp kz_test_abc123...

# Production (when ready)
/knowzcode:connect-mcp kz_live_abc123... --endpoint https://api.knowz.io/mcp

# Local development
/knowzcode:connect-mcp kz_test_local... --endpoint http://localhost:3000/mcp

# Self-hosted enterprise
/knowzcode:connect-mcp kz_live_abc123... --endpoint https://knowzcode.mycompany.com/mcp
```

## Error Handling

### API Key Invalid
```
❌ Authentication failed
The API key appears to be invalid or expired.

Get a new key at: https://knowz.io/api-keys
Then run: /knowzcode:connect-mcp <new-key>
```

### Already Configured
```
⚠️ KnowzCode MCP server is already configured
Current scope: <scope>

Do you want to reconfigure?
```

### Claude CLI Not Available
```
❌ Cannot configure MCP server
The 'claude' CLI command is not available.

This is unusual - Claude Code should provide this command.
Please restart Claude Code or report this issue.
```

### Network/Connection Error
```
❌ Cannot reach KnowzCode API
Failed to connect to https://api.dev.knowz.io

Check your internet connection and try again.
If using dev environment, verify the server is running.
```

## Advanced Usage

### Switching Scopes
To change from local to project scope:
```bash
# Remove existing (or the command will prompt to reconfigure)
claude mcp remove knowzcode

# Re-add with new scope
/knowzcode:connect-mcp <api-key> --scope project
```

### Switching Endpoints
To switch between cloud and self-hosted:
```bash
# Switch to self-hosted
/knowzcode:connect-mcp <api-key> --endpoint https://knowzcode.mycompany.com/mcp

# Switch back to cloud
/knowzcode:connect-mcp <api-key>  # Uses default endpoint
```

## Integration with KnowzCode Agents

Once configured, agents automatically detect and use MCP tools:

**impact-analyst**:
- Uses `search_codebase` to find related code during impact analysis
- Uses `analyze_dependencies` to map change ripple effects

**spec-chief**:
- Uses `query_specs` to retrieve existing specifications
- Uses `get_context` to understand component relationships

**implementation-lead**:
- Uses `search_codebase` to find implementation examples
- Uses `get_context` to understand code patterns

**All agents**:
- Automatically leverage MCP tools when available
- Gracefully degrade if MCP server unavailable

## Next Steps

After configuration:
1. **Restart Claude Code** (required to activate MCP server)
2. **Verify connection**: `/knowzcode:status`
3. **Start building**: `/knowzcode:work "your feature"`
4. **Watch agents use MCP tools** automatically during workflow

## Tool Control & Filtering

Tools are controlled **server-side** at `https://api.dev.knowz.io/mcp`:

**Server controls which tools to expose based on:**
- API key tier (free/pro/enterprise)
- Project type (monorepo, microservices, etc.)
- Feature flags per user
- Runtime conditions

**Agents automatically discover and use available tools** - no client-side filtering needed.

See `docs/MCP_SERVER_IMPLEMENTATION.md` for complete server implementation guide.

## Related Commands

- `/knowzcode:status` - Check MCP connection status and available tools
- `/knowzcode:init` - Initialize KnowzCode in project
- `/knowzcode:work` - Start feature development (uses MCP tools)

## Implementation Notes

**For Server Developers:**
- See `docs/MCP_SERVER_IMPLEMENTATION.md` for complete specification
- Required methods: `initialize`, `tools/list`, `tools/call`
- Authentication via `Authorization: Bearer` header
- Project context via `X-Project-Path` header

Execute this configuration now.
