# ADR-0012 — Local Kubernetes: kind
**Status:** Accepted
**Date:** 2026-06-24

## Context
"Run on my machine first" needs a real cluster on the laptop. Options: kind (upstream K8s in Docker), k3d (lightweight k3s), minikube (VM).

## Decision
**kind** — real upstream Kubernetes as the local cluster.

## Consequences
**Good:** genuine upstream K8s = skills transfer cleanly; same tool reused as the CI cluster; easy multi-node so pod scheduling is visible; parity with kubeadm production (ADR-0019).
**Cost:** slightly heavier/slower to start than k3d; needs a small local registry alongside (ADR-0013).
**Open:** none. Fallback = k3d if the machine is RAM-constrained (8GB).
