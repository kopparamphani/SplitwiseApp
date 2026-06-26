# ADR-0003 — Structurizr DSL for C4, Mermaid as companion
**Status:** Accepted
**Date:** 2026-06-19

## Context
We need diagram tooling that is open-source and docs-as-code (text, version-tracked). For the C4 model specifically, Mermaid's C4 support is experimental with a weak layout engine at scale. Structurizr (by C4's author) is model-first: define once, render many consistent views. A SaaS tool like Lucid was rejected (not open-source, not version-tracked) per project rules.

## Decision
Use **Structurizr DSL** as the primary tool for the **C4 model** (Context + Container now, Component/Deployment later), rendered locally via Structurizr Lite in Docker. Use **Mermaid** as the companion for lightweight sequence/flow diagrams that render natively in GitHub.

## Consequences
**Good:** one C4 model produces consistent views; open-source; lives in the repo; fits CI/CD; Mermaid covers quick diagrams with zero setup and native GitHub rendering.
**Cost:** Structurizr has a steeper learning curve and needs a local Docker renderer (also a useful early Docker exercise).
**Open:** none.
