# ADR-0011 — SeaweedFS for receipt-photo object storage
**Status:** Accepted
**Date:** 2026-06-19

## Context
Photos live in object storage, not a database (Expense DB holds only the key/URL). MinIO was the long-time default, but in 2026 its community edition was archived/maintenance-only and its license shifted — failing both our open-source-only rule and the realism rule.

## Decision
**SeaweedFS** (Apache-2.0, S3-compatible). Strongest for small files (receipts are many small files), production-proven (Kubeflow's default), ships a Helm chart and Kubernetes CSI driver.

## Consequences
**Good:** clean license; best-fit performance; Kubernetes-ready for Step 3; access via signed/expiring links (per threat model).
**Cost:** multi-process deployment (master/volume/filer/S3 gateway) — extra but useful Step-3 practice.
**Open:** none. Lesson on file: prefer foundation-governed/open-governance projects to avoid single-vendor "rug-pulls."
