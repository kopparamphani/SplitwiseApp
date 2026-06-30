# Threat Model (lightweight first pass)

**Caveman:** walk the camp fence and look for gaps *before* a thief does. This is a money + login app, so a short pass now is realistic, not paranoid. We deepen it as we build.

Method: quick STRIDE-style scan of the riskiest spots. (S=spoofing, T=tampering, R=repudiation, I=info leak, D=denial, E=escalation.)

| Spot | Worry | First-pass guard |
|------|-------|------------------|
| Login (Identity) | Spoofing: guessing passwords | Hashing + lockout (threshold OPEN) + Google option |
| Social login link | Escalation: takeover via an unverified third-party email | Standing rule: only link/create on a PROVIDER-VERIFIED email (e.g. Google email_verified=true). Applies to all current + future identity providers. An unverified email must never key an account (ADR-0024). |
| Password reset | Escalation: stealing an account via reset link | One-time, expiring, hashed token; don't reveal if email exists |
| API Gateway | Spoofing: calling a service without a valid badge | Verify session/token on every call; services trust only the gateway path |
| Money endpoints | Tampering: settle more than owed, edit others' splits | Server-side checks (sum = total, settle <= owed); never trust client math |
| Audit / disputes | Repudiation: "I never deleted that!" | Soft-delete + trail (who + when) on edits/deletes |
| Receipt photos | Info leak: someone reads another group's receipts | Photo access checked against group membership; signed/expiring photo links |
| Cross-service data | Info leak: a service reading another's DB | Database-per-service + id-only links (ADR-0002) |
| Events on the bus | Tampering/replay: fake or duplicated "expense.added" | Trusted internal bus; events carry ids + timestamps; consumers handle duplicates |

## Out of scope for now (revisit later)
- Rate-limiting / abuse protection at the edge (Step 3).
- Secrets management (how services hold keys) — Step 3 with Kubernetes.
- Full data-privacy / retention policy.
