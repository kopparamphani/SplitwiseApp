# ADR-0021 — MCP servers
**Status:** Accepted
**Date:** 2026-06-24

## Context
MCP = the capability layer (tools beyond Claude Code's native file/bash/web). Rule: keep small; add only what native tools can't do; scope per agent via `mcpServers`.

## Decision
Core MCP servers: **GitHub** (PRs, issues, Actions, reviews), **Playwright** (UI/regression QA), **Postgres** (inspect live data while debugging). **Dropped:** Atlassian and Lucid (Lucid redundant vs Structurizr/Mermaid).

## Consequences
**Good:** GitHub fits the Actions/Argo loop; Playwright powers qa-runner regression; Postgres helps implementer/qa debug. Least-privilege scoping per agent.
**Cost:** three services to keep configured (still small/explainable).
**Open:** Harbor/scanning MCP and others only if a concrete need appears.
