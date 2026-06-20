# CLAUDE.md

**Read this file in full at the start of every session. Re-read before starting any new task.**

---

## What you are building

A browser-based, near-3D training simulator that mirrors FEMA ICS 300/400, G191, 0305, and L101–L105 courses. Students move a virtual person through a classroom, pick ICS roles, fill real ICS forms, manage budgets and resources, and progress through scenarios set in the fictional **State of Columbia** (Central City in Liberty County, plus Capital City and surrounding counties) as the instructor advances the slides.

One-line success test: *A student can log in, pick the Operations Section Chief role, fill an ICS-204, see only Operations-section traffic, and walk their avatar to staging — all in under 5 minutes.*

---

## The four rules (non-negotiable)

### 1. THINK BEFORE CODING
- State assumptions in your reply **before** writing code.
- If uncertain, stop and ask **one** clarifying question. Never code around confusion.
- If real tradeoffs exist, present 2–3 options with pros/cons. Let the user pick.

### 2. SIMPLICITY FIRST
- Minimum code that solves the stated problem. Nothing extra.
- No "flexibility for later," no config flags for unshipped features, no abstractions with one caller.
- If your solution is 200 lines and could be 50, rewrite as 50.

### 3. SURGICAL CHANGES
- Touch only the files the task requires.
- Match the existing code style exactly. Do not reformat adjacent code.
- Do not refactor, rename, or "improve" anything not part of the ask.
- Only remove imports that *your* edits made unused.

### 4. GOAL-DRIVEN EXECUTION
- Before coding, write a one-line verifiable success criterion.
- For multi-step tasks, write a 3–7 bullet plan and confirm with the user.
- Implement → verify against the criterion → fix → re-verify. Do not stop before verification.
- All new API endpoints must ship with tests. No exceptions.

---

## Tech stack (locked — ask before adding anything)

| Layer | Choice |
|---|---|
| Runtime | Node 20+ |
| Framework | Next.js 14 (App Router) |
| Language | TypeScript, `strict: true` |
| Styling | Tailwind CSS |
| UI primitives | shadcn/ui |
| 3D | `react-three-fiber` + `@react-three/drei` (isometric camera) |
| Client state | Zustand |
| Server state | TanStack Query |
| DB + Auth + Realtime + Storage | Supabase (project: **Roosterx19's**) |
| Forms | react-hook-form + zod |
| Testing | Vitest (unit), Playwright (e2e) |
| Deploy | Vercel |

**Do NOT add without asking:** Redux, Prisma/Drizzle, tRPC, Emotion/styled-components, Framer Motion for layout, any CSS-in-JS, any new auth provider, any new ORM on top of Supabase.

---

## File map

Read these in order when starting a task:

1. **`CLAUDE.md`** (this file) — rules
2. **`docs/watts/02_platform-overview.md`** — product definition
3. **`docs/watts/04_user-personas.md`** — who we serve
4. **`docs/watts/05_coding-standards.md`** — naming, structure, patterns
5. **`docs/watts/06_ui-design-system.md`** — colors, type, spacing
6. **`docs/watts/07_architecture.md`** — folder structure, data flow
7. **`docs/watts/api-reference.md`** — external APIs
8. **`docs/watts/current-sprint.md`** — what we're working on now
9. **`docs/watts/decisions-log.md`** — past decisions and why
10. **`docs/ics-knowledge/`** — ICS domain reference (roles, forms, IAP cycle)
11. **`ROADMAP.md`** — phase plan
12. **`PRD.md`** — requirements by phase

---

## Repo layout

```
/app                       Next.js App Router pages + route handlers
/components                React components (PascalCase.tsx)
  /ui                      shadcn primitives — do not edit directly
  /sim                     3D simulation components (classroom, staging, avatars)
  /forms                   ICS form components (ICS201, ICS202, ICS204, etc.)
/lib
  /supabase                clients: server.ts, client.ts, middleware.ts
  /ics                     pure domain logic: role rules, form validators, SMART checker
  /utils                   shared utilities
    errors.ts              error classes + handler — USE, do not replace
/hooks                     useCamelCase.ts
/stores                    Zustand stores
/types                     shared TS types
/supabase
  /migrations              timestamped SQL migrations
  seed.sql
/tests
  /unit                    Vitest
  /e2e                     Playwright
/docs                      see file map above
```

---

## Anti-patterns (will be rejected in review)

- `any` in TypeScript. Use `unknown` and narrow, or write a proper type.
- Client-side service-role Supabase calls. Service role is server-only.
- Direct `fetch()` to Supabase REST — use the SDK.
- `useEffect` for data fetching (use TanStack Query).
- Adding a library without proposing it first.
- "Nice to have" refactors bundled into a feature PR.
- Test files that only assert `expect(true).toBe(true)`.
- Committing `.env.local` or any secret.
- Hardcoded hex colors in JSX — use Tailwind tokens from the design system.
- New DB tables without a migration file and RLS policies.

---

## When you're stuck

1. Re-read this file.
2. Re-read `docs/watts/07_architecture.md` and `decisions-log.md`.
3. Search the codebase for an existing pattern that solves a similar problem. Match it.
4. If still stuck, stop and ask the user one focused question.

---

## Board-member routing (other AI tools)

See `docs/board-members.md`. Short version:

- **Claude Code** (you) — primary builder, all app code
- **Base44** (MCP) — rapid internal tooling / admin UI prototypes
- **Supabase MCP** — DB ops (migrations, queries, RLS inspection)
- **Linear MCP** — issue tracking
- **Vercel MCP** — deploys, env vars
- **Gemini / Perplexity** — external, user routes manually for research / second opinions

Do not call external AIs from app code. All external AI usage is developer-side.
