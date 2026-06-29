# Iteration 0 — Walking Skeleton QA Test Cases (identity service)

This is Iteration 0: plumbing only. No business logic yet. Goal is to prove the whole pipeline works end to end — the app builds, ships, and runs. Like: lay the train tracks before any train. We check the app boots and answers health checks, tests run, a Docker image builds and runs, CI builds and pushes the image, and Argo CD deploys it to the local kind cluster. We do NOT test login, accounts, or any real feature here — that comes later.

Format (project convention): **Objective / Test Data & Pre-requisites / Expected Result / Actual Result**.

---

## TC-0-01 — App boots and health endpoints answer (local)

**Objective**
Prove the app starts on the dev machine and both health endpoints answer.

**Test Data & Pre-requisites**
- identity repo cloned.
- Node deps installed.
- App started locally (default port).

**Expected Result**
- `GET /health/live` returns HTTP 200 with body `{"status":"ok"}`.
- `GET /health/ready` returns HTTP 200 with body `{"status":"ready"}`.

**Actual Result**
PASS. Both returned exactly that: `/health/live` 200 `{"status":"ok"}`, `/health/ready` 200 `{"status":"ready"}`.

---

## TC-0-02 — Automated tests run green

**Objective**
Prove the test suite runs and passes.

**Test Data & Pre-requisites**
- identity repo cloned, deps installed.
- Run `npm test` in the identity repo.

**Expected Result**
- Test command finishes with no failures.
- All end-to-end tests pass.

**Actual Result**
PASS. 2/2 e2e tests green.

---

## TC-0-03 — Docker image builds and runs

**Objective**
Prove the app packs into a Docker image and runs inside a container.

**Test Data & Pre-requisites**
- Docker installed and running.
- Multi-stage Dockerfile in identity repo.
- Build the image, then run a container from it.

**Expected Result**
- Multi-stage build finishes, image created.
- Container boots and stays Up.
- `GET /health/live` inside the container returns HTTP 200 `{"status":"ok"}`.

**Actual Result**
PASS. Image built, container Up, `/health/live` returned 200 with `{"status":"ok"}`.

---

## TC-0-04 — CI pipeline builds, tests, and pushes image (GitHub Actions)

**Objective**
Prove CI runs on push to main: it builds, tests, and ships the image to the registry.

**Test Data & Pre-requisites**
- GitHub Actions workflow in identity repo.
- Push a commit to `main`.
- GHCR registry reachable.

**Expected Result**
- build-test job runs and succeeds.
- image job runs and succeeds.
- Image pushed to GHCR, tagged with the git SHA and `latest`.

**Actual Result**
PASS. Both jobs success. Image pushed to GHCR tagged with git SHA + `latest`. CI run 28355501221.

---

## TC-0-05 — GitOps deploy via Argo CD (local kind)

**Objective**
Prove Argo CD deploys the identity service from Git into the kind cluster and it runs healthy.

**Test Data & Pre-requisites**
- Local kind cluster running.
- Argo CD installed in the cluster.
- identity `k8s/` manifests in GitHub.
- Namespace `splitwise` exists (or created by deploy).

**Expected Result**
- Argo CD reads identity `k8s/` from GitHub and deploys to namespace `splitwise`.
- Pod reaches 1/1 Running.
- Health endpoints answer 200 through the Service.

**Actual Result**
PASS. identity app Synced. Pod 1/1 Running, 0 restarts. `/health/live` and `/health/ready` both 200 via port-forward.

---

## TC-0-06 — App-of-Apps root resolves

**Objective**
Prove the Argo root Application reads the hub repo and manages the identity child app.

**Test Data & Pre-requisites**
- Argo CD root Application configured to watch the hub repo.
- Hub repo accessible to Argo CD.

**Expected Result**
- Root Application reads the hub repo.
- Root Application manages the identity child app.
- Root shows Synced + Healthy; identity child shows Synced.

**Actual Result**
PASS (after hub repo made public). `splitwise-root` Synced + Healthy; identity child Synced.

---

## TC-0-07 — Probes wired correctly and container hardened

**Objective**
Prove liveness/readiness probes point at the right paths and the container runs locked down without crashing.

**Test Data & Pre-requisites**
- identity Deployment manifest with probes and security context.
- Pod deployed to kind cluster.

**Expected Result**
- Liveness probe points at `/health/live`.
- Readiness probe points at `/health/ready`.
- Container runs as non-root with a read-only root filesystem.
- Pod stays up, no crashes.

**Actual Result**
PASS. Pod 1/1, 0 restarts. Non-root, read-only root filesystem, no crash.

---

## Known limitations / notes

- **"Progressing", not fully Healthy — cosmetic.** The identity app shows "Progressing" only because the Ingress has no external address. Traefik is ClusterIP and kind has no LoadBalancer, so there is no public IP to report. The actual workload is healthy and answering. Like: house is fine, only the street sign out front is missing.
- **Proxy workaround in this environment.** A Zscaler TLS-intercepting proxy was in the way. We had to pre-load images into kind by hand and add a CA bundle to Argo so it could reach github.com. This is an environment thing, not a code bug.
- **npm audit advisories.** Some advisories come from transitive (deep, indirect) dependencies in the toolchain. The dependency policy (what we allow, what we block) is a decision for later.
