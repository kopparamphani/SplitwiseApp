# ADR-0017 — Observability: Grafana stack + OpenTelemetry
**Status:** Accepted
**Date:** 2026-06-24

## Context
Observability (a stated goal) = metrics, logs, traces. Two families: Grafana stack (Prometheus/Loki/Tempo) vs ELK. Plus an instrumentation layer.

## Decision
**Prometheus** (metrics) + **Loki** (logs) + **Tempo** (traces), viewed in **Grafana**; services instrumented via **OpenTelemetry**. Added in stages: metrics → logs → traces.

## Consequences
**Good:** cloud-native default; lighter/cheaper than ELK (Loki/Tempo index only metadata); all three pillars correlated in one Grafana pane; OTel = vendor-neutral, no backend lock-in; installs via `kube-prometheus-stack` Helm chart (ties to Helm learning).
**Cost:** several components to run (staged rollout mitigates).
**Open:** trace sampling rate (start 1–5%).
