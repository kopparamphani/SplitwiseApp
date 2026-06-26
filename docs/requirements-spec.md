# Requirements Specification — Expense Tracker

**Project:** Production-grade expense tracker (web + Android + iOS) — Splitwise-parity, open-source only.
**Document type:** Requirements Specification (docs-as-code — plain text, version-trackable).
**Status:** DRAFT — awaiting final Phase-2 sign-off.
**Phase:** 2 of 5 (Requirements).

---

## How to read this doc (caveman)

This is a list of **promises** about what the app must do. We write them **before** building, so everyone agrees on "done."
**Like:** before the hunt, you say exactly what counts as success, so no one argues later.

Each promise is a **card** with the same shape:

- **ID** — a tag for tracing (e.g. `REQ-EXP-01`).
- **Name** — short title.
- **Goal** — what + why, one line.
- **Who** — which user it's for.
- **The story** — "As a ___, I want ___, so that ___."
- **Must do** — what it has to do.
- **Rules & limits** — boundaries.
- **Done & correct looks like** — the proof checklist *(this is the seed for QA test cases)*.

For plain-word meanings of tech terms (API, container, YAML, etc.), see the project **glossary.md**.

---

## Release scope (what ships when)

**Release 1 (build first):** Accounts, friends, groups, expenses, all 5 split methods, balances, debt-simplify, settle up, manual category, notifications (in-app), web app (online-only), then Android, then iOS.

**Release 2 / later (parked, written below so we don't lose the thinking):**
- Multi-currency + auto-convert (Bucket 5).
- Smart Receipt Camera — OCR autofill (`REQ-RCP-01`).
- Auto-category from picture (`REQ-RCP-02`).
- Reports & charts (`REQ-RPT-01`).
- Offline use + sync.

**Two defaults applied (flagged for sign-off — flip if wrong):**
1. **Manual category** field kept on an expense in Release 1 (user picks it).
2. **Release 1 runs in a single currency** — each user picks one currency, no conversion. *Like: one village, one coin.*

---

# Bucket 1 — People & Groups

### REQ-ACC-01 — Sign Up
**Goal:** Let a new person make an account so they can use the app.
**Who:** A brand-new visitor.
**The story:** As a new person, I want to make an account, so my expenses and friends are saved as mine.

**Must do:**
1. Take an email and a password.
2. Take a display name (what friends see).
3. Also allow **"Sign up with Google"** — one tap, no password to invent. *Like: showing a badge you already own instead of carving a new one.*
4. Refuse an email that's already used.
5. Save the account safely (password never stored in plain words).
6. Log the person in once made.

**Rules & limits:**
- Email must look like a real email.
- Password must meet a minimum strength (exact rule — *parked, decide later*).
- One email = one account.
- An account can be born two ways (email+password OR Google); we keep this in mind so they don't collide.

**Done & correct looks like:**
- New email + good password → account made, I'm logged in.
- "Sign up with Google" → account made from Google identity, I'm logged in.
- Re-use an existing email → blocked, clear message.
- Weak password → blocked, clear message.

---

### REQ-ACC-02 — Log In / Log Out
**Goal:** Let a returning person get into their account and safely leave.
**Who:** An existing user.
**The story:** As a returning user, I want to log in, so I see my own stuff.

**Must do:**
1. Take email + password.
2. Also allow **"Log in with Google."**
3. Let them in if correct.
4. Reject if wrong, with a clear message.
5. Let them log out.
6. Keep them logged in across app restarts (until they log out).

**Rules & limits:**
- Too many wrong tries → slow it down (anti-guessing). Exact limit — *parked, decide later*.

**Done & correct looks like:**
- Right email + password → I'm in, I see my groups.
- "Log in with Google" → I'm in.
- Wrong password → "incorrect," I stay out.
- I log out → I'm sent to the login screen.

---

### REQ-ACC-03 — Reset Forgotten Password
**Goal:** Let a user who forgot their password get back in safely.
**Who:** An existing email+password user (not Google users — they have no password here).
**The story:** As a locked-out user, I want to reset my password by email, so I'm not stuck out.

**Must do:**
1. User asks to reset, gives their email.
2. App sends a reset link to that email.
3. Link lets them set a new password.
4. Old password stops working once changed.
5. Reset link expires after a while.

**Rules & limits:**
- Link is one-time use and time-limited (exact time — *parked, decide later*).
- Don't reveal whether an email exists (just say "if it exists, we sent a link") — small safety habit.

**Done & correct looks like:**
- I request reset → I get an email with a link.
- I set a new password → old one fails, new one works.
- I click an old/expired link → blocked, clear message.

---

### REQ-FRD-01 — Add a Friend
**Goal:** Let a user connect to another person so they can share expenses one-on-one.
**Who:** A logged-in user.
**The story:** As a user, I want to add a friend, so we can split bills directly, no group needed.

**Must do:**
1. Find a person by **email or phone number** (both supported).
2. Send/confirm a friend link.
3. Show my friend list.
4. Let me remove a friend.

**Rules & limits:**
- Can't friend yourself.
- A friend you have an **unsettled balance** with **cannot be removed** until settled.

**Done & correct looks like:**
- I add a known email → they appear in my friends.
- I add a stranger not on the app → app offers to invite them.
- I try to remove a friend I still owe → blocked, clear message.

---

### REQ-GRP-01 — Create a Group
**Goal:** Let a user make a named group to collect shared expenses.
**Who:** A logged-in user (becomes group owner).
**The story:** As a user, I want to make a group like "Goa Trip," so all that trip's expenses sit in one place.

**Must do:**
1. Take a group name.
2. Make the creator the first member (owner).
3. Show the group in the creator's list.
4. **Any member** can rename or delete the group.

**Rules & limits:**
- Name can't be empty.
- Deleting a group with **unsettled debts** → **warn first** (confirm step).
- *Note:* "any member can delete" is powerful — one person can wipe the group for everyone. Accepted; softened by the confirm step.

**Done & correct looks like:**
- I name a group → it's created, I'm in it.
- Empty name → blocked, clear message.
- Delete a group with open debts → warned before it happens.

---

### REQ-GRP-02 — Add People to a Group (incl. non-app folks)
**Goal:** Let a member bring others into a group, even people without the app.
**Who:** Any group member.
**The story:** As a member, I want to add people by email or phone, so even my friend who hasn't installed the app is in our tally.

**Must do:**
1. **Any member** can add an existing app user to the group.
2. **Any member** can add a non-user by email or phone (creates a "placeholder" person).
3. Send them an invite to join.
4. When they sign up, merge them onto their placeholder (debts intact).
5. Let members leave a group.

**Rules & limits:**
- A placeholder person can be owed money (so the math works before they join).
- A member **cannot leave** a group while they **owe or are owed**.

**Done & correct looks like:**
- I add a real user → they see the group.
- I add a non-user email → placeholder appears, invite sent.
- They sign up later → placeholder becomes their real account, debts intact.
- I try to leave with an open balance → blocked, clear message.

---

# Bucket 2 — Adding an Expense

### REQ-EXP-01 — Add an Expense
**Goal:** Let a member record money spent so the group's tally updates.
**Who:** Any member of a group (or either side of a friend pair).
**The story:** As a member, I want to log what I paid, so the app knows who owes whom.

**Must do:**
1. Enter an amount.
2. Enter a short description ("Dinner," "Cab").
3. Pick who paid — **one or more payers**. Each payer's amount is entered; the payers' amounts must **add up to the total**. *Like: people throwing coins into one pot — the pot must equal the bill.*
4. Pick a **category** (manual — e.g. Food, Travel). *(Release 1 manual; Release 2 auto-guesses it.)*
5. Choose how it splits *(detail → `REQ-SPL-01`)*.
6. Set the date (default = today).
7. Add a note (optional).
8. Attach a receipt photo (optional).
9. Save → it joins the group and the tally updates.

**Rules & limits:**
- Amount must be a positive number.
- Amount, description, and payer are **required**; note and photo are optional.
- Sum of all payers' amounts must equal the expense total, or save is blocked.
- One expense belongs to exactly one group (or one friend pair).
- **Release 1: single currency only** (no per-expense currency choice yet — see Bucket 5, parked).

**Done & correct looks like:**
- Amount + description + payer + equal split → saves, tally changes correctly.
- Total ₹800, payer A ₹500 + payer B ₹300 → saves; if they sum to ₹700 → blocked, clear message.
- Save with no amount → blocked, clear message.
- Attach a photo → photo shows on the saved expense.

---

### REQ-EXP-02 — Edit or Delete an Expense
**Goal:** Let members fix mistakes — change or remove a logged expense.
**Who:** **Any group member** (the trail records who).
**The story:** As a member, I want to fix or delete a wrong expense, so the tally stays true.

**Must do:**
1. Open an existing expense.
2. Change any field (amount, who paid, split, date, note, photo, category).
3. Save → tally re-calculates.
4. Delete an expense → tally re-calculates.
5. Keep a small **trail**: who last changed or deleted it, and when.

**Rules & limits:**
- Editing a **settled** expense re-opens the math → warn first.
- A deleted expense isn't truly gone; it's marked deleted (so we can show "X deleted this"). *Like: crossing a line out in the logbook, not ripping the page.*

**Done & correct looks like:**
- I change ₹500 → ₹400, save → everyone's owed amounts shift correctly.
- I delete an expense → it leaves the tally, and the trail shows I deleted it.

---

### REQ-EXP-03 — Recurring Expense
**Goal:** Let a member set an expense that repeats on its own (rent, subscriptions).
**Who:** Any group member.
**The story:** As a member, I want rent to log itself every month, so I don't re-type it.

**Must do:**
1. Mark an expense as recurring.
2. Pick how often: **daily, weekly, monthly, or custom** (e.g. "every 2 weeks").
3. App auto-creates the expense each period using the same details + split.
4. Let a member **stop** the recurrence.
5. Show clearly which expenses are auto-made vs. hand-made.

**Rules & limits:**
- A custom interval needs a number + a unit (days / weeks / months).
- A recurring expense keeps going until someone stops it.
- If the group is deleted, its recurrences stop too.

**Done & correct looks like:**
- I set "Rent, monthly" → next month a matching expense appears on its own.
- I set "every 2 weeks" → it fires on that custom rhythm.
- I stop it → no more appear.

---

# Bucket 3 — Splitting the Bill

### REQ-SPL-01 — Choose How to Split an Expense
**Goal:** Let members divide an expense among people in any fair way.
**Who:** Whoever is adding or editing the expense.
**The story:** As a member, I want to split a bill the right way, so each person owes their true share.

**Must do — support all five ways:**
1. **Equally** — same share for everyone chosen. *Like: one pie, equal slices.*
2. **Exact amounts** (unequal) — type each person's exact owed amount.
3. **By percent** — type each person's % (must total 100%).
4. **By shares** — give each person a number of shares; split by weight. *Like: "you ate 2 plates, I ate 1" → you owe 2/3.*
5. **By adjustments** — start equal, nudge people up/down by a fixed amount, rest split equally.

Also:
6. Let the user **pick who is included** in the split (not everyone has to be in every expense).
7. Show a **live preview** of each person's share as they edit.

**Rules & limits:**
- The split must **add up to the full total** (exact, percent, shares, adjustments all reconcile) — else block the save.
- Percent split: percents must total **100%**.
- At least **one person** in the split.
- Payers and split-people are **separate lists**: who *paid* vs. who *owes*. *Like: I paid the whole bill, but it's split four ways — I paid, all four owe.*

**Done & correct looks like:**
- ₹900 split equally among 3 → ₹300 each.
- ₹900 by shares 2:1:0 → ₹600 / ₹300 / ₹0.
- Percent split totaling 90% → blocked, "must total 100%."
- Exact amounts summing to ₹850 on a ₹900 bill → blocked, "₹50 unaccounted."

---

### REQ-SPL-02 — Handle Leftover Pennies (Rounding)
**Goal:** Make sure split shares always add back to the exact total — no missing or extra penny.
**Who:** The system (behind the scenes); matters to every split.
**The story:** As a member, I want the shares to add up perfectly, so the tally is never "off by one paisa."

**Why this card exists:** ₹100 split 3 ways = ₹33.333… each. Round to ₹33.33 and 3×₹33.33 = ₹99.99 — a penny vanishes. We must decide where the leftover goes.

**Must do:**
1. Split to two decimal places (normal money).
2. Detect any leftover (or excess) penny.
3. Assign the leftover to the **payer** — a fixed, predictable rule.
4. Guarantee the shares always sum **exactly** to the total.

**Rules & limits:**
- Same split done twice gives the **same** penny placement (predictable, never random).

**Done & correct looks like:**
- ₹100 / 3 → payer gets ₹33.34, others ₹33.33 → sum = ₹100.00 exactly.
- Re-run the same split → identical penny placement.

---

# Bucket 4 — Who Owes Whom

### REQ-BAL-01 — Running Balance (the live tally)
**Goal:** Always show each person's up-to-date "you owe / you are owed."
**Who:** Any member, for their groups and friends.
**The story:** As a member, I want to see who owes whom right now, so no one has to do math.

**Must do:**
1. After every expense/edit/delete, re-calculate balances.
2. Show, inside a group, what each person owes or is owed.
3. Show **one-on-one** balances with each friend.
4. Show my **grand total** across all groups and friends (one big "you are owed ₹X / you owe ₹Y").

**Rules & limits:**
- Balances always reconcile to **zero across the group**. *Like: a see-saw — both sides must match.*
- A placeholder (non-app) person can still hold a balance.

**Done & correct looks like:**
- ₹900 dinner, I paid, split 3 equally → other two each owe me ₹300, I'm owed ₹600.
- Sum of everyone's balances in a group = **zero**.

---

### REQ-BAL-02 — Debt Simplification
**Goal:** Shrink a tangle of debts into the fewest payments needed.
**Who:** Any member of a group (group setting).
**The story:** As a member, I want the app to reduce who-pays-whom to the fewest hand-offs, so we settle fast.

**Why this card exists:** A owes B ₹100, B owes C ₹100. Instead of two payments, "A pays C ₹100, done." *Like: three people passing the same coin in a circle — skip the middle, pass it straight.*

**Must do:**
1. Look at all balances in a group.
2. Compute the **fewest payments** that settle everyone.
3. Show the simplified "pay this person, this much" list.
4. **Show a short "why" note** when a simplified payment looks surprising (e.g. "you pay Carol because the chain was simplified") — safety net for confused users.
5. Let a group **turn this on or off**.

**Rules & limits:**
- **ON by default** for a new group.
- Simplified result must still settle **everyone to zero**.
- Never makes anyone pay **more** than they actually owe in total.

**Done & correct looks like:**
- A→B ₹100 and B→C ₹100 → app shows just "A pays C ₹100."
- After simplify, every person's overall balance is unchanged (only the *path* changed).
- A surprising payment shows a "why" note.

---

### REQ-BAL-03 — Settle Up (record a payback)
**Goal:** Let a person record "I paid you back," clearing or reducing a debt.
**Who:** Any member, against a real balance they have.
**The story:** As a member, I want to record that I paid Sarah ₹300, so our balance updates.

**Must do:**
1. Pick who paid whom, and how much.
2. Allow **full** settle (clear it) or **partial** settle (pay some now).
3. Update both people's balances.
4. Keep a record of settlements (date, amount, who recorded it).
5. Show settlements in the group history alongside expenses.

**Rules & limits:**
- Can't settle **more** than is owed.
- **No confirmation needed** from the other person — the history shows who recorded it.
- A settlement is its own kind of entry, separate from an expense. *Like: an expense is "money spent"; a settlement is "debt paid back."*

**Done & correct looks like:**
- I owe Sarah ₹300, record paying ₹300 → balance becomes zero for us.
- Record a ₹100 partial → balance drops to ₹200.
- Try to settle ₹500 on a ₹300 debt → blocked, clear message.

---

# Bucket 5 — Money Across Borders  *(DEFERRED → Release 2)*

> Parked for a later release. Written so we don't lose the thinking.
> **Release-1 stand-in:** single currency, no conversion (see `REQ-EXP-01`).

### REQ-CUR-01 — Currencies & Group "Home Currency"  *(Release 2)*
**Goal:** Let people log expenses in any currency, show balances in one agreed currency.
**Must do (summary):** each group has one **home currency**; users have a preferred currency; an expense can be logged in any currency; store which currency each expense used.
**Open (later):** can home currency change after expenses exist, or lock once set? *(Leaning: changeable with a warning.)*

### REQ-CUR-02 — Auto-Convert Between Currencies  *(Release 2)*
**Goal:** Turn an expense's currency into the group's home currency using real rates.
**Must do (summary):** convert when currencies differ; show both original and converted amounts; **freeze the rate at entry** so balances don't silently shift; allow manual rate entry if the rate source is down; always keep the original amount on record.
**Open (later):** which open-source/free rates source — a **Phase 3** decision.

---

# Bucket 6 — Helpful Extras

### REQ-RCP-01 — Smart Receipt Camera, Read & Autofill (OCR)  *(DEFERRED → Release 2)*
**Goal:** Snap a receipt; the app reads it and fills the new expense for you.
**Must do (summary):** take/pick a photo; read total, date, shop (best effort); pre-fill the expense form; user reviews and fixes before saving; keep the photo attached; fall back to manual entry if reading fails.
**Open (later):** read just the total, or also line items? *(Leaning: total/date/shop only first.)*

### REQ-RCP-02 — Auto-Category from the Picture  *(DEFERRED → Release 2)*
**Goal:** From the receipt photo, guess the expense type and tag it.
**Must do (summary):** guess a category from photo/shop name; pre-fill it; user can change it; use a fixed category list; default "Uncategorized" if unsure.
**Note:** relies on the **manual category** field we kept in `REQ-EXP-01` for Release 1.

### REQ-NOT-01 — Notifications & Reminders  *(Release 1)*
**Goal:** Nudge people about money and changes so nothing is forgotten.
**Who:** Any member.
**The story:** As a member, I want a heads-up when I owe someone or a group changes, so I don't miss it.

**Must do:**
1. **Activity notices:** expense added/edited, someone settles up, someone joins a group.
2. **Debt reminders:** "you owe Sarah ₹300."
3. Let each user **turn notification types on/off**.
4. **Release 1: in-app notices.** **Phone push** added during the mobile-app work.

**Rules & limits:**
- Don't spam — sensible limits on reminder frequency (exact rule — *parked, decide later*).
- Respect each user's on/off settings.

**Done & correct looks like:**
- Someone adds an expense to my group → I get a notice.
- I turn off reminders → I stop getting "you owe" nudges.

### REQ-RPT-01 — Reports & Charts  *(DEFERRED → nice-to-have / next release)*
**Goal:** Show a member where their money goes, in simple pictures.
**Must do (summary):** spend by category (pie); spend over time (by month); filter by group and date range; read-only (never changes money); friendly empty state.

---

# Bucket 7 — Where It Runs

### REQ-PLT-01 — Web App
**Goal:** Let people use the full tracker in a browser, on desktop or phone.
**Who:** Any user with a browser.
**The story:** As a user, I want to open the app in a browser and do everything, so I don't need to install anything.

**Must do:**
1. Run in common browsers (Chrome, Firefox, Safari, Edge).
2. Offer **all Release-1 features**.
3. **Adapt to screen size** — usable on a big monitor and a phone browser. *Like: a tent that fits whether you pitch it wide or narrow.*
4. Stay in step with mobile (same account, same data).

**Rules & limits:**
- Same login works on web and mobile (one account, many doors).
- No web-only features (keep platforms even).
- **Release 1: online-only** (no offline use — parked for later).

**Done & correct looks like:**
- I log in on a laptop browser → I see my groups, can add an expense.
- I shrink the window to phone-size → layout still works, nothing cut off.

---

### REQ-PLT-02 — Mobile Apps — Android then iOS
**Goal:** Give people real phone apps, built in sequence.
**Who:** Any user with an Android or iPhone.
**The story:** As a user, I want a proper app on my phone, so it's fast and feels native.

**Must do:**
1. Build **Android first**, then **iOS** — in sequence, not at once.
2. Offer **all Release-1 features**, matching the web app.
3. Use the phone's **camera** (so Release-2 receipt-scan can plug in later) and **push notifications**.
4. Same account and data as web.

**Rules & limits:**
- Feature parity: web and phone do the same core things.
- *How* we build two phone apps without writing everything twice — a **Phase 3** decision (open-source ways to share one codebase exist).

**Done & correct looks like:**
- I install on Android, log in → same groups as my web.
- I add an expense on Android → it shows on web moments later.
- (Later) iOS app reaches the same parity.

---

### REQ-PLT-03 — One Account, Synced Everywhere
**Goal:** Make sure a person's data is the same on every screen, always current.
**Who:** Every user across web + phones.
**The story:** As a user, I want my data identical on laptop and phone, so I never see two different truths.

**Must do:**
1. One account opens every platform.
2. A change on one device shows on the others (after refresh/sync).
3. The **server holds the true copy**; devices show it. *Like: the tribe's logbook lives at the fire; everyone reads the same book.*

**Rules & limits:**
- If two people change the same thing at once, a clear "who wins" rule applies (exact rule — **Phase 3**).
- Devices must never invent data the server doesn't have.

**Done & correct looks like:**
- I add an expense on phone → open web → it's there.
- I settle a debt on web → my friend's phone shows the new balance.

---

# Whole-App Rules (cross-cutting — to be detailed in Phase 3)

These apply to everything. Listed now; full detail comes with the architecture.

- **Security basics:** passwords stored safely (never plain text); reset links one-time and expiring; login slows after repeated wrong tries.
- **One source of truth:** the server holds the real data; devices display it.
- **Money is exact:** all splits reconcile to the total; group balances always sum to zero.
- **Audit trail:** edits and deletes record who did it and when.
- **Open-source only:** every tool and library we choose must be open-source.

**Parked decisions (revisit before they matter):**
- Exact password strength rule.
- Login lockout threshold.
- Reset-link expiry time.
- Reminder frequency limit.
- "Who wins" rule for simultaneous edits (Phase 3).

---

*Style note: every card stays plain and short. If a promise can't be explained in a breath, it's not caveman enough — flag it and we simplify.*
