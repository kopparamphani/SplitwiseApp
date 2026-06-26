# Test Strategy (draft)

**Caveman:** the plan for *how we prove the app works* — and the fixed shape every test case takes.

## The test pyramid (most at the bottom)
- **Unit tests (most):** one tiny piece alone. *Like: is this one arrowhead sharp?*
- **Integration tests:** two+ parts together (a service + its DB; a service + the bus). *Like: do bow and arrow work as a pair?*
- **API tests:** poke each service's contract (the OpenAPI order-form) and check the right answer comes back. *Like: shout the order through the window, check the right food returns.*
- **Automation tests (fewest, top):** full journeys run by a robot, no human clicking. *Like: a trap that checks the whole cave nightly.*

## What "money-correct" testing must always cover (this app's crown jewels)
- Payers sum = total; split sums = total (all 5 split methods).
- Leftover penny lands on the payer; same split twice = same placement.
- Group balances sum to **zero**.
- Debt-simplify never makes anyone pay more than they owe; balances unchanged, only path changes.
- Settle-up cannot exceed what's owed.

## Documented test-case format (the standard we agreed)
Every test case is written as:

| Field | Meaning |
|-------|---------|
| **Objective** | What this test proves, in one line. |
| **Test Data / Pre-requisites** | The setup + inputs needed before running. |
| **Expected Result** | What should happen if correct. |
| **Actual Result** | What actually happened (filled at run time). |

### Example
- **Objective:** Adding an expense whose payers don't sum to the total is blocked.
- **Test Data / Pre-requisites:** Logged-in member in a group; total = 800; payer A = 500, payer B = 200 (sum 700).
- **Expected Result:** Save blocked; clear message "payers must add up to 800"; no event published; tally unchanged.
- **Actual Result:** _(filled when run)_

## Where this lives
Each iteration produces its own test cases in this format, version-tracked beside the code. CI runs unit/integration/API/automation on every change (Phase 3 wires the pipeline).
