# Identity Service — data model

Owns: accounts and how a person proves who they are. Never stores expense or group data.

### account
- `account_id` (key)
- `email` (unique)
- `display_name`  *(note: profile detail also mirrored in People; Identity keeps the minimum to log you in)*
- `password_hash` (nullable — null for Google-only accounts; never plain text)
- `auth_provider` (`local` | `google` | `both`)
- `google_subject_id` (nullable, unique — Google's stable user id)
- `created_at`, `updated_at`

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

**Rules baked in:** one email = one account; password rules + lockout threshold are OPEN (see NFR doc).
