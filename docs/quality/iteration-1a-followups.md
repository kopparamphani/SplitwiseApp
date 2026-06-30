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
