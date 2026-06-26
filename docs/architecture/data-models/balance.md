# Balance Service — data model

Owns: the *derived* answer to "who owes whom," plus settlements. A read model fed by events (ADR-0004).

### balance_pair
- `scope` (`group:<id>` or `friend:<pair_id>`)
- `creditor_id`, `debtor_id` (ids only)
- `amount` (decimal — what debtor owes creditor right now)
- `updated_at`
- **Invariant:** within one scope, all balances sum to **zero**.

### settlement
- `settlement_id` (key)
- `scope`, `payer_id`, `payee_id`, `amount` (decimal)
- `type` (`full` | `partial`)
- `recorded_by`, `recorded_at`
- **Rule:** cannot exceed what is owed; no confirmation from the other side (REQ-BAL-03).

### simplification_note
- `scope`, `from_id`, `to_id`, `amount`, `reason_text`
- Holds the short "why you pay Carol" explanation when debt-simplify produces a surprising payment (REQ-BAL-02).

**Note:** raw expenses are NOT stored here — only the math results, rebuilt from Expense events.
