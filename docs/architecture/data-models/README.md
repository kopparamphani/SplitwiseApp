# Data Models (per service)

**Caveman:** the page-layout of each service's *own* notebook — what it writes down and how the lines link.

**Important:** these are **logical** models (entities, fields, links) — tech-agnostic on purpose. The **physical** schema (exact column types, indexes, the actual DB engine's DDL) comes *after* we pick each service's database engine in Step 2. Money fields are shown as `decimal` to signal "exact, never floating-point."

Each service owns its data. No cross-service foreign keys — links to other services are by **id only** (e.g. Expense stores a `group_id`, but never reaches into the People & Groups DB).
