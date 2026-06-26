# ADR-0020 — Agent roster & orchestration (Claude Code subagents)
**Status:** Accepted
**Date:** 2026-06-24

## Context
"Specialized agents + orchestration" is a stated goal. Implemented as Claude Code subagents: each is a markdown file in `.claude/agents/` with its own context window, system prompt, and tool allowlist. Subagents are one level deep; the main session orchestrates. Least privilege is the core rule.

## Decision
**9-agent roster:** architect-reviewer, implementer, test-writer, manual-qa, qa-runner, api-qa, reviewer, devops, docs. Tools scoped per agent (reviewers/QA read-only or bash-only; orchestrator never edits).
**Orchestration:** sequential pipeline first — architect-reviewer → implementer → test-writer/manual-qa → qa-runner/api-qa → reviewer → devops/docs — adding parallel pairs later.

## Consequences
**Good:** clean separation of concerns; constrained blast radius; predictable sequential flow to start; maps 1:1 to the SDLC activities.
**Cost:** more files to maintain; start with 4 core (architect-reviewer, implementer, test-writer, reviewer) and grow.
**Open:** promote to parallel fan-out once the loop is comfortable.
