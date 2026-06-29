# ADR-0025 — Reject known-breached passwords (HaveIBeenPwned k-anonymity)
**Status:** Accepted
**Date:** 2026-06-29

## Context
Our password rule follows NIST 800-63B: min 8 chars, any characters, no forced composition. That rule requires one more thing — reject passwords that are KNOWN to be breached. We need a way to check that without leaking the password.

## Decision
Check new/changed passwords against the **HaveIBeenPwned Pwned Passwords k-anonymity API**: send only the **first 5 chars of the SHA-1 hash** — the full password and full hash NEVER leave the service.
- **Offline/dev fallback:** a bundled local list of top-breached passwords.
- **Fail-open:** if HIBP is unreachable, allow the password but write an audit-log entry.
- A breached (or too-short) password is rejected to the client as **HTTP 422**.

Like: ask "does anyone here start with these 5 letters?" and check the answers yourself — you never say the whole word out loud.

## Consequences
**Good:** real breach protection; privacy-preserving (k-anonymity); free.
**Cost:** a runtime external dependency (mitigated by the bundled fallback + fail-open); fail-open means a breached password can slip through during an HIBP outage (accepted, and logged).
**Open:** none.

> Note: this is the one sanctioned external runtime dependency despite our "open-source only" rule — HIBP is a free service, not a bundled library.
