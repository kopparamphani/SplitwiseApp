# ADR-0023 — ORM: Drizzle (drizzle-kit for migrations), stack-wide
**Status:** Accepted
**Date:** 2026-06-29

## Context
ADR-0006 fixed PostgreSQL per service and left the ORM as a build-time sub-choice (Prisma or Drizzle). Now we pick — one ORM for all 5 services, no per-service drift.

## Decision
**Drizzle ORM** for every service, with **drizzle-kit** for migrations. Migrations are checked into each service repo.

## Consequences
**Good:** SQL-close and lightweight — you see the SQL, not a black box; TypeScript-native types; fast, small runtime; fits the QA-first learner who wants to learn SQL closely. Chosen over Prisma deliberately for this reason. Like: a hand tool you feel working, not a machine that hides the work.
**Cost:** more manual than Prisma; smaller ecosystem and thinner docs; queries are more hand-written.
**Open:** none. (References ADR-0006.)
