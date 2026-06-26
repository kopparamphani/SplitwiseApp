# Deployment View

**Caveman:** where each box actually runs — first on your laptop, then on rented machines. Same app, two homes.

## Local (build & learn first)
- **Cluster:** kind (real upstream Kubernetes in Docker), multi-node so scheduling is visible.
- **Registry:** local Distribution registry (`registry:2`) for fast image pushes into kind.
- **Ingress:** Traefik (dashboard on).
- **Workloads:** 5 NestJS services + their PostgreSQL DBs, Kafka, SeaweedFS, the Vite web app.
- **GitOps:** Argo CD watching the repo's `k8s/` manifests; Sealed Secrets controller for secrets.
- **Observability:** Prometheus + Loki + Tempo + Grafana, fed by OpenTelemetry (added in stages).

## Production (graduate to)
- **Cluster:** kubeadm-built upstream Kubernetes on cheap Hetzner VMs (1 control-plane + 1–2 workers; ~€15–25/mo non-HA). Parity with local kind.
- **Registry:** GHCR (shared, CI-pushed).
- **Ingress:** Traefik → Kong later (unified ingress + API gateway).
- **Secrets:** Sealed Secrets → ESO + OpenBao later.
- Same manifests as local, via Kustomize overlays per environment.

## The flow (CI → CD)
```
push code → GitHub Actions: build image + run tests + push to GHCR
          → Actions bumps image tag in the repo's k8s/ manifests
          → Argo CD syncs the cluster to match Git
```

## Notes / open
- Monorepo-vs-polyrepo confirmed in Phase 4 (manifests-in-code leans monorepo).
- Production HA topology + etcd backups: deferred until needed.
- Diagram: a Structurizr Deployment view can be added to `workspace.dsl` when the manifests exist.
