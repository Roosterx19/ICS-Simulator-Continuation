# Environment Variables

## Important
**Never put actual secret values in this file.** This is a map of what exists and where to get each value. Real values live in `.env.local` (gitignored) or your hosting platform dashboard.

---

## Frontend (Public — exposed to browser, safe to commit to `.env.example` with blank values)

| Variable | What It Does | Where To Get It |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL | Supabase dashboard → Settings → API |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Public anon key for client-side Supabase calls (RLS-bound) | Supabase dashboard → Settings → API |
| `NEXT_PUBLIC_APP_URL` | App base URL, used for auth callbacks and email links | Local: `http://localhost:3000` — Prod: your Vercel domain |
| `NEXT_PUBLIC_SENTRY_DSN` | (Phase 2+) Public Sentry DSN | Sentry dashboard → Project Settings → Client Keys |

## Backend (Private — server-only, NEVER expose to client)

| Variable | What It Does | Where To Get It |
|---|---|---|
| `SUPABASE_SERVICE_ROLE_KEY` | Full DB access, bypasses RLS. Used only in server-side admin ops (seeding, instructor impersonation). | Supabase dashboard → Settings → API |
| `DATABASE_URL` | Direct Postgres connection string for migrations and seeding | Supabase dashboard → Settings → Database |
| `RESEND_API_KEY` | (Phase 2+) Transactional email sending | resend.com dashboard |
| `EMAIL_FROM_ADDRESS` | (Phase 2+) Sender address for transactional emails (domain must be verified in Resend) | Your verified Resend domain |
| `SENTRY_AUTH_TOKEN` | (Phase 2+) Build-time, for source map upload | Sentry dashboard → Settings → Auth Tokens |
| `SENTRY_ORG` | (Phase 2+) Sentry org slug | Sentry URL |
| `SENTRY_PROJECT` | (Phase 2+) Sentry project slug | Sentry URL |

---

## Environment Files
- **`.env.local`** — your local dev values. **Gitignored. Never commit.**
- **`.env.example`** — template with variable names and blank/example values. **Commit this.**
- **Production** — set in Vercel dashboard → Project → Settings → Environment Variables. Separate values for Preview and Production scopes.

---

## First-Time Setup

1. Copy `.env.example` to `.env.local`
2. In Supabase dashboard (Roosterx19's Project or your new ICS-sim project): Settings → API → copy URL, anon key, service role key into `.env.local`
3. Settings → Database → Connection Pooler → copy connection string into `DATABASE_URL`
4. Run `pnpm supabase:migrate` to apply migrations
5. Run `pnpm supabase:seed` to seed reference tables (`ics_roles`, `ics_form_templates`, `resources`, seeded scenarios)
6. Run `pnpm dev`

---

## Notes / Gotchas

- **`NEXT_PUBLIC_*` variables are literally inlined into the JS bundle at build time.** Never put secrets behind that prefix, even accidentally.
- **The service role key bypasses RLS.** If it leaks, any row is readable. Rotate immediately and audit. Treat it like a production DB password.
- **Supabase anon key is public by design.** RLS is what keeps data safe. The anon key without RLS = no security.
- **Vercel preview deploys need the same env vars set in the "Preview" scope** — a common bug is working in dev, broken on preview because the preview env vars aren't configured.
- **`SENTRY_AUTH_TOKEN` is build-time only.** Do not read it at runtime.
- **`.env.local` is gitignored by the default Next.js `.gitignore`.** Double-check on first commit that it's not showing up.
