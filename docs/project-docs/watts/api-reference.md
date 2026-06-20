# API Reference

## Purpose
Documents the third-party APIs integrated into this project. Claude should check this file before writing any integration code to avoid hallucinating endpoints, parameters, or response shapes.

---

## Supabase

### Overview
- **What we use it for:** Database (Postgres + RLS), Auth, Realtime, Storage, Edge Functions — the entire backend
- **Docs:** https://supabase.com/docs
- **SDK:** `@supabase/supabase-js` v2.x, plus `@supabase/ssr` for Next.js App Router cookie handling
- **Project:** **Roosterx19's** (existing project — do not create a new one without explicit instruction)
- **Auth method:**
  - Client-side: anon key with user JWT in cookie → RLS-bound
  - Server-side (route handlers, server components): `@supabase/ssr` `createServerClient` reads cookies → same user JWT → RLS-bound
  - Server admin ops only (seeding, instructor impersonation): service-role key — **never import into a `"use client"` file**

### Database Tables We Query
See `docs/watts/07_architecture.md` for full model; migrations in `supabase/migrations/` are authoritative. Summary:

```
profiles                (extends auth.users)
scenarios               (seeded, read-only to users)
sessions                (1 per class)
session_participants    (1 per user per session)
ics_roles               (reference, seeded)
ics_form_templates      (reference, seeded)
form_submissions        (append-only writes, RLS-scoped by section)
resources               (reference, seeded)
resource_allocations    (scoped by section; Finance sees all)
iaps
objectives
messages
events                  (append-only audit log)
```

### Auth Methods We Use
- **Email/password** (default for v1)
- **Magic link** (optional; preferred for instructors who don't want to manage another password)
- **OAuth:** out of scope for v1. Do not add without asking.

### Storage Buckets
| Bucket | Visibility | Contents |
|---|---|---|
| `scenario-maps` | public | Scenario PNG/JPG maps from ICS 400 course |
| `form-exports` | private (signed URLs) | Generated PDF exports of completed ICS forms |
| `avatar-assets` | public | Avatar mesh/texture refs (Phase 4) |

### RLS Policy Summary
- **`profiles`** — self read/update; admins read all
- **`scenarios`, `ics_roles`, `ics_form_templates`, `resources`** — authenticated read-all (reference tables)
- **`sessions`** — participant read; instructor full; admin full
- **`session_participants`** — session members read each other's role+location (for avatar rendering) but not private fields; users update their own row
- **`form_submissions`** — visibility scoped by `section` + `visible_to` array; IC and Command Staff bypass; Finance always visible to Finance
- **`resource_allocations`** — Logistics + Finance full read; Section Chief reads their section's; others denied
- **`iaps`, `objectives`** — session-scoped read; Planning Section Chief + IC writes
- **`messages`** — scope-gated (section channels, command channel, all-hands)
- **`events`** — instructor reads all; participants read their own actions

Policy tests: every policy has a corresponding Vitest test in `tests/unit/rls/*.test.ts`. No exceptions.

### Example — Server Component Fetch
```typescript
// app/(sim)/session/[id]/page.tsx
import { createServerClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'

export default async function SessionPage({ params }: { params: { id: string } }) {
  const supabase = await createServerClient()
  const { data: session, error } = await supabase
    .from('sessions')
    .select('*, scenarios(*)')
    .eq('id', params.id)
    .single()

  if (error || !session) notFound()
  return <SessionView session={session} />
}
```

### Example — Client Mutation with TanStack Query
```typescript
// components/sim/RoleSelectionBoard.tsx
'use client'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { createBrowserClient } from '@/lib/supabase/client'

export function useAssignRole(sessionId: string) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (roleCode: string) => {
      const supabase = createBrowserClient()
      const { error } = await supabase
        .from('session_participants')
        .update({ role_code: roleCode })
        .eq('session_id', sessionId)
        .eq('user_id', (await supabase.auth.getUser()).data.user!.id)
      if (error) throw error
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['session', sessionId] }),
  })
}
```

### Realtime — Phase 3+
```typescript
// hooks/useSessionRealtime.ts (skeleton — do not implement until Phase 3)
const channel = supabase.channel(`session:${sessionId}`)
  .on('postgres_changes', {
    event: '*', schema: 'public', table: 'session_participants',
    filter: `session_id=eq.${sessionId}`,
  }, (payload) => { /* bridge to TanStack Query cache */ })
  .subscribe()
```

### Error Handling
Supabase errors come back as `{ data: null, error: PostgrestError }`. Wrap with the domain error classes from `lib/utils/errors.ts`:

```typescript
if (error) {
  if (error.code === 'PGRST116') throw new NotFoundError('Session not found')
  if (error.code === '42501') throw new PermissionError('RLS denied')
  throw new AppError(error.message, { cause: error })
}
```

### Environment Variables Required
- `NEXT_PUBLIC_SUPABASE_URL` — project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` — anon key for client
- `SUPABASE_SERVICE_ROLE_KEY` — server-only; never expose

---

## Resend (Phase 2+)

### Overview
- **What we use it for:** Transactional email — instructor invites to students, password reset notifications
- **Docs:** https://resend.com/docs
- **SDK:** `resend` npm package, latest
- **Auth method:** API key in Authorization header (handled by SDK)

### Emails We Send
| Trigger | Template | From |
|---|---|---|
| Instructor invites student to session | `session-invite.tsx` | `invites@ics-sim.app` (TBD domain) |
| Password reset | handled by Supabase Auth (not Resend) | — |
| Post-class completion summary (Phase 3+) | `session-summary.tsx` | `reports@ics-sim.app` |

### Environment Variables Required
- `RESEND_API_KEY` — server-only
- `EMAIL_FROM_ADDRESS` — sender domain (must be verified in Resend)

---

## Sentry (Phase 2+)

### Overview
- **What we use it for:** Error tracking, performance monitoring for client + server
- **Docs:** https://docs.sentry.io
- **SDK:** `@sentry/nextjs`
- **Auth method:** DSN + auth token (build-time for source maps)

### Environment Variables Required
- `NEXT_PUBLIC_SENTRY_DSN` — public DSN
- `SENTRY_AUTH_TOKEN` — build-time, for source map upload
- `SENTRY_ORG`, `SENTRY_PROJECT` — build-time config

---

## Notes for Claude
- **Always use the SDK methods documented above.** Never raw-fetch to these services.
- **Never expose secret keys to client code.** Secret keys are `SUPABASE_SERVICE_ROLE_KEY`, `RESEND_API_KEY`, `SENTRY_AUTH_TOKEN`.
- **Check this file before writing any integration code.** If an API isn't listed here, stop and ask before assuming how it works.
- **No AI APIs listed intentionally.** External LLMs are a developer-side tool, not an app dependency in v1. If the user requests an in-app AI feature (e.g. IAP suggestion assistant), that's a new architecture decision requiring a fresh entry here.
