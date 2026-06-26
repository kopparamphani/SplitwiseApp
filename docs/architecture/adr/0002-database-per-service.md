# ADR-0002 — Each service owns its own database
**Status:** Accepted
**Date:** 2026-06-19

## Context
With 5 services, we must decide whether they share one database or each keep their own. A shared database is the easy path but is a known anti-pattern (the "distributed monolith"): services become secretly chained through shared tables, losing the independence that justifies microservices.

## Decision
**Database per service.** No service reads or writes another service's database. Cross-service data is obtained by asking the owning service (sync) or by listening to its events (async).

## Consequences
**Good:** a service can change its own schema without breaking others; one DB failing doesn't take all services down; forces clean, polite boundaries; each service can later pick the store that fits it.
**Cost:** no single "join everything" query — combined views are stitched from multiple services; data agreement across services is eventual (via events), not instant; more databases to run and back up (Kubernetes + Helm help here).
**Open:** which concrete database engine each service uses — Step 2 (tech choices).
