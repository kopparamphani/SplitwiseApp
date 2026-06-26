# ADR-0001 — Split the app into 5 microservices
**Status:** Accepted
**Date:** 2026-06-19

## Context
The project's core goal is to *learn microservices done the realistic way* and build a production-grade app. A single big app (monolith) would be simpler to start but would not teach the target skills (independent services, orchestration) and is harder to scale and operate per-part.

## Decision
Build **5 single-job services** behind one API Gateway: Identity, People & Groups, Expense, Balance, Notification. (User & Friends and Group were merged into People & Groups to avoid over-splitting.)

## Consequences
**Good:** each service is built, tested, deployed, and restarted on its own; clean boundaries; directly exercises the learning goals.
**Cost:** more moving parts to run; cross-service screens need stitching; needs disciplined contracts between services.
**Open:** component-level breakdown of any service is deferred until that service proves complex enough to need it.
