# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.

## Using graphify in a project (conditional — only when artifacts exist)

Before doing architecture / codebase work in any project, probe for graphify state:
- If `graphify-out/GRAPH_REPORT.md` exists → read it first for god nodes and community structure
- If `graphify-out/wiki/index.md` exists → navigate the wiki instead of grepping raw files
- For cross-module "how does X relate to Y" questions → prefer `graphify query "<question>"`, `graphify path "<A>" "<B>"`, or `graphify explain "<concept>"` over grep — these traverse EXTRACTED + INFERRED edges
- After modifying code files in a session where `graphify-out/` exists, run `graphify update .` to keep the graph current (AST-only, no API cost)
- If `graphify-out/` does NOT exist in the project, skip silently — graphify is not configured for that repo

# serena (MCP)

Serena is a symbol-aware code intelligence MCP. When `mcp__serena__*` tools appear in the available tool list:
- Call `mcp__serena__initial_instructions` once at the start of a coding task to load Serena's own usage manual
- Prefer `mcp__serena__find_symbol` / `find_referencing_symbols` / `find_implementations` over grep for "where is X defined" or "what calls Y" questions — symbol-aware results beat regex on TS/JS/Python
- Prefer `mcp__serena__replace_symbol_body` / `insert_after_symbol` / `insert_before_symbol` over Edit for surgical symbol-boundary edits
- Use `mcp__serena__get_symbols_overview` for a fast top-level map of an unfamiliar file
- When Serena tools are NOT in the available tool list, skip silently — fall back to grep / Read / Edit

# sigmap (MCP)

Sigmap is a codebase signature-map MCP for whole-repo navigation and impact analysis. When `mcp__sigmap__*` tools appear in the available tool list:
- Use `mcp__sigmap__get_map` / `list_modules` for a fast architectural overview of an unfamiliar repo before grepping
- Prefer `mcp__sigmap__search_signatures` over grep for "find function/class/symbol matching X" — returns signatures, not raw line matches
- Use `mcp__sigmap__get_impact` before modifying a shared symbol to see downstream blast radius (callers, dependents)
- Use `mcp__sigmap__get_routing` to trace HTTP/RPC route → handler wiring without reading framework boilerplate
- Use `mcp__sigmap__read_context` / `query_context` for "what does this module do, in context" instead of reading every file end-to-end
- Use `mcp__sigmap__explain_file` for a fast summary of an unfamiliar file before editing
- Use `mcp__sigmap__create_checkpoint` to snapshot map state before a large refactor so impact comparisons remain meaningful
- When Sigmap tools are NOT in the available tool list, skip silently — fall back to grep / Read / serena / graphify

# agent-desktop

Use `agent-desktop` to see and operate desktop apps. Before the first use, run
`agent-desktop skills get desktop` and `agent-desktop skills get platform`, and follow them.
