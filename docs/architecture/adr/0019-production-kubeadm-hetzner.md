# ADR-0019 — Production target: kubeadm on Hetzner
**Status:** Accepted
**Date:** 2026-06-24

## Context
"Graduate to production" needs a real remote cluster, open-source and cheap. Options: self-managed (kubeadm = vanilla, k3s = light) on cheap VMs, or managed K8s (proprietary, costs).

## Decision
**Self-managed upstream Kubernetes via kubeadm** on a few cheap **Hetzner** VMs.

## Consequences
**Good:** fully open-source; parity with local kind (both upstream K8s — avoids local/prod drift); deepest real-cluster learning (bootstrap etcd, CNI, upgrades); ~€15–25/mo non-HA.
**Cost:** heaviest ops (etcd, certs, upgrades). Fallback = k3s via kube-hetzner (lighter, slight parity drift).
**Open:** HA topology + backups when it matters.
