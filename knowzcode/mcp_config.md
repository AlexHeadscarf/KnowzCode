# KnowzCode MCP Configuration

## Connection Status
- **Connected**: No
- **Endpoint**: (not configured)
- **Last Verified**: (never)

> **Not configured?** Run `/kc:register` to create an account and set up MCP automatically,
> or `/kc:connect-mcp <api-key>` if you already have a key.

---

## Vaults

### Research Vault (Primary)
- **Vault ID**: (not configured)
- **Vault Name**: (not configured)
- **Purpose**: Learnings, conventions, decisions, patterns
- **Auto-configured**: No

**Query Patterns (when configured):**
- "Our error handling conventions"
- "What patterns for API versioning?"
- "Security best practices we use"
- "Why did we choose Redis cache?"

### Code Vault (Optional)
- **Vault ID**: (not configured)
- **Vault Name**: (not configured)
- **Purpose**: Indexed source code for semantic search (AST-chunked)

**Note**: Code search works well with local grep/glob for most projects.
Configure a code vault for large codebases (50k+ LOC) where semantic search
provides significant benefit.

**Query Patterns (when configured):**
- "Find all auth middleware"
- "Where is PaymentService?"
- "Show database migrations"
- "JWT validation code"

---

## Single Vault Model (Recommended for New Users)

KnowzCode recommends starting with a **single "KnowzCode" vault** for simplicity:

```
┌─────────────────────────────────────────────────────────┐
│                    KnowzCode Vault                       │
│                                                         │
│  Purpose: Learnings, conventions, decisions, patterns   │
│  Used by: /kc:learn, finalization-steward, agents       │
│  Code search: Uses local grep/glob (no code vault)      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Why single vault?**
- Simpler onboarding (no "what's code vault vs research vault?")
- Code search works fine with grep/glob for most projects
- MCP vault is optimized for organizational knowledge, not code indexing
- Advanced users can add code vault later via `/kc:connect-mcp --configure-vaults`

---

## Usage in Agents

| Agent | Research Vault | Code Vault | Purpose |
|-------|----------------|------------|---------|
| impact-analyst | Query | Query (if configured) | Find past decisions + affected code |
| spec-chief | Query | Query (if configured) | Conventions + implementation examples |
| implementation-lead | Query | Query (if configured) | Best practices + similar patterns |
| architecture-reviewer | Query | Query (if configured) | Standards + precedent check |
| finalization-steward | **Write** | - | Capture learnings |

**Fallback behavior**: When Code Vault is not configured, agents use local grep/glob
for code search. This works well for most projects.

---

## MCP Tools Reference

### Query Tools (Read)

**search_knowledge(query, vaultId, limit)**
- Vector similarity search across indexed content
- Use for: finding code patterns or documentation
- Example: `search_knowledge("authentication logic", research_vault_id, 10)`

**ask_question(question, vaultId, researchMode)**
- AI-powered question answering with document synthesis
- `researchMode: false` - Quick answer (faster)
- `researchMode: true` - Comprehensive answer (8000+ tokens, multi-document)
- Example: `ask_question("What are our error handling conventions?", research_vault_id, true)`

**find_entities(entityType, query, limit)**
- Find people, locations, or events extracted from knowledge base
- `entityType`: "person", "location", or "event"
- Example: `find_entities("person", "John", 25)`

**get_knowledge_item(id, includeRelated)**
- Retrieve a specific knowledge item by ID
- `includeRelated: true` to include related items

**list_vaults(includeStats)**
- List all accessible vaults with optional statistics

### Write Tools (Learning Capture)

**create_knowledge(content, title, knowledgeType, vaultId, tags, source)**
- Create new knowledge item in vault
- `knowledgeType`: "Document", "Note", or "Transcript"
- Example:
  ```json
  {
    "content": "[CONTEXT]...\n[INSIGHT]...\n[EXAMPLE]...",
    "title": "Pattern: JWT Refresh Flow",
    "knowledgeType": "Note",
    "vaultId": "{research_vault_id}",
    "tags": ["security", "jwt", "patterns"],
    "source": "KnowzCode WorkGroup WG-feat-auth-20260128"
  }
  ```

---

## Auto-Learning Configuration

- **Enabled**: Yes
- **Prompt on Detection**: Yes
- **Learning Categories**: Pattern, Decision, Workaround, Performance, Security, Convention

### Detection Signals

Learnings are auto-detected when WorkGroup contains:
- **Pattern signals**: "created utility for", "new helper", "reusable"
- **Decision signals**: "chose X over Y", "decided to", "opted for"
- **Workaround signals**: "workaround", "limitation", "temporary"
- **Performance signals**: "optimized", "reduced from X to Y"
- **Security signals**: "security", "vulnerability", "sanitize"

---

## Configuration Commands

- `/kc:register` - Create account and auto-configure MCP + vault
- `/kc:connect-mcp` - Configure MCP server (use existing API key)
- `/kc:connect-mcp --configure-vaults` - Reconfigure vault IDs
- `/kc:status` - Check connection status and vault info
- `/kc:learn "insight"` - Manually create learning in research vault
