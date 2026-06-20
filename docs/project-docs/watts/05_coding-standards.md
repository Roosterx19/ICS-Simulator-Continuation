# Coding Standards

## Naming Conventions
- **Components:** `PascalCase.tsx` (e.g. `RoleSelectionBoard.tsx`)
- **Hooks:** `camelCase.ts` prefixed with `use` (e.g. `useCurrentRole.ts`)
- **Utils:** `camelCase.ts` (e.g. `formatOperationalPeriod.ts`)
- **Constants:** `SCREAMING_SNAKE_CASE`
- **Files (non-component):** `kebab-case.ts` for routes/modules, `camelCase.ts` for utils
- **Database tables:** `snake_case`, plural (`incident_sessions`, `role_assignments`)
- **Database columns:** `snake_case` (`created_at`, `role_id`)
- **CSS / Tailwind:** utility-first; custom class names (rare) are `kebab-case`
- **Env vars:** `SCREAMING_SNAKE_CASE`, `NEXT_PUBLIC_` prefix for browser-exposed

## Folder Structure
```
/app
  /(auth)                      grouped routes, no URL segment
    /login/page.tsx
    /signup/page.tsx
  /(sim)
    /session/[id]/page.tsx    main simulator view
    /instructor/[id]/page.tsx master instructor view
  /api                         route handlers (REST-style)
    /forms/[formId]/route.ts
  layout.tsx
  globals.css

/components
  /ui                          shadcn primitives — do not edit directly
  /sim                         3D simulation components
    Classroom.tsx
    Avatar.tsx
    StagingArea.tsx
    IsometricCamera.tsx
  /forms                       ICS form components
    ICS201Form.tsx
    ICS204Form.tsx
  /dashboard                   role-based dashboards
    OperationsDashboard.tsx
    FinanceDashboard.tsx

/lib
  /supabase
    client.ts                  browser client (anon key)
    server.ts                  server client (cookies, RLS-bound)
    middleware.ts              session refresh
    admin.ts                   service-role client — SERVER ONLY
  /ics
    roles.ts                   role definitions + hierarchy
    forms.ts                   form schemas (zod)
    smart-validator.ts         SMART objective check
    visibility.ts              who-sees-what rules
  /utils
    errors.ts                  error classes + handler
    cn.ts                      tailwind class merger

/hooks
/stores                        Zustand — one store per domain
/types                         shared TS types
/supabase
  /migrations                  <timestamp>_<name>.sql
  seed.sql
/tests
  /unit
  /e2e
/docs
```

## Component Rules
- **Functional components only.** No classes, ever.
- **Co-locate styles** — Tailwind utilities inline; no separate `.css` files for components.
- **Props interface** named `<ComponentName>Props` and exported when reused.
- **Default exports** for pages (Next.js requirement) and route handlers. **Named exports** for all other components, utils, hooks, types.
- **Max lines per component: 150.** Split before you hit that. Extract sub-components, hooks, or move logic to `lib/`.
- **`"use client"` is a last resort** — default to server components. Use client directive only for: event handlers, useState/useEffect, 3D canvas, Supabase Realtime subscriptions, form inputs.

## TypeScript Rules
- **`"strict": true`** — non-negotiable
- **`"noImplicitAny": true`**, **`"noUncheckedIndexedAccess": true`**
- **Prefer `type` for unions, `interface` for object shapes with potential extension.** Consistent within a file.
- **No `any`.** Use `unknown` and narrow with type guards, or write a proper type.
- **Prefer union types over enums.** TypeScript enums have runtime quirks; use `as const` objects or string literal unions.
- **Zod schemas are source of truth** for runtime data (forms, API bodies). Infer TS types from them with `z.infer<typeof Schema>`.

## State Rules
- **Local UI state** → `useState`
- **Shared client state** → Zustand store per domain (`useSessionStore`, `useFormDraftStore`)
- **Server state** (anything from Supabase) → TanStack Query
- **Never** use React Context for server state — it doesn't cache, revalidate, or dedupe
- **Never** use `useEffect` for data fetching
- **Realtime subscriptions** (Phase 3+) live in a custom hook that bridges Supabase Realtime → TanStack Query cache

## API / Data Fetching Rules
- **All Supabase access** goes through `lib/supabase/*` clients. No raw fetch to the Supabase REST API.
- **Client components** use the browser client with anon key + RLS. They cannot escalate.
- **Server components / route handlers** use the server client, which inherits the user's JWT → RLS still applies.
- **Service-role client** is ONLY used in server-side admin flows (seeding, instructor impersonation, etc.) and must never be imported into a `"use client"` file. Enforced by a lint rule.
- **Error handling** follows `lib/utils/errors.ts`:
  - Throw typed `AppError` subclasses in server code
  - Route handlers catch via a shared `handleError()` wrapper that maps to HTTP status
  - Client code handles TanStack Query `error` state — no try/catch around `useQuery`

## Styling Rules
- **Tailwind utilities first.** Inline in JSX.
- **Design tokens come from `docs/watts/06_ui-design-system.md`** — mapped to `tailwind.config.ts`. Never hardcode hex values.
- **Mobile-friendly, tablet-primary, desktop-primary.** Phone is secondary.
- **No inline styles** except for dynamic 3D positioning values that can't be expressed in Tailwind.
- **Dark mode: out of scope for v1.** Do not add theme toggling.

## Code Quality Rules
- **No `console.log` in committed code.** Use `lib/utils/logger.ts` (create if needed).
- **Comments required for:** non-obvious domain logic (ICS rule translations), regex, math in 3D transforms, bitmask operations.
- **Prefer self-explanatory names over comments** — if you need a comment to explain what a variable is, rename the variable.
- **Max function length: 40 lines.** Refactor past that.
- **Early returns over nested ifs.** Max nesting depth: 3.

## Patterns We Always Use
- **Zod at every boundary** — form inputs, route handler bodies, external API responses, env var parsing
- **`react-hook-form` for every form**, with `zodResolver`
- **TanStack Query** for every server read; **mutations** for every server write
- **Server components for data-fetching pages**, client components for interactive leaves
- **Role-based visibility enforced at BOTH ends** — Supabase RLS (server) + UI filters (client). Never trust the client.
- **Every new DB change = new migration file**, timestamped, committed

## Patterns We Never Use
- Class components
- `useEffect` for data fetching
- `any` (or `// @ts-ignore` without a clear comment + ticket)
- Context for server data
- Direct DOM manipulation outside `useRef` + 3D canvas
- ORMs on top of Supabase (Prisma, Drizzle) — we use the Supabase SDK directly
- CSS-in-JS (styled-components, Emotion)
- Implicit default exports for reusable modules

## Git Conventions
- **Branch naming:** `feat/<short-name>`, `fix/<short-name>`, `chore/<short-name>`, `docs/<short-name>`
- **Commit style:** Conventional Commits
  - `feat(sim): add isometric camera controls`
  - `fix(forms): ICS-204 signature validation`
  - `chore: bump supabase-js`
- **PRs must pass:** `pnpm typecheck`, `pnpm lint`, `pnpm test:unit`
- **One logical change per PR.** If you're refactoring while fixing a bug, split the PR.
