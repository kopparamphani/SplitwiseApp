# GitOps — Argo CD App-of-Apps (hub repo)

This folder is the **CD control plane** for Splitwise (ADR-0015 Argo CD,
ADR-0022 polyrepo). The app *code* and its *k8s manifests* live in each
service's **own** repo. This hub only holds the Argo `Application` objects that
tell Argo where to find those manifests.

## Layout

```
gitops/
  app-of-apps.yaml      # ROOT app. Watches gitops/apps/. Install this one thing.
  apps/
    identity.yaml       # CHILD app. Points at the identity repo's k8s/ folder.
    <next-service>.yaml  # add more here, one file per service
  README.md             # this file
```

**App-of-Apps idea:** you install ONE root Application. It watches `gitops/apps/`.
Every manifest in there is itself an Argo Application (one per microservice).
Add a service = drop one file in `apps/`. Argo notices and deploys it.
Like: one master switch wiring up all the room lights.

## How the pieces connect

```
gitops/app-of-apps.yaml  --watches-->  gitops/apps/*.yaml
gitops/apps/identity.yaml --watches-->  identity repo  /k8s  --> namespace: splitwise
```

- Sync is **automated** with **selfHeal** + **prune** ON (ADR-0015):
  drift gets reverted, deleted-from-git resources get removed.
- `CreateNamespace=true` makes the `splitwise` namespace if missing.

## Install (once Argo CD is running in the cluster)

```bash
# Apply the root. It pulls in every child app under gitops/apps/.
kubectl apply -n argocd -f gitops/app-of-apps.yaml

# Watch them converge.
kubectl get applications -n argocd
```

## Add the next service later

1. In the **new service repo**, add a `k8s/` folder (namespace, deployment,
   service, ingress, kustomization) — mirror `identity`.
2. In **this** hub, copy `apps/identity.yaml` to `apps/<service>.yaml` and edit:
   - `metadata.name`
   - `source.repoURL` (the new service repo)
   - `destination.namespace` (usually still `splitwise`)
3. Commit + push the hub. Argo's root app auto-syncs and the new service appears.

## Notes / flagged defaults

- `repoURL`s use `https://github.com/kopparamphani/...` placeholders. Update them
  to the real remotes once the repos are pushed to GitHub.
- Image tags: CI pushes both the **git SHA** (immutable) and `latest`. Argo
  should deploy the **SHA** — bump it in the service repo's `k8s/deployment.yaml`
  (ADR-0013). The current `:latest` there is a placeholder.
- Argo CD itself is assumed installed in the `argocd` namespace. Installing Argo
  is a cluster bootstrap step, not part of this GitOps tree.
