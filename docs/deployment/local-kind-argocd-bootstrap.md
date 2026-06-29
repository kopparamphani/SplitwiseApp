# Local Bootstrap — kind + Argo CD (GitOps)

**Caveman:** how to build the local cluster from nothing, so a rebuild is repeatable.
Same flow each time: make cluster → put Argo in → point Argo at Git → watch it sync.

## Prereqs
- `docker` (engine running)
- `kind` (Kubernetes in Docker)
- `kubectl`
- `helm`
- `argocd` CLI

## Steps
1. **Make the cluster** named `splitwise`:
   ```
   kind create cluster --name splitwise
   ```
2. **Install Argo CD** (stable upstream manifests):
   ```
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```
3. **Install Traefik** via Helm (ClusterIP service):
   ```
   helm repo add traefik https://traefik.github.io/charts
   helm install traefik traefik/traefik --set service.type=ClusterIP
   ```
4. **Apply the app-of-apps** (root Argo Application that pulls in the rest):
   ```
   kubectl apply -f gitops/app-of-apps.yaml
   ```
5. **Verify** all Applications report Synced:
   ```
   kubectl get applications -n argocd
   ```
6. **Reach a service** by port-forward:
   ```
   kubectl -n <ns> port-forward svc/<svc> <host>:80
   ```

## Argo CD UI access
- Port-forward the server:
  ```
  kubectl -n argocd port-forward svc/argocd-server 8081:443
  ```
- Open `https://localhost:8081`. User `admin`.
- Initial password:
  ```
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
  ```
  (base64-decode the value.)

## Zscaler / corporate TLS-proxy note (environmental — important)
A TLS-intercepting proxy (e.g. Zscaler) breaks two things with
`x509: certificate signed by unknown authority`:
- in-cluster **image pulls**, and
- Argo's **git clone** of the repo.

**This is NOT a defect in the committed manifests — it is environment-specific.**

Workarounds that worked:
1. **Image pulls:** pre-pull images on the host, import into the kind node's containerd,
   then patch the Argo/Traefik workloads to `imagePullPolicy: IfNotPresent`.
   Like: carry the groceries in yourself when the delivery truck gets stopped at the gate.
2. **Git clone:** add the corporate Root CA bundle to the `argocd-tls-certs-cm` ConfigMap,
   keyed by `github.com`, then restart `argocd-repo-server`.

## Cleanup
```
kind delete cluster --name splitwise
```
