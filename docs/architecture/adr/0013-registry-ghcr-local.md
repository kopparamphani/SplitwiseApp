# ADR-0013 — Container registry: GHCR + local Distribution
**Status:** Accepted
**Date:** 2026-06-24

## Context
Two contexts: a fast local push loop for kind, and a shared/CI registry. Open-source-only rule applies; Docker Hub rate-limits and MinIO-style license risk are out.

## Decision
- **Local dev loop:** the open-source **Distribution** registry (`registry:2`) container, wired to kind.
- **Shared / CI:** **GHCR** (GitHub Container Registry) — GitHub-native, OCI-standard, zero-credential pushes from Actions, also stores Helm charts.

## Consequences
**Good:** no credential plumbing in CI; free at our scale; portable (OCI); GHCR sits inside the already-chosen GitHub world.
**Cost:** GHCR is a hosted service, not self-hosted OSS (acceptable under the GitHub carve-out).
**Open:** Harbor penciled as a later self-hosted module for vulnerability scanning + SBOMs.
