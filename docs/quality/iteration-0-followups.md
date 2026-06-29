# Iteration 0 — Reviewer Follow-ups

**Caveman:** walking skeleton works, but reviewer spotted loose ends. Write them down so they don't get lost.
Severity tags: **[SHOULD]** = fix before copying skeleton to other services · **[NICE]** = good hygiene, do when it matters.

## [SHOULD] Wire the CI→manifest image-tag handoff
CI pushes `:<git-sha>` + `:latest`, but nothing writes the SHA into `identity/k8s/deployment.yaml`.
Deployment is pinned to `:latest`, `imagePullPolicy: IfNotPresent`, Argo `selfHeal` + `prune` on.
**Effect:** after the first deploy, new builds don't roll out — the GitOps loop is frozen on `:latest`.
Decide the mechanism BEFORE copying the skeleton to the other services:
- (a) CI commits the SHA bump back into `k8s/` (sed, or kustomize `images: newTag`), or
- (b) Argo Image Updater, or
- (c) explicit manual bump for now.

Like: a mailbox that never gets a new address — mail keeps going to the old house.
Ties to ADR-0013 ("Argo deploys the immutable SHA").

## [SHOULD] Add CI `concurrency` group
Add `group: ci-${{ github.ref }}`, `cancel-in-progress: true` so rapid pushes don't race two `:latest` image pushes.
Bake into the template before service #2.

Like: one cook at the stove, not two fighting over the same pot.

## [SHOULD] Split test scripts + add lint
`npm test` and `test:e2e` are identical; no unit-test script, no ESLint/Prettier gate —
even though CLAUDE.md claims style conventions. Set the convention right from service #1.

## [NICE] `bootstrap()` error handling
In `src/main.ts`, add `.catch` → `process.exit(1)` so boot failures exit clean for Kubernetes.

Like: if the engine won't start, turn off the key — don't sit there grinding.

## [NICE] Graceful shutdown
`app.enableShutdownHooks()` + `terminationGracePeriodSeconds`. Matters once DB / Kafka arrive.

## [NICE] app-of-apps `apps/` must hold ONLY Argo Application YAML
Root uses `directory.recurse`; a stray values file in there would error the sync.

## [NICE] Read-only root filesystem
Fine now (app writes nothing). When a service needs scratch space, add a `/tmp` emptyDir.
