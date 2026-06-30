# QA Test Cases — Iteration 1a, Identity Service

**Scope:** email + password **sign up, login, logout**.
**Covers:** REQ-ACC-01 (Sign Up) and REQ-ACC-02 (Log In / Log Out) — email+password paths only.
**Out of scope (later slices):** Google sign-in/login, password reset.

**Caveman:** this is the proof list. Each card says what to try, what counts as a win, and leaves room for the runner to write what really happened.

**Locked rules used (from `docs/quality/nfr.md`):**
- Password: min 8 chars, ANY characters, no forced mix; reject **known-breached** passwords.
- Lockout: **5** wrong tries → locked **15 minutes**.

**Status codes used (from `docs/api/identity.openapi.yaml`):**
- Sign up: `201` ok / `409` email taken / `422` bad email or weak/breached password.
- Login: `200` ok (+ token) / `401` wrong / `429` locked.
- Logout: `204` done.

**Format (project convention):** Objective / Test Data & Pre-requisites / Expected Result / Actual Result.
Runner fills Actual. Author runs nothing.

---

## REQ-ACC-01 — Sign Up

### TC-ACC-01-01 — New email + good password + display name → account made, logged in
- **Objective:** A brand-new visitor signs up and is logged in.
- **Test Data & Pre-requisites:** Email `newuser1@example.com` not in DB. Password `Tr0pic-Sunrise-92` (≥8 chars, not breached). display_name `Asha`. Endpoint `POST /auth/signup`.
- **Expected Result:** `201 Created`. Body is a TokenResponse: `access_token` (JWT), `token_type` = `Bearer`, `expires_in` = `900`. User now exists and is logged in. *Like: badge carved, gate already open.*
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-01-02 — Duplicate email → blocked
- **Objective:** Re-using an existing email is refused with a clear message.
- **Test Data & Pre-requisites:** Email `taken@example.com` already has an account. Password `Valid-Pass-123`. display_name `Bob`. `POST /auth/signup`.
- **Expected Result:** `409 Conflict`. No new account made. Clear "email already used" message. No token returned.
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-01-03 — Too-short password → blocked
- **Objective:** Password under 8 chars is refused.
- **Test Data & Pre-requisites:** Email `shortpw@example.com` (free). Password `Ab3$xy` (6 chars). display_name `Cara`. `POST /auth/signup`.
- **Expected Result:** `422 Unprocessable Entity`. No account made. Clear "password too short / min 8" message. No token.
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-01-04 — Known-breached password → blocked
- **Objective:** A long-enough but known-breached password is refused. *Like: a key everyone already copied — no good.*
- **Test Data & Pre-requisites:** Email `breached@example.com` (free). Password `password` (≥8 chars but on known-breached list). display_name `Dev`. `POST /auth/signup`.
- **Expected Result:** `422 Unprocessable Entity`. No account made. Clear "password is known/breached, pick another" message. No token. (Note: length alone passes; it fails the breached check.)
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-01-05 — Invalid email format → blocked
- **Objective:** An email that doesn't look like an email is refused.
- **Test Data & Pre-requisites:** Email `not-an-email` (no `@`/domain). Password `Valid-Pass-123`. display_name `Eve`. `POST /auth/signup`.
- **Expected Result:** `422 Unprocessable Entity`. No account made. Clear "email looks wrong" message. No token.
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-01-06 — Missing required field → blocked
- **Objective:** A signup missing a required field is refused. (Required: email, password, display_name.)
- **Test Data & Pre-requisites:** Body with email `nodisplay@example.com` + password `Valid-Pass-123` but **no display_name**. `POST /auth/signup`. (Repeatable for each missing field: missing email, missing password.)
- **Expected Result:** `422 Unprocessable Entity`. No account made. Clear "missing required field" message naming the missing field. No token.
- **Actual Result:** To be confirmed by qa-runner / automated suite.

---

## REQ-ACC-02 — Log In / Log Out

### TC-ACC-02-01 — Correct credentials → logged in, token returned
- **Objective:** A returning user logs in with the right email + password.
- **Test Data & Pre-requisites:** Account `login-ok@example.com` exists with password `Right-Pass-123`. Account is **not** locked (failed_login_attempts = 0). `POST /auth/login`.
- **Expected Result:** `200 OK`. TokenResponse: `access_token` (JWT), `token_type` = `Bearer`, `expires_in` = `900`. User is in. *Like: right key, gate opens.*
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-02-02 — Wrong password → refused
- **Objective:** Wrong password is rejected with a clear message; user stays out.
- **Test Data & Pre-requisites:** Account `login-wrong@example.com` exists with password `Right-Pass-123`. Submit password `Wrong-Pass-999`. Account not locked. `POST /auth/login`.
- **Expected Result:** `401 Unauthorized`. No token. Clear "incorrect" message. `failed_login_attempts` increases by 1.
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-02-03 — 5 failed attempts → account locked
- **Objective:** After 5 wrong tries, the account locks for 15 minutes (anti-guessing).
- **Test Data & Pre-requisites:** Account `lockme@example.com` exists with password `Right-Pass-123`, starting `failed_login_attempts` = 0, not locked. Submit `POST /auth/login` with wrong password 5 times in a row.
- **Expected Result:** Tries 1–4 → `401`. The **5th failed try** trips the lock: account is locked, `locked_until` set to now + 15 min. The 5th (and any further) try returns `429 Too Many Requests`. Clear "too many tries, locked, try later" message. No token at any point.
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-02-04 — Correct password while locked → still refused
- **Objective:** While locked, even the RIGHT password is refused until the lock ends. *Like: right key, but gate is barred for now.*
- **Test Data & Pre-requisites:** Account `lockme@example.com` from TC-ACC-02-03, currently locked (`locked_until` in the future). Submit `POST /auth/login` with the **correct** password `Right-Pass-123` before 15 min pass.
- **Expected Result:** `429 Too Many Requests`. No token. Clear "locked, try later" message. Lock not bypassed by correct password.
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-02-05 — Lock expires after 15 min → correct password works again
- **Objective:** Once the 15-minute lock passes, the right password lets the user in.
- **Test Data & Pre-requisites:** Account `lockme@example.com` was locked; wait until `locked_until` is in the past (or test harness advances clock past 15 min). Submit `POST /auth/login` with correct password `Right-Pass-123`.
- **Expected Result:** `200 OK`. TokenResponse returned. `failed_login_attempts` reset to 0. User is in.
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-02-06 — Logout → 204, session no longer usable
- **Objective:** A logged-in user logs out; the old session can't be used afterward.
- **Test Data & Pre-requisites:** Account `logout-me@example.com` is logged in (has a valid session / access token + refresh). Call `POST /auth/logout` with that session.
- **Expected Result:** `204 No Content`. Session ended. After logout, reusing the same session/refresh to reach a protected route or refresh a token fails (session invalid). *Like: hand back the badge — it no longer opens the gate.*
- **Actual Result:** To be confirmed by qa-runner / automated suite.

---

## Security / Behavior (cross-cutting — applies to all above)

### TC-ACC-SEC-01 — Password never returned in any response
- **Objective:** No endpoint ever echoes the password back.
- **Test Data & Pre-requisites:** Inspect responses from signup (`201`), login (`200`), and the error cases (`409`/`422`/`401`/`429`). Use a fresh account `secret-pw@example.com` / password `Tr0pic-Sunrise-92`.
- **Expected Result:** No response body or header contains the password (plain or otherwise) in any case — success or error. Only TokenResponse fields appear on success; only a message on errors.
- **Actual Result:** To be confirmed by qa-runner / automated suite.

### TC-ACC-SEC-02 — Password stored hashed (not plaintext)
- **Objective:** Confirm the password is stored safely, never in plain words.
- **Test Data & Pre-requisites:** Create account `hash-check@example.com` with password `Tr0pic-Sunrise-92`. QA verifies by **DB inspection** of the Identity service users table (via Postgres MCP / read-only query) for that user's stored credential.
- **Expected Result:** Stored value is an **Argon2id hash** (format begins `$argon2id$...`), not the plaintext `Tr0pic-Sunrise-92` and not a reversible/encoded copy of it. The plaintext password appears nowhere in the row. *Like: we keep a scrambled fingerprint of the key, never the key itself.*
- **Actual Result:** To be confirmed by qa-runner / automated suite.

---

*Total: 14 test cases — 6 sign up, 6 login/logout, 2 security/behavior.*
*Authored as documentation only. Actual Results to be filled by qa-runner / automated suite.*
