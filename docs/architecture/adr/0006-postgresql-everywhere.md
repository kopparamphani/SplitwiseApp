# ADR-0006 — PostgreSQL as the single database engine (one DB per service)
**Status:** Accepted
**Date:** 2026-06-19

## Context
ADR-0002 fixed database-per-service. This decides the engine. Running many different engines for variety is needless operational pain; the realistic pattern is one workhorse, with a specialist only where a service truly needs it.

## Decision
**PostgreSQL** for all 5 services (separate databases, same engine), accessed from NestJS via a TypeScript ORM (Prisma or Drizzle — sub-choice at build time).

## Consequences
**Good:** safest choice for money/consistency; one engine to learn, back up, monitor; JSONB covers flexible-document needs; first-class TS ORM support; SQL skill transfers to enterprise work.
**Cost:** if a service ever needs document/horizontal-write scaling we'd revisit (none does at our scale).
**Open:** physical schema (column types, indexes) per service — done when each service is built.
