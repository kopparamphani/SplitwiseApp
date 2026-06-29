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

### password_reset_token
- `token_id` (key)
- `account_id` (link → account)
- `token_hash` (we store a hash, not the raw link)
- `expires_at`
- `used` (true/false — one-time use)

### session
- `session_id` (key)
- `account_id` (link → account)
- `created_at`, `last_seen_at`, `revoked` (for log-out / "log out everywhere")

**Rules baked in:** one email = one account; password rules + lockout threshold are LOCKED (see NFR doc + ADR-0024/0025).
