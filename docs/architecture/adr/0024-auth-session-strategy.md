# ADR-0024 — Auth & session strategy: short JWT access + DB-tracked refresh
**Status:** Accepted
**Date:** 2026-06-29

## Context
Login must survive app restarts (REQ-ACC-02) AND logout must actually revoke. The Identity data model already has a `session` table built for revoking ("log out everywhere"). A pure stateless JWT can't be revoked once handed out, so we need server-tracked sessions. This decides the token shapes and password hashing.

## Decision
- **Access token = short-lived JWT, 15 minutes.** Clients send it as `Authorization: Bearer <token>`. Signed with a key stored via Sealed Secrets (ADR-0018).
- **Refresh token = long-lived (30 days), opaque, server-tracked.** Its row lives in the existing `session` table (`session_id`, `account_id`, `created_at`, `last_seen_at`, `revoked`). Web clients get it as an **httpOnly, Secure cookie**; mobile clients store it in **secure device storage**.
- **Logout** = flip `revoked = true` on that session row (not just drop the client token). **"Log out everywhere"** = revoke all sessions for the account.
- **Refreshing:** a valid, non-revoked refresh token mints a new access token (and may rotate the refresh token).
- **Password hashing = Argon2id**, OWASP-baseline params (record: memoryCost ~19 MiB, timeCost 2, parallelism 1; tune later).

Like: the access token is a day-pass that expires fast; the refresh token is your membership card the front desk can tear up any time.

## Consequences
**Good:** sessions are revocable; short access-token life = small blast radius if stolen; login survives restarts.
**Cost:** a DB read on every refresh; the `session` table grows — needs periodic cleanup of expired/revoked rows. Cross-cutting: every service validates the access token for now; the gateway will centralize this later.
**Open:** none. (References ADR-0002, ADR-0006, ADR-0018, and the identity data model `session` table.)
