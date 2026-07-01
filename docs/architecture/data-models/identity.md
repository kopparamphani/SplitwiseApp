# Identity Service — data model

Owns: accounts and how a person proves who they are. Never stores expense or group data.

### account
- `account_id` (key)
- `email` (unique)
- `display_name`  *(note: profile detail also mirrored in People; Identity keeps the minimum to log you in)*
- `password_hash` (nullable — null for Google-only accounts; never plain text)
- `auth_provider` (`local` | `google` | `both`)
- `google_subject_id` (nullable, unique — Google's stable user id)
- `failed_login_attempts` (integer, default 0 — count of wrong-password tries; resets to 0 on a good login)
- `locked_until` (timestamptz, nullable — set to now+15min when attempts hit 5; login refused while now < locked_until)
- `created_at`, `updated_at`

*(note: failed_login_attempts + locked_until are the lockout memory — 5 bad tries slams the door for 15 min. See ADR-0024 / NFR.)*

### password_reset
*(note: one row per reset request. We store a hash of the token, never the raw link. One-time: once used_at is stamped it can't be reused.)*
- `reset_id` (uuid, key)
- `account_id` (link → account)
- `token_hash` (text, NOT NULL, unique — sha256 of the one-time token; raw token lives ONLY in the emailed link, never in the DB)
- `expires_at` (timestamptz, NOT NULL — issued_at + 1 hour; a link past this is dead)
- `used_at` (timestamptz, nullable — stamped when the token is consumed; one-time use)
- `created_at`

### session
- `session_id` (key)
- `account_id` (link → account)
- `token_hash` (text, NOT NULL, unique — sha256 of the opaque refresh token; raw token is NEVER stored, only handed to the client)
- `expires_at` (timestamptz, NOT NULL — refresh session dies here: issued_at + 30 days; refresh refused once now > expires_at)
- `created_at`, `last_seen_at`, `revoked` (for log-out / "log out everywhere")

### Indexes (new in 1c)
- `session.account_id` — find all of one account's sessions fast (for "log out everywhere" on password reset + cleanup).
- `password_reset.account_id` — find/invalidate an account's sibling reset tickets fast.

**Rules baked in:** one email = one account; password rules + lockout threshold are LOCKED (see NFR doc + ADR-0024/0025).
