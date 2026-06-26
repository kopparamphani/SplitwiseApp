# ADR-0015 — CD/GitOps: Argo CD, manifests in the code repo
**Status:** Accepted
**Date:** 2026-06-24

## Context
Argo CD (a stated learning goal) is the CD operator: it watches Git and reconciles the cluster. Sub-choice: where the K8s manifests live — separate config repo (recommended best practice) vs same repo as code.

## Decision
**Argo CD** for GitOps CD. Manifests live **in the same repo as the code** (per `k8s/` folders), per user choice — leans toward a monorepo (confirm in Phase 4).

## Consequences
**Good:** Git = source of truth; drift detection + auto-sync; simplest day-one layout; one place to look.
**Cost:** every code commit also triggers an Argo reconciliation check; PR reviews mix code + deploy changes. (Best practice is a separate config repo; accepted trade-off for simplicity.)
**Open:** monorepo-vs-polyrepo final call = Phase 4. Kustomize overlays + App-of-Apps + Argo Rollouts (canary) = later modules.
