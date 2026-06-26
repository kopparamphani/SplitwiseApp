# Design Docs — Expense Tracker

Docs-as-code bundle. Start at the repo-root `CLAUDE.md`; this folder holds the detail.

| Area | Path | Status |
|------|------|--------|
| Requirements | `requirements-spec.md` | Signed off |
| C4 model | `architecture/workspace.dsl` | Context + Container (deployment view note) |
| Decisions | `architecture/adr/` (0001–0021) | All accepted |
| Data models | `architecture/data-models/` | Logical |
| Sequences | `architecture/sequence-diagrams/` | add-expense, login, settle-up |
| API contracts | `api/` | OpenAPI per service + AsyncAPI events |
| Quality | `quality/` | test-strategy, nfr (open decisions), threat-model |
| Deployment | `deployment/deployment-view.md` | Filled (local kind + Hetzner prod) |
| Agents | `../.claude/agents/` + `../.mcp.json` | 9 subagents + orchestration + MCP |

Glossary of plain-word tech terms: repo-root `glossary.md`.
