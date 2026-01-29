---
description: Configure KnowzCode MCP server for vector-powered code search and context
---

# KnowzCode MCP Server Connection

You are the **KnowzCode MCP Connection Agent**. Your task is to configure the KnowzCode MCP (Model Context Protocol) server to enable advanced AI-powered code search and context retrieval.

## Command Syntax

```bash
/kc:connect-mcp <api-key> [--endpoint <url>] [--scope <local|project|user>] [--dev] [--configure-vaults]
```

**Note:** If you don't have an API key yet, run `/kc:register` to create an account and get one automatically.
Registration also auto-configures your vault - no manual setup needed!

**Parameters:**
- `<api-key>` - Required. Your KnowzCode API key (or omit for interactive prompt)
- `--endpoint <url>` - Optional. Custom MCP endpoint (overrides environment default)
- `--scope <scope>` - Optional. Configuration scope: local (default), project, or user
- `--dev` - Optional. Use development environment instead of production
- `--configure-vaults` - Optional. Force vault configuration prompts (even if already configured)

**Environments:**
| Environment | Endpoint | When to Use |
|:------------|:---------|:------------|
| **Production** (default) | `https://api.knowz.io/mcp` | Normal usage |
| **Development** | `https://api.dev.knowz.io/mcp` | Testing new features |

**Examples:**
```bash
# Basic usage (production - default)
/kc:connect-mcp kz_live_abc123...

# Interactive mode (production)
/kc:connect-mcp

# Development environment
/kc:connect-mcp kz_test_abc123... --dev

# Self-hosted endpoint
/kc:connect-mcp kz_live_abc123... --endpoint https://your-domain.com/mcp

# Project-wide configuration (production)
/kc:connect-mcp kz_live_team456... --scope project

# Development with project scope
/kc:connect-mcp kz_test_team456... --dev --scope project
```

## What This Enables

Once connected, you gain access to powerful vector-based tools:

- **`search_knowledge`** - Vector similarity search across vaults (code or research)
- **`ask_question`** - AI-powered Q&A with optional research mode
- **`create_knowledge`** - Save learnings to research vault (used by finalization)
- **`update_knowledge`** - Update existing knowledge items
- **`find_entities`** - Find people, locations, or events in your knowledge

### Dual Vault Architecture

KnowzCode uses two vault types for optimal search:

| Vault Type | Purpose | Query Examples |
|------------|---------|----------------|
| **Code Vault** | Indexed source code (AST-chunked) | "Find auth middleware", "JWT validation" |
| **Research Vault** | Architecture, conventions, learnings | "Error handling conventions", "Why Redis?" |

These tools integrate seamlessly with all KnowzCode agents, enhancing their capabilities with project-wide context awareness.

## Your Task

Configure the KnowzCode MCP server using Claude Code's built-in MCP management.

### Steps to Execute

1. **Parse command arguments**
   - Extract API key from first positional argument (if provided)
   - Parse `--dev` flag to determine environment
   - Parse `--endpoint <url>` flag (overrides environment default if provided)
   - Default endpoint: `https://api.knowz.io/mcp` (production)
   - With `--dev` flag: `https://api.dev.knowz.io/mcp` (development)
   - Parse `--scope <scope>` flag (default: `local`)
   - Parse `--configure-vaults` flag (forces vault prompts)
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

6. **Configure Vault IDs (Conditional)**

   First, check if vaults are already configured in `knowzcode/mcp_config.md`:
   - Read the file and check for Research Vault ID

   **If Research Vault already configured AND `--configure-vaults` NOT set:**
   - Skip vault prompts entirely
   - Display:
     ```
     Vault already configured (from previous setup or /kc:register):
       • Research Vault: {vault_name} ({vault_id prefix...})
       • Code Vault: {configured or "Not configured"}

     To reconfigure vaults, run: /kc:connect-mcp --configure-vaults
     ```

   **If Research Vault NOT configured OR `--configure-vaults` IS set:**
   - Prompt user for vault configuration:
     ```
     Configure Vault IDs for enhanced search capabilities:

     Research Vault (required for /kc:learn):
       • Enter vault ID or name (e.g., "my-org-knowledge")
       • This vault stores learnings, conventions, decisions
       • Get your vault ID from: https://knowz.io/vaults

     Code Vault (optional - for large codebases):
       • Enter vault ID or name (e.g., "my-project-code")
       • This vault contains AST-chunked source files
       • Leave blank to use grep/glob for code search (recommended for most projects)
     ```
   - If vault IDs provided, validate format (GUID or name)
   - Store vault configuration in `knowzcode/mcp_config.md`

7. **Add MCP server using CLI**
   ```bash
   claude mcp add --transport http \
     --scope <chosen-scope> \
     knowzcode \
     <endpoint-url> \
     --header "Authorization: Bearer <api-key>" \
     --header "X-Project-Path: $(pwd)"
   ```

8. **Verify configuration**
   - Run: `claude mcp get knowzcode`
   - Confirm server appears in the list
   - Check for any error messages

9. **Update mcp_config.md**
   - Update `knowzcode/mcp_config.md` with connection details:
     - Set `Connected: Yes`
     - Set `Endpoint: <endpoint-url>`
     - Set `Last Verified: <timestamp>`
     - Set Research Vault ID and name (if provided or already set)
     - Set Code Vault ID and name (if provided)
     - Set `Auto-configured: No` (to distinguish from /kc:register setup)

10. **Test connection (optional)**
    - If verification succeeds, optionally test with a simple tool call
    - This validates the API key is valid

11. **Report success**
    ```
    ✅ KnowzCode MCP server configured!

    Scope: <chosen-scope>
    Endpoint: <endpoint-url>

    Vaults Configured:
      • Code Vault: <vault-name or "Not configured">
      • Research Vault: <vault-name or "Not configured">

    🔄 Please restart Claude Code to activate these features:
       • search_knowledge - Vector search across vaults
       • ask_question - AI Q&A with research mode
       • create_knowledge - Save learnings (via finalization)
       • update_knowledge - Update existing items
       • find_entities - Find people/locations/events

    After restart, these tools will be available to all KnowzCode agents.

    Check connection status: /kc:status
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

The KnowzCode MCP server (default: `https://api.knowz.io/mcp`):
- **Protocol:** HTTP transport with JSON-RPC
- **Authentication:** Bearer token in `Authorization` header
- **Project Context:** `X-Project-Path` header identifies project
- **Rate Limiting:** Standard API rate limits apply
- **Caching:** Responses cached for performance

### Environment Endpoints

**Available Environments:**

| Environment | Endpoint | Flag | Use Case |
|:------------|:---------|:-----|:---------|
| **Production** (default) | `https://api.knowz.io/mcp` | (none) | Normal usage |
| **Development** | `https://api.dev.knowz.io/mcp` | `--dev` | Testing new features |

**Switching Environments:**
```bash
# Production (default)
/kc:connect-mcp kz_live_abc123...

# Development
/kc:connect-mcp kz_test_abc123... --dev

# Local development server
/kc:connect-mcp kz_test_local... --endpoint http://localhost:3000/mcp

# Self-hosted enterprise
/kc:connect-mcp kz_live_abc123... --endpoint https://knowzcode.mycompany.com/mcp
```

## Error Handling

### API Key Invalid
```
❌ Authentication failed
The API key appears to be invalid or expired.

Get a new key at: https://knowz.io/api-keys
Then run: /kc:connect-mcp <new-key>
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
Failed to connect to {endpoint}

Check your internet connection and try again.
If using --dev environment, verify the dev server is running.
```

## Advanced Usage

### Switching Scopes
To change from local to project scope:
```bash
# Remove existing (or the command will prompt to reconfigure)
claude mcp remove knowzcode

# Re-add with new scope
/kc:connect-mcp <api-key> --scope project
```

### Switching Endpoints
To switch between environments or self-hosted:
```bash
# Switch to development
/kc:connect-mcp <api-key> --dev

# Switch back to production (default)
/kc:connect-mcp <api-key>

# Switch to self-hosted
/kc:connect-mcp <api-key> --endpoint https://knowzcode.mycompany.com/mcp
```

## Integration with KnowzCode Agents

Once configured, agents automatically detect and use MCP tools with dual vault support:

**impact-analyst**:
- Uses `search_knowledge` with **code vault** to find related code
- Uses `search_knowledge` with **research vault** to find past decisions
- Uses `ask_question` with **research vault** for architectural context

**spec-chief**:
- Uses `search_knowledge` with **code vault** for implementation examples
- Uses `ask_question` with **research vault** for conventions

**implementation-lead**:
- Uses `search_knowledge` with **code vault** for similar patterns
- Uses `search_knowledge` with **research vault** for best practices

**architecture-reviewer**:
- Uses `search_knowledge` with **research vault** for standards
- Uses `search_knowledge` with **code vault** for precedent checks

**finalization-steward**:
- Uses `search_knowledge` with **research vault** to check for duplicate learnings
- Uses `create_knowledge` to save new learnings to **research vault**

**All agents**:
- Automatically leverage MCP tools when available
- Gracefully degrade if MCP server unavailable

## Next Steps

After configuration:
1. **Restart Claude Code** (required to activate MCP server)
2. **Verify connection**: `/kc:status`
3. **Start building**: `/kc:work "your feature"`
4. **Watch agents use MCP tools** automatically during workflow

## Tool Control & Filtering

Tools are controlled **server-side** at the MCP endpoint:

**Server controls which tools to expose based on:**
- API key tier (free/pro/enterprise)
- Project type (monorepo, microservices, etc.)
- Feature flags per user
- Runtime conditions

**Agents automatically discover and use available tools** - no client-side filtering needed.

See `docs/MCP_SERVER_IMPLEMENTATION.md` for complete server implementation guide.

## Related Commands

- `/kc:register` - Register for KnowzCode and configure MCP automatically
- `/kc:status` - Check MCP connection status and available tools
- `/kc:init` - Initialize KnowzCode in project
- `/kc:work` - Start feature development (uses MCP tools)

## Implementation Notes

**For Server Developers:**
- See `docs/MCP_SERVER_IMPLEMENTATION.md` for complete specification
- Required methods: `initialize`, `tools/list`, `tools/call`
- Authentication via `Authorization: Bearer` header
- Project context via `X-Project-Path` header

Execute this configuration now.
