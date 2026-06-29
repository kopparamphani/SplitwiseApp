# Non-Functional Requirements (quality attributes)

**Caveman:** not *what* the app does, but *how well* — fast enough, safe enough, for enough people. This is also where our parked decisions finally get pinned.

| Attribute | Aim (first pass) | Status |
|-----------|------------------|--------|
| Security | Passwords hashed (never plain); reset links one-time + expiring; lockout after repeated wrong tries; login badge required on every gateway call. | Direction set; exact numbers now LOCKED below |
| Money correctness | Splits reconcile to total; balances sum to zero; decimal math, never floating-point. | Locked (from requirements) |
| Consistency | Balance is eventually consistent (event-fed); the server is the one source of truth. | Locked (ADR-0004, REQ-PLT-03) |
| Availability | One service down must not take others down (separate DBs help). | Direction set |
| Performance | Balance reads are fast (pre-computed read model). Target numbers TBD when we have load expectations. | OPEN |
| Scalability | Services scale independently; Kubernetes handles adding copies when busy. | Revisit in Step 3 |
| Observability | Every service emits logs/metrics/traces so we can see what's happening. | Tooling chosen in Step 3 |
| Auditability | Edits/deletes record who + when; soft-delete, never hard-delete expenses. | Locked (from requirements) |
| Open-source only | Every tool/library must be open-source. | Locked (project rule) |

## LOCKED decisions (decided 2026-06-29)
1. **Password strength rule** — min 8 chars, ANY characters, NO forced composition; reject known-breached passwords. (NIST 800-63B; see ADR-0025.)
2. **Login lockout threshold** — 5 failed attempts → 15-minute lock. (See ADR-0024; data model `failed_login_attempts` + `locked_until`.)
3. **Reset-link expiry time** — 1 hour, one-time use. (Data model `password_reset_token`.)

## OPEN decisions you must make (I will NOT guess these)
These were "parked" in the requirements. They belong here. Each needs your call before the relevant code is built:
1. **Reminder frequency cap** (how often "you owe" nudges may fire).
2. **"Who wins" rule** for two people editing the same thing at once (Phase 3 detail).
3. **Trace sampling rate** (observability — what fraction of traces we keep).

> These are realistic to decide a bit later (when each feature is built), but they are listed here so none is forgotten or silently invented.
