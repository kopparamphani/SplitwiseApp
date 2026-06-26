# ADR-0014 — CI runner: GitHub Actions
**Status:** Accepted
**Date:** 2026-06-24

## Context
CI (build/test/produce image) is a separate job from CD (deploy). This ADR is only the CI runner. We're on GitHub + GHCR already.

## Decision
**GitHub Actions** as the CI runner: build image, run unit/integration/API/automation tests, push to GHCR — all GitHub-native.

## Consequences
**Good:** the mainstream 2026 pattern (GitHub Actions for CI + Argo CD for CD); zero glue to GitHub/GHCR; built-in token, no secrets to wire.
**Cost:** hosted service (GitHub carve-out). Jenkins/Tekton would mean more self-hosted ops — deferred as optional later learning.
**Open:** add supply-chain steps later (image scan, signing) — natural Harbor re-entry point.
