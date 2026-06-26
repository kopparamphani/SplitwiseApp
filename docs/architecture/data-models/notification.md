# Notification Service — data model

Owns: notices shown to users and each user's on/off preferences.

### notification
- `notification_id` (key)
- `user_id` (id only)
- `type` (`activity` | `debt_reminder`)
- `event_kind` (`expense_added` | `expense_edited` | `settled_up` | `member_joined` | `owe_reminder` ...)
- `payload` (small text: who/what/how much, for the message)
- `channel` (`in_app` now; `push` / `email` later)
- `read` (true/false), `created_at`

### notification_pref
- `user_id` (id only), `type` (which notice type)
- `enabled` (true/false — respects user on/off per REQ-NOT-01)
- **Rule:** reminder frequency cap is OPEN (see NFR doc).
