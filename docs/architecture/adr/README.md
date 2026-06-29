# Architecture Decision Records (ADRs)

**Caveman:** a logbook of the big choices — *what* we chose, *why*, and *what we gave up*. Never deleted; superseded by a newer ADR if we change our minds.

## The log

| ADR | Decision | Status |
|-----|----------|--------|
| [0001](0001-microservices-split.md) | Split into 5 microservices (not a monolith) | Accepted |
| [0002](0002-database-per-service.md) | Each service owns its own database | Accepted |
| [0003](0003-diagrams-structurizr-mermaid.md) | Structurizr DSL for C4, Mermaid companion | Accepted |
| [0004](0004-event-driven-balance.md) | Balance is an event-fed read model | Accepted |
| [0005](0005-unified-typescript-stack.md) | Unified TypeScript stack | Accepted |
| [0006](0006-postgresql-everywhere.md) | PostgreSQL as the single DB engine | Accepted |
| [0007](0007-lean-communication.md) | Lean comms: REST now, gRPC later, gateway→Kong | Accepted |
| [0008](0008-kafka-event-bus.md) | Apache Kafka event bus | Accepted |
| [0009](0009-vite-react-web.md) | Vite + React web (not Next.js) | Accepted |
| [0010](0010-react-native-mobile.md) | React Native (Expo) mobile | Accepted |
| [0011](0011-seaweedfs-object-storage.md) | SeaweedFS object storage | Accepted |
| [0012](0012-local-kubernetes-kind.md) | Local Kubernetes: kind | Accepted |
| [0013](0013-registry-ghcr-local.md) | Registry: GHCR + local Distribution | Accepted |
| [0014](0014-ci-github-actions.md) | CI runner: GitHub Actions | Accepted |
| [0015](0015-cd-argocd-monorepo-manifests.md) | CD: Argo CD, manifests in code repo | Accepted |
| [0016](0016-ingress-traefik-then-kong.md) | Ingress: Traefik now → Kong later | Accepted |
| [0017](0017-observability-grafana-otel.md) | Observability: Grafana stack + OTel | Accepted |
| [0018](0018-secrets-sealed-then-eso.md) | Secrets: Sealed Secrets → ESO+OpenBao | Accepted |
| [0019](0019-production-kubeadm-hetzner.md) | Production: kubeadm on Hetzner | Accepted |
| [0020](0020-agents-roster-orchestration.md) | Agent roster & orchestration | Accepted |
| [0021](0021-mcp-servers.md) | MCP servers (GitHub/Playwright/Postgres) | Accepted |
| [0022](0022-polyrepo-structure.md) | Repo structure: Polyrepo (service-per-repo, docs+GitOps hub) | Accepted |

## Template
```
# ADR-NNNN — <title>
**Status:** Proposed | Accepted | Superseded by ADR-XXXX
**Date:** YYYY-MM-DD
## Context
## Decision
## Consequences
**Good:** / **Cost:** / **Open:**
```
