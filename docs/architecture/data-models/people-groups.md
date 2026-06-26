# People & Groups Service — data model

Owns: profiles, friendships, groups, who's in them, invites, placeholders.

### user_profile
- `user_id` (key — same id as Identity's account_id)
- `display_name`, `phone` (nullable), `preferred_currency` (Release 1: the single app currency)
- `is_placeholder` (true = added but hasn't joined yet)
- `created_at`

### friendship
- `friendship_id` (key)
- `user_a_id`, `user_b_id` (links → user_profile)
- `status` (`pending` | `confirmed`)
- **Rule:** cannot delete while an unsettled balance exists (Balance service confirms).

### group
- `group_id` (key)
- `name` (not empty)
- `created_by` (link → user_profile)
- `simplify_debts` (on/off; **default ON** per REQ-BAL-02)
- `created_at`

### group_member
- `group_id` (link → group), `user_id` (link → user_profile)
- `role` (Release 1: every member is equal — any member can rename/delete/add)
- `joined_at`
- **Rule:** cannot leave while owing or owed (Balance service confirms).

### invite
- `invite_id` (key), `group_id` (nullable — null = friend invite), `email_or_phone`, `status`, `expires_at`
