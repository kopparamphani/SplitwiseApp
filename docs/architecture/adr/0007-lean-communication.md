# ADR-0007 — Lean comms now, clear upgrade path
**Status:** Accepted
**Date:** 2026-06-19

## Context
Two conversations: apps→backend (edge) and service→service (internal). The 2026 realistic destination is hybrid (REST/GraphQL at the edge, gRPC internal), but adopting all of it on day one is over-engineering, and protocol mis-choices are expensive to undo.

## Decision
- **Edge:** REST + our existing OpenAPI contracts.
- **Internal:** REST to start; later convert **one** internal call to **gRPC** as a focused learning exercise (NestJS treats gRPC as just another transport).
- **Front door:** a thin **NestJS gateway service** first; graduate to **Kong** when we want real edge features.
- Heavy cross-service flow stays on the **event bus**, not sync calls.

## Consequences
**Good:** reaches the realistic hybrid destination without the day-one complexity tax; teaches gRPC deliberately.
**Cost:** one future migration of an internal call (intended, as a lesson).
**Open:** when to introduce Kong — aligns with Step 3 (Kubernetes).
