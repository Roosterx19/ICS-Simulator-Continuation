# Architecture

## High-Level Shape

```
┌────────────────────────────────────────────────────────────────┐
│                   Browser (student / instructor)               │
│                                                                │
│  Next.js App Router                                            │
│  ├── Server Components (data fetch, RLS-bound)                 │
│  ├── Client Components (interactivity, 3D canvas)              │
│  ├── react-three-fiber (isometric classroom, avatars)          │
│  ├── Zustand (local sim state)                                 │
│  └── TanStack Query (server cache + Supabase reads)            │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 │ HTTPS + WebSocket (Realtime)
                 ▼
┌────────────────────────────────────────────────────────────────┐
│                          Supabase                              │
│  ├── Postgres (all durable state)                              │
│  ├── Auth (email/password + magic link)                        │
│  ├── RLS policies (role-based visibility)                      │
│  ├── Realtime (session presence + form updates, Phase 3+)      │
│  ├── Storage (scenario maps, form PDF exports)                 │
│  └── Edge Functions (seed scenarios, heavy validations)        │
└────────────────────────────────────────────────────────────────┘

Hosting: Vercel (Next.js)
CI: GitHub Actions → Vercel previews on every PR
```

No separate backend server. All server logic lives in Next.js route handlers + Supabase Edge Functions.

---

## Folder Structure

See `docs/watts/05_coding-standards.md` for the canonical tree. Update this file's tree when structure actually changes — not speculatively.

```
/app
  /(auth)/login | /signup | /reset
  /(sim)/session/[id]                 student view
  /(sim)/instructor/[id]              master view
  /api/forms/[formId]
  /api/scenarios/[id]/inject          instructor-only inject events
/components/ui | /sim | /forms | /dashboard
/lib/supabase | /ics | /utils
/hooks /stores /types
/supabase/migrations /supabase/seed.sql
/tests/unit /tests/e2e
/docs/watts /docs/ics-knowledge /docs/board-members.md
```

---

## Core Data Models

Human-readable overview. Authoritative schema is `supabase/migrations/*.sql`.

### `profiles`
Extends `auth.users`. One row per user.
- `id` (uuid, PK, FK→auth.users) · `display_name` · `avatar_config` (jsonb) · `default_discipline` · `created_at`

### `scenarios`
A training scenario derived from a course + unit. Seeded; not user-created in MVP.
- `id` · `course_code` (ICS300|ICS400|G191|0305|L101|L102|L103|L105) · `unit_code` · `title` · `city` (Capital|Liberty) · `map_url` · `summary` · `initial_budget_cents` (bigint) · `operational_period_hours`

### `sessions`
One live class session. Belongs to a scenario, has an instructor, has ≤ ~40 participants.
- `id` · `scenario_id` → scenarios · `instructor_id` → profiles · `status` (lobby|active|paused|complete) · `started_at` · `current_operational_period` (int, starts at 1) · `remaining_budget_cents`

### `session_participants`
- `id` · `session_id` · `user_id` → profiles · `role_code` (nullable until selected) · `location_code` (classroom|staging|base|camp|incident_site|eoc) · `xy` (jsonb) · `checked_in_at` · `checked_out_at`

### `ics_roles`
Reference table. Seeded from `lib/ics/roles.ts`.
- `code` (PK, e.g. `IC`, `OPS_CHIEF`, `SAFETY`, `PIO`, `PLAN_CHIEF_DEPUTY`, `DIV_A_SUPV`) · `name` · `tier` (ic|command|section|branch|division|unit|leader|resource) · `section` (nullable, OPS|PLAN|LOG|FIN|II|COMMAND) · `color_token` (role-ic|role-command|...) · `reports_to_code` (self-ref, nullable)

### `ics_form_templates`
- `code` (PK, e.g. `ICS-201`, `ICS-204`) · `name` · `json_schema` (zod-compatible) · `required_signatures` (text[] of role_codes)

### `form_submissions`
- `id` · `session_id` · `template_code` · `operational_period` · `submitted_by` → profiles · `payload` (jsonb, validated against template schema) · `status` (draft|submitted|approved|rejected) · `signatures` (jsonb)

### `resources`
Catalog. Seeded.
- `code` (PK) · `name` · `category` (personnel|vehicle|equipment|supply|facility) · `discipline` · `type` (I..V per NIMS RTLT) · `unit_cost_cents` · `availability_tier` (easy|moderate|hard|blocked) · `metadata` (jsonb)

### `resource_allocations`
- `id` · `session_id` · `resource_code` · `quantity` · `assigned_to_section` · `assigned_to_role_code` · `status` (requested|approved|deployed|released) · `cost_cents` · `created_at` · `released_at`

### `iaps`
Incident Action Plans, one per operational period per session.
- `id` · `session_id` · `operational_period` · `status` (draft|signed|active|closed) · `built_from_forms` (uuid[]) · `signed_by` (jsonb of role_code → user_id)

### `objectives`
SMART objectives for an IAP.
- `id` · `iap_id` · `text` · `smart_check` (jsonb — per-letter pass/fail from validator) · `authored_by` → profiles · `approved` (bool)

### `messages`
In-sim tablet chat, section-scoped.
- `id` · `session_id` · `from_user_id` · `scope` (section code or `COMMAND` or `ALL`) · `body` · `created_at`

### `events` (audit/timeline)
Append-only. Drives the instructor timeline + end-of-class review.
- `id` · `session_id` · `type` (role_assigned|form_submitted|role_transferred|resource_allocated|budget_warning|objective_flagged|shift_change|...) · `actor_user_id` · `payload` (jsonb) · `occurred_at`

---

## Data Flow Patterns

### Picking a role
1. Client component calls `useMutation` → `/api/sessions/:id/assign-role`
2. Route handler (server) validates: user is in session, role is open, user has no current role
3. Server writes `session_participants.role_code` + emits `events` row (type=`role_assigned`)
4. Supabase Realtime pushes the `session_participants` update to all subscribed clients (Phase 3+)
5. Client TanStack Query cache is invalidated for that session; UI re-renders, avatar recolors

### Submitting an ICS form
1. `react-hook-form` with zod resolver validates locally
2. `useMutation` posts to `/api/forms`
3. Route handler re-validates with the same zod schema (never trust the client), checks RLS (user is in session, owns the draft, signatures are from valid roles), writes `form_submissions`
4. `events` row emitted
5. If the form completes an IAP section, a background check triggers IAP assembly

### Role-based visibility (core invariant)
Enforced at THREE layers:
1. **Supabase RLS** — Ops Chief cannot `SELECT` from `form_submissions` tagged as Finance-only. This is the truth.
2. **Server component queries** — include `eq('visible_to_role_codes', currentRole)` filters. Belt and suspenders.
3. **Client UI** — hides sections based on `useCurrentRole()`. Cosmetic only; not a security boundary.

**If you ever find yourself relying only on (3), stop and add (1).**

### Realtime (Phase 3+)
- One Supabase Realtime channel per session: `session:{sessionId}`
- Client subscribes on mount, unsubscribes on unmount
- Events bridged into TanStack Query via `queryClient.setQueryData()` rather than refetching — keeps latency low

---

## Key Patterns

- **All API calls go through `lib/supabase/*` or dedicated route handlers in `/app/api/*`.** No raw `fetch()` to Supabase REST endpoints.
- **Zustand for client-only state** (camera position, which tablet modal is open, local form draft).
- **TanStack Query for anything that originated in the database.**
- **Route handlers are thin** — they validate input, call a function in `lib/ics/*` or `lib/supabase/*`, and return. Business logic is not in route handlers.
- **Pure domain logic** (role hierarchy, form validation, SMART check, visibility rules) lives in `lib/ics/` with no React, no Supabase, no Next imports. Fully unit-testable.

---

## Integrations

| Service | Purpose | Env |
|---|---|---|
| **Supabase** | DB, Auth, Realtime, Storage, Edge Functions | Primary |
| **Vercel** | Hosting, preview deploys, edge runtime | Primary |
| **Resend** (Phase 2+) | Instructor invites, password resets | Optional in dev |
| **Sentry** (Phase 2+) | Error tracking | Optional in dev |

No Stripe, no Uploadthing, no third-party AI APIs in the app itself.

---

## Security Posture

- **RLS on every table.** No exceptions. Anon-key reads are only allowed for tables explicitly marked public (e.g. `ics_roles` reference data).
- **Service-role key** is server-only, read from `SUPABASE_SERVICE_ROLE_KEY`. A lint rule blocks importing `lib/supabase/admin.ts` into any file marked `"use client"`.
- **Auth middleware** refreshes the Supabase session cookie on every request.
- **Instructor impersonation** (viewing a student's section feed) runs through a dedicated Edge Function that checks the caller is the session's instructor and audits every impersonation event.
- **No PII beyond email and display name.** No real dispatch data. Scenarios are training fiction set in the FEMA-provided State of Columbia (Central City, Capital City, Liberty County, etc. — see `docs/ics-knowledge/10_state-of-columbia-geography.md`).

---

## Testing Strategy

- **Unit (Vitest):** `lib/ics/*` pure logic (role hierarchy queries, SMART validator, form schemas). Target 90% coverage for this folder.
- **Integration (Vitest + Supabase local):** Route handlers against a Supabase test instance. RLS policy tests are mandatory for every new table.
- **E2E (Playwright):** Critical user journeys — login → join session → pick role → fill ICS-201 → submit.
- **No snapshot tests for UI.** They're noise.

---

## Diagrams

Kept in `/docs/diagrams/` as `.mermaid` files. Render via `mermaid.js` in docs viewer.

- `auth-flow.mermaid` (to be created Phase 1)
- `role-selection-flow.mermaid` (to be created Phase 1)
- `form-submission-flow.mermaid` (to be created Phase 1)
- `realtime-channels.mermaid` (Phase 3)
