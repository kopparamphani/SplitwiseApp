# ADR-0022 — Repo structure: Polyrepo (service-per-repo, docs+GitOps hub)
**Status:** Accepted
**Date:** 2026-06-29

## Context
ADR-0015 picked Argo CD + manifests-in-the-code-repo and left one thing open: monorepo-vs-polyrepo, deferred to Phase 4. This is that final call. The real project goal is learning microservices/CI-CD/GitOps by doing, so we want the more realistic big-team shape.

## Decision
**Polyrepo.** Each piece gets its OWN GitHub repo.
- One repo per microservice: identity, people-groups, expense, balance, notification.
- One repo each for web, Android, iOS.
- This repo (`SplitwiseApp`) stops being a service and becomes the **docs + architecture + GitOps hub**: it holds all docs/ADRs/specs AND the Argo CD "App-of-Apps" that points at the service repos.
- **Shared API contracts (OpenAPI/AsyncAPI) stay here** at `docs/api/` as the single source of truth; service repos reference them.
- Each service repo carries its own `k8s/` manifests (consistent with ADR-0015's "manifests live in the code repo") and its own GitHub Actions CI workflow.

Resolves the open monorepo-vs-polyrepo item from ADR-0015. (ADR-0015 unchanged.)

## Consequences
**Good:** realistic big-team shape; each service owns its build + deploy + lifecycle; App-of-Apps gives one GitOps entry point; contracts in one hub = one source of truth.
**Cost:** many repos to wire and keep in sync; cross-service change spans repos; CI workflow duplicated per repo; contracts live apart from the code that uses them.
**Open:** naming convention for the service repos (not yet decided). Whether a separate gitops repo is ever split out from this hub later (not yet decided).
