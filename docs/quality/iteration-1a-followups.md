# Iteration 1a — follow-ups & known gaps

Tracked list of reviewer's deferred items + known gaps from Identity 1a.
Plain words. Severity tag on each. Pick up when the noted trigger lands.

### [DECISION-DEFERRED] Cross-origin cookie + CSRF
Today the refresh cookie is `SameSite=Lax`. Lax only works when web SPA and
gateway share one origin. Once they live on DIFFERENT origins (Iterations 6+),
the cookie needs `SameSite=None; Secure` AND a CSRF defense (the refresh POST is
cookie-authenticated, so it's a CSRF target). Decide the exact shape when the web
client + gateway get built. Do NOT blindly copy `Lax` into a template — it will
silently break cross-origin.
Like: a key that only opens the door if you're already inside the house.

### [SHOULD] Durable audit for HIBP fail-open
When HIBP (breached-password check) is down, we fail OPEN — we skip the check and
let signup through. Right now that only logs a `logger.warn`. CLAUDE.md mandates a
real audit trail (who + when), and a log line is not durable or queryable. Wire a
proper audit record once the audit mechanism exists.

### [SHOULD] Postgres pool hardening
`postgres(url)` runs on driver defaults. Before this DB-access pattern gets copied
to other services, set explicit `ssl` (needed for the Hetzner / kubeadm prod target)
and pool `max` — both via env. Lock it down once, then reuse.

### [NICE] `session.account_id` index
Needed for "log out everywhere" (find all of one account's sessions) and for
expired-row cleanup. Add the index when that feature lands.

### [NICE] JWT-guard tests
Add tests that reject an expired or forged Bearer token. No JWT-protected route
exists in 1a, so add these once the first guarded route appears.

### [DONE] Refresh-token hashing + rotation
Fixed in 1a. Refresh tokens are stored as sha256 hashes (raw token never stored),
and rotated on every `/auth/refresh`. Noted here for the record.

### [DONE] Login timing-attack defense
Fixed in 1a. Login path no longer leaks "does this email exist?" via response
timing. Noted here for the record.

## Iteration 1b — Google sign-in

### [DONE 1b] Google sign-in
email_verified enforced on link/create; no sub-rebind; concurrent-signup race handled.

### [TODO] Real audit row for Google link
Replace the Google-link audit LOG line with a real audit-table row once an audit
table exists.

## Iteration 1c — password reset

### [DONE 1c] Password reset
One-time sha256 token, 1h expiry, atomic consume, constant-time request (no
enumeration), all-sessions-revoked, sibling-ticket invalidation.

### [TODO] Rate-limit reset/login/signup
Rate-limit /auth/password-reset/request (and login/signup) — @nestjs/throttler
(cross-cutting).

### [TODO] Reaper for password_reset rows
Reaper job to prune expired/used password_reset rows.

### [TODO] Durable reset email
Fire-and-forget reset email is in-process only; move to a durable outbox/queue
for prod.

### [DEPLOY] New reset-email env
New env for deploy: SMTP_HOST, SMTP_PORT, SMTP_FROM, APP_BASE_URL (Mailpit for
local dev; real SMTP as a Sealed Secret in prod).
