# Expense Service — data model

Owns: the expenses themselves and how each is paid + split. The heart of the app.

### expense
- `expense_id` (key)
- `group_id` (id only; null if it's a friend-pair expense) , `friend_pair_id` (nullable)
- `description`, `amount` (decimal, > 0), `currency` (Release 1: the single app currency)
- `category` (manual pick in Release 1)
- `date`, `note` (nullable), `receipt_photo_url` (nullable → points at Photo Storage)
- `created_by`, `created_at`
- `is_deleted` (soft delete — we cross out, never rip the page)
- `last_changed_by`, `last_changed_at` (audit trail)

### expense_payer
- `expense_id` (link → expense), `user_id` (id only), `amount_paid` (decimal)
- **Rule:** sum of all payers' `amount_paid` MUST equal `expense.amount`.

### expense_split
- `expense_id` (link → expense), `user_id` (id only)
- `method` (`equal` | `exact` | `percent` | `shares` | `adjustment`)
- `share_value` (the % / shares / exact amount / adjustment, by method)
- `amount_owed` (decimal — the resolved share; leftover penny goes to the payer per REQ-SPL-02)
- **Rule:** sum of `amount_owed` MUST equal `expense.amount` exactly.

### recurrence
- `recurrence_id` (key), `template_expense_id` (link → expense)
- `frequency` (`daily` | `weekly` | `monthly` | `custom`)
- `custom_every` (number) + `custom_unit` (`days`|`weeks`|`months`) — only for custom
- `active` (stops when false), `next_run_at`
