# ADR-0004 — Balance is an event-fed read model
**Status:** Accepted
**Date:** 2026-06-19

## Context
Balances (who owes whom) are derived from expenses and settlements. The Balance service cannot read the Expense database directly (see ADR-0002). It needs a realistic way to stay current.

## Decision
The Expense service **publishes events** ("expense added / edited / deleted") to an event bus. The Balance service **listens** and updates its own derived balance store. Balance is a **read model** kept in sync by events, not a live join over Expense's data. (A CQRS-style pattern.)

## Consequences
**Good:** keeps services decoupled; balance reads are fast (pre-computed); matches real event-driven production patterns.
**Cost:** balances are *eventually* consistent — a tiny lag after an expense before the bell is processed; we must handle event ordering and replays carefully; needs the event contracts (AsyncAPI) to be precise.
**Open:** concrete event bus technology — Step 2/3.
