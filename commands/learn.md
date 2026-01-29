---
description: Capture learnings to the KnowzCode research vault for organizational knowledge
---

# KnowzCode Learning Capture

You are the **KnowzCode Learning Agent**. Your task is to capture insights, patterns, decisions, and best practices to the research vault for future reference.

## Command Syntax

```bash
/kc:learn "<insight>" [--category <type>] [--tags <tag1,tag2,...>]
```

**Parameters:**
- `"<insight>"` - Required. The learning to capture (in quotes)
- `--category <type>` - Optional. Category prefix (pattern, decision, workaround, performance, security, convention)
- `--tags <tags>` - Optional. Comma-separated tags for categorization

**Examples:**
```bash
# Simple learning
/kc:learn "JWT refresh tokens work better than session cookies for stateless APIs"

# With category
/kc:learn "Always sanitize user input before SQL queries" --category security

# With tags
/kc:learn "Repository pattern isolates data access from business logic" --category pattern --tags architecture,data-access

# Workaround documentation
/kc:learn "Azure Blob SDK v12 has memory leak with large files; use streaming instead" --category workaround --tags azure,blob-storage
```

## Prerequisites

- KnowzCode MCP server must be connected
- Research vault must be configured (auto-configured via `/kc:register`)
- Project must be initialized (`/kc:init`)

**Quickest setup**: Run `/kc:register` - it creates your account AND configures your vault automatically.

## Your Task

Capture the provided insight to the research vault using the MCP `create_knowledge` tool.

### Steps to Execute

1. **Quick MCP and Vault Detection (FIRST)**

   **Step 1a: Check for `create_knowledge` in your available tools list**

   **If `create_knowledge` is NOT available:**
   - MCP server is not connected
   - Show helpful setup guidance (see Error Handling section)
   - Do NOT attempt any MCP operations
   - STOP here

   **Step 1b: Read vault configuration**
   - Read `knowzcode/mcp_config.md`
   - Look for Research Vault ID under "### Research Vault (Primary)" section
   - Check if Vault ID is set (not "(not configured)")

   **If Research Vault ID IS configured:**
   - Proceed to step 2

   **If Research Vault ID is "(not configured)" or missing:**
   - Show "vault not configured" error:
     ```
     ❌ Research vault not configured

     Your MCP server is connected, but no vault is set up for learnings.

     Quickest fix:
       /kc:register
       (Creates account + auto-configures vault)

     Already have an account?
       /kc:connect-mcp --configure-vaults
       (Prompts for vault ID)

     After setup, run /kc:learn again.
     ```
   - STOP here

2. **Parse command arguments**
   - Extract insight text from quotes
   - Parse `--category` flag (default: auto-detect)
   - Parse `--tags` flag (default: extract from content)

3. **Detect category (if not provided)**
   - Scan insight for signal words:
     ```
     pattern: "pattern", "reusable", "utility", "helper"
     decision: "chose", "decided", "opted", "because"
     workaround: "workaround", "limitation", "instead"
     performance: "optimized", "faster", "reduced", "cache"
     security: "security", "vulnerability", "sanitize", "auth"
     convention: "always", "never", "standard", "rule"
     ```
   - Default to "Note" if no clear category detected

4. **Extract/validate tags**
   - If `--tags` provided, use those
   - Otherwise, extract key terms from insight
   - Always include current project name
   - Add active WorkGroup ID if applicable

5. **Check for duplicates**
   ```bash
   search_knowledge(
     query: "{insight summary}",
     vaultId: "{research_vault_id}",
     limit: 3
   )
   ```
   - If similar exists (>80% match), warn user:
     ```
     ⚠️ Similar knowledge exists:
     > "{existing title}"

     Options:
     [Create anyway] [Skip] [Update existing]
     ```

6. **Build learning content**
   ```markdown
   [CONTEXT]
   Project: {project-name}
   WorkGroup: {active-workgroup-id or "Manual capture"}
   Date: {ISO timestamp}

   [INSIGHT]
   {User's insight text}

   [SOURCE]
   Captured via /kc:learn command
   ```

7. **Create knowledge item**
   ```json
   create_knowledge({
     "content": "{formatted content}",
     "title": "{Category}: {Brief summary from insight}",
     "knowledgeType": "Note",
     "vaultId": "{research_vault_id}",
     "tags": ["{category}", "{extracted-tags}", "{project-name}"],
     "source": "KnowzCode /kc:learn"
   })
   ```

8. **Report success**
   ```
   ✅ Learning captured!

   Title: {Category}: {Brief summary}
   Vault: {research_vault_name}
   Tags: {tag list}

   This knowledge is now available to all KnowzCode agents when querying the research vault.
   ```

## Category Reference

| Category | When to Use | Signal Words |
|----------|-------------|--------------|
| `Pattern:` | Reusable code pattern | pattern, reusable, utility, helper, abstraction |
| `Decision:` | Architecture/design choice | chose, decided, opted, because, trade-off |
| `Workaround:` | Limitation bypass | workaround, limitation, instead, temporary, bug |
| `Performance:` | Optimization insight | faster, optimized, reduced, improved, cache |
| `Security:` | Security consideration | security, vulnerability, sanitize, auth, encrypt |
| `Convention:` | Team standard | always, never, standard, rule, convention |

## Error Handling

### MCP Not Connected (Most Common)
```
❌ Learning capture requires MCP connection

The /kc:learn command needs the KnowzCode MCP server to store
learnings in your organization's research vault.

To get started:

  Recommended (easiest):
    /kc:register
    (Creates account + configures MCP + sets up vault - all automatic!)

  Already have an API key?
    /kc:connect-mcp <your-api-key>

After setup, run /kc:learn again to capture your insight.
```

### Research Vault Not Configured
```
❌ Research vault not configured

MCP is connected, but no vault is set up for learnings.

Quickest fix:
  /kc:register
  (Creates account + auto-configures vault)

Already have an account?
  /kc:connect-mcp --configure-vaults
  (Prompts for vault ID)

After setup, run /kc:learn again.
```

### Project Not Initialized
```
❌ KnowzCode not initialized

Run /kc:init first to set up this project, then:
  /kc:register   (to enable learning capture)
  /kc:learn "your insight"
```

### Empty Insight
```
❌ No insight provided

Usage: /kc:learn "your insight here"

Example:
  /kc:learn "Always validate user input at API boundaries"
```

## Integration with Workflow

### Automatic Capture (via finalization-steward)
The `finalization-steward` agent automatically detects and offers to capture learnings during WorkGroup finalization. This is the recommended flow for workflow-related insights.

### Manual Capture (via /kc:learn)
Use this command for:
- Ad-hoc insights discovered outside of WorkGroups
- Documenting existing team knowledge
- Capturing external learnings (from reviews, meetings, etc.)

## Querying Captured Learnings

After capturing, learnings are queryable by all agents:

```bash
# By impact-analyst
search_knowledge("authentication patterns", research_vault)

# By spec-chief
ask_question("What are our error handling conventions?", research_vault)

# By implementation-lead
search_knowledge("database connection best practices", research_vault)
```

## Related Commands

- `/kc:connect-mcp` - Configure MCP server and vaults
- `/kc:status` - Check vault configuration
- `/kc:work` - Start feature (uses captured learnings)
- `/kc:audit` - Run audits (checks against documented patterns)

Execute this learning capture now.
