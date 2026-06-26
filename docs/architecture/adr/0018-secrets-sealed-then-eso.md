# ADR-0018 — Secrets: Sealed Secrets now → ESO + OpenBao later
**Status:** Accepted
**Date:** 2026-06-24

## Context
GitOps can't hold raw secrets in Git. Options: Sealed Secrets (encrypt into Git) vs External Secrets Operator + a vault. HashiCorp Vault moved to BSL (not OSI-open); OpenBao is the open (MPL-2.0) fork.

## Decision
**Sealed Secrets** now (encrypted secrets committed beside manifests). **ESO + OpenBao** later as the production-grade upgrade.

## Consequences
**Good:** simplest start, fits manifests-in-code-repo, no extra service; the natural stepping-stone the field actually walks; OpenBao keeps the upgrade open-source (avoids Vault BSL).
**Cost:** Sealed Secrets keys are cluster-bound (back up the sealing key); migrating to ESO later is real work (intended lesson).
**Open:** none.
