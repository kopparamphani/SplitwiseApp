# CLAUDE.md — Expense Tracker (Splitwise-parity, open-source)

Project memory. Claude Code auto-loads this every session. Keep under ~200 lines.
Plain-word tech terms → `glossary.md`. Full detail → `docs/`. Decisions with rationale → `docs/architecture/adr/`.

## What we're building
Production-grade expense tracker: **web + Android + iOS**, Splitwise feature-parity (Release 1).
**The real goal is learning by doing:** microservices, Kubernetes, CI/CD, Argo CD, observability, app dev,
GitHub, docs-as-code, Helm, YAML, agents + orchestration. The app is the vehicle; the skills are the point.

## How to work with me (non-negotiable)
- Start every reply with: (a) confirm what I asked, (b) what you'll do next. Then proceed.
- One phase/step at a time. Never jump ahead or decide for me. Wait for my explicit "go".
- When unsure, ASK. Never invent values (password rules, lockout, expiry) — surface them.
- Caveman style: few words, plain language, concrete "Like:" analogies. I'm QA, not a developer.
- Realistic over easy. Open-source only (prefer foundation/open-governance projects).

## Code & test conventions
- Comments caveman-style: simple, few words, explain INTENT.
- Test cases: **Objective / Test Data & Pre-requisites / Expected Result / Actual Result**.
- Money exact (decimal, never float); splits reconcile to total; group balances sum to zero; rounding penny → payer.
- Audit trail on edits/deletes (who + when); expenses soft-deleted, never hard-deleted.
- Docs-as-code: keep docs true to code; ADRs are append-only (supersede, don't delete).

## Locked stack (see ADRs for the why)
- **Architecture:** 5 microservices + API gateway; database-per-service; event-driven. (0001,0002,0004)
- **Services:** Identity, People & Groups, Expense, Balance (event-fed read model), Notification.
- **Language everywhere — TypeScript:** NestJS + React/Vite + React Native/Expo. (0005,0009,0010)
- **DB:** PostgreSQL per service. (0006)  **ORM:** Drizzle + drizzle-kit, stack-wide. (0023)  **Comms:** REST now, one gRPC later, gateway→Kong. (0007)
- **Auth:** short JWT access (15m) + DB-tracked opaque refresh sessions (revocable); Argon2id; reject breached pwds via HIBP. (0024,0025)
- **Event bus:** Apache Kafka. (0008)  **Object storage:** SeaweedFS. (0011)
- **Local cluster:** kind. (0012)  **Registry:** GHCR + local Distribution. (0013)
- **CI:** GitHub Actions. (0014)  **CD/GitOps:** Argo CD, manifests in code repo. (0015)
- **Repos:** Polyrepo — each service owns repo+k8s+CI; this repo = docs+GitOps hub (App-of-Apps); contracts in docs/api. (0022)
- **Ingress:** Traefik → Kong later. (0016)
- **Observability:** Prometheus+Loki+Tempo+Grafana via OpenTelemetry, staged. (0017)
- **Secrets:** Sealed Secrets → ESO+OpenBao later. (0018)
- **Production:** kubeadm on Hetzner VMs (parity with kind). (0019)
- **Diagrams:** Structurizr C4 + Mermaid. (0003)

## Agents & orchestration (Claude Code subagents — see `.claude/agents/`, ADR-0020/0021)
9 agents: architect-reviewer, implementer, test-writer, manual-qa, qa-runner, api-qa, reviewer, devops, docs.
Pipeline (sequential first, parallel pairs later):
architect-reviewer → implementer → test-writer+manual-qa → qa-runner+api-qa → reviewer → devops+docs.
Main session orchestrates (delegates, never edits). Least privilege: reviewers/architect read-only; qa run-only; manual-qa/docs markdown-only.
**MCP:** GitHub, Playwright (qa-runner), Postgres. Atlassian + Lucid dropped.

## Release scope
- **R1:** accounts (incl. Google + reset), friends, groups (incl. non-app placeholders), expenses (multi-payer, recurring),
  all 5 split methods, balances, debt-simplify (ON by default), settle up, manual category, in-app notifications,
  web → Android → iOS, single currency.
- **R2 (parked):** multi-currency + auto-convert, receipt OCR + auto-category, reports/charts, offline+sync.

## Open decisions still mine (do NOT invent — ask). Tracked in docs/quality/nfr.md
reminder frequency cap · simultaneous-edit "who wins" rule · trace sampling rate.

## Where things live
- `glossary.md` · `docs/requirements-spec.md` (REQ-* + QA seeds) · `docs/architecture/workspace.dsl` (C4)
- `docs/architecture/adr/` (0001–0025) · `docs/architecture/data-models/` · `docs/architecture/sequence-diagrams/`
- `docs/api/` (OpenAPI + AsyncAPI) · `docs/quality/` (test-strategy, nfr, threat-model) · `docs/deployment/`
- `.claude/agents/` (9 subagents + orchestration.md) · `.mcp.json` (MCP config)
- Render C4: `docker run -it --rm -p 8080:8080 -v "<path>/docs/architecture:/usr/local/structurizr" structurizr/structurizr local`

## Roadmap & status (update as we go)
- ✅ P1 Brainstorm · ✅ P2 Requirements (signed off)
- ✅ P3 Design: Step1 C4 · Step2 tech · Step3 platform · Step4 agents/MCP · Step5 docs rebuild (this bundle)
- ✅ P3 Step 6 — transition to Claude Code
- ✅ P4 Planning into iterations (plan: 9 iterations, walking skeleton first)
- 🔄 **P5 Execution (current)** — ✅ Iteration 0 walking skeleton (identity: CI green + Argo CD GitOps deploy verified on kind) · ⏭ next: Iteration 1 Identity accounts

## When in doubt
Re-read the relevant ADR before changing what it decided. Contradiction → stop, propose a superseding ADR.
