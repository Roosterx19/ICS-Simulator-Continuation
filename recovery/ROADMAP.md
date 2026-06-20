# Roadmap

**Philosophy:** ship thin vertical slices. Every phase ends with something a student can actually do end-to-end, not a collection of half-built features.

---

## Phase 1 — MVP Foundation (≈6 weeks)

**End state:** a single student can log in, join a session, pick a role, fill and submit an ICS-201, and see themselves represented in an isometric classroom view. RLS enforces section visibility. Instructor has a master roster screen.

### Week 1 — Spine
- Repo scaffold (Next.js 14, TS strict, Tailwind, shadcn, ESLint, Prettier, Vitest, Playwright)
- Supabase project confirmed (Roosterx19's existing, or new — decide day 1)
- Initial migration: `profiles`, `scenarios`, `sessions`, `session_participants`, `ics_roles`, `events`
- RLS policies on all six + policy tests
- `lib/supabase/{client,server,middleware,admin}.ts`
- Seed script for `ics_roles` from `docs/ics-knowledge/01_roles-and-structure.md`
- Deploy skeleton to Vercel

**Exit criteria:** `pnpm dev` runs, `pnpm test:unit` passes, a Vercel preview URL exists with "hello world" landing page.

### Week 2 — Auth + Session Join
- `/login`, `/signup`, `/reset` pages (shadcn auth components)
- Middleware cookie refresh
- Profile auto-create on first sign-in
- `/session/[id]` server component fetches session, inserts `session_participants` row, renders roster
- Magic link flow
- E2E test: sign up → land on session page

**Exit criteria:** two users in two browsers can both land on the same session URL and see each other in the roster.

### Week 3 — Role-Selection Board
- `components/sim/RoleSelectionBoard.tsx` — DOM-based org chart (not 3D yet)
- Node states: available / taken / disabled (parent unassigned)
- `useAssignRole` mutation
- Hierarchy rules from `lib/ics/roles.ts`
- Role color coding per design tokens
- Staging panel showing picked students

**Exit criteria:** Student A picks IC → Student B sees IC node as taken and can now pick OSC (which was previously disabled).

### Week 4 — ICS-201 Form
- Form shell + zod schema in `lib/ics/forms/ics201.ts`
- `components/forms/ICS201Form.tsx` with react-hook-form
- Draft autosave (every 30s to `form_submissions` with `status=draft`)
- Signature gate: submit requires `role_code=IC`
- Locked view after submit
- `/api/forms` route handler + Vitest tests

**Exit criteria:** IC student submits a valid ICS-201; non-IC students see submission in their feed (per RLS); invalid submissions rejected.

### Week 5 — Isometric Classroom View
- react-three-fiber setup + isometric camera
- Scene: room floor, facility plinths (ICP, Base, Staging, Incident Site), desks
- Avatars as colored capped cylinders; color = role color; position = home facility
- OrbitControls for camera
- Client component; fallback non-3D list view for accessibility

**Exit criteria:** When a role is assigned, the corresponding avatar appears at the correct facility in the 3D scene; all students see the scene update.

### Week 6 — Instructor Master + Polish
- `/instructor/[id]` master view (live roster, event timeline, form-status matrix)
- First seeded scenario with one extracted ICS 400 map
- End-to-end Playwright test: signup → join → pick IC → submit ICS-201 → visible on instructor screen
- Documentation pass, CLAUDE.md updates reflecting what was learned
- Bug fix buffer

**Exit criteria (Phase 1 complete):** The full E2E path runs in CI. A product demo video recorded.

---

## Phase 2 — Resources, Budget, IAP, SMART (≈5 weeks)

**End state:** Students can complete a full operational period: write SMART objectives, assemble a full IAP, allocate resources within a budget. Finance gets working dashboard. Instructor can inject events.

### Week 7 — Resources + Logistics Dashboard
- Migration: `resources`, `resource_allocations`
- Seed resource catalog (water, medical, fire, vehicles, heavy equipment, personnel) with real-world pricing
- `components/dashboard/LogisticsDashboard.tsx` — catalog with filter/search
- Request resource flow

### Week 8 — Finance + Budget
- `components/dashboard/FinanceDashboard.tsx` — budget HUD, pending requests, allocations list
- Budget band color logic (75/50/15/5/over)
- Substitution suggestions (scenario-seeded alternatives)
- Approve/deny flow

### Week 9 — More Forms (ICS-202, 203, 204, 205, 208, 214)
- Zod schemas + UI components per form
- Form visibility rules per `docs/ics-knowledge/02_ics-forms.md`
- ICS-203 auto-generated from `session_participants`
- ICS-214 auto-generated from `events`

### Week 10 — IAP Assembly + SMART Validator
- `lib/ics/smart-validator.ts` with per-letter checks
- ICS-202 inline SMART warnings (non-blocking warnings; Phase 3 makes them blocking)
- Edge Function: monitor form completions → assemble IAP → notify IC for final signature
- IAP PDF export to `form-exports` bucket

### Week 11 — Op Period Clock + Instructor Inject
- Live multi-clock HUD
- Planning P meeting scheduler with toasts
- Transfer-of-command modal
- Shift-change flow
- Instructor inject event catalog

**Exit criteria (Phase 2 complete):** A session can complete two full operational periods with a signed IAP and working budget.

---

## Phase 3 — Multi-Student Realtime & Movement (≈5 weeks)

**End state:** 30 students in one session, each moving their own avatar, chatting via tablet, checking in/out. No more polling.

### Week 12 — Realtime Foundation
- `useSessionRealtime` hook
- Migrate polling → Realtime for all relevant tables
- Load test: 30 concurrent clients, <500ms p95 update latency

### Week 13 — Grid + Pathfinding
- Pre-authored grid per scenario map
- A* pathfinding library
- Click-to-move, walking state, tile-by-tile progress
- Blocked moves (not assigned to Division) show reason

### Week 14 — Check-in / Check-out
- Badge mechanic
- Check-in stations in Staging + at Divisions
- ICS-211 auto-entries
- Check-out at period end

### Week 15 — Tablet UI + Messaging
- In-sim tablet modal (rendered in DOM, not canvas, but themed to feel 3D-adjacent)
- Section + chain-of-command + all-hands channels
- Help request flow
- Messages table RLS scoped

### Week 16 — Delegation + Polish
- Letter of Expectation modal on IC assumption
- Scenario-specific delegation content
- Bug fix buffer, load test pass, demo video

**Exit criteria (Phase 3 complete):** 30-student class runs one full scenario in realtime with no dropped updates.

---

## Phase 4 — Avatars, Outfits, Walking (≈6 weeks)

**End state:** Students are recognizable characters in the world, with role-coded outfits, discipline PPE, walking animations, and optional voice lines.

### Week 17–18 — Avatar System
- Character library (race, gender presentation, body type; all original/stylized)
- `avatar_config` jsonb + renderer
- Migration away from cylinder primitives to low-poly characters

### Week 19 — Outfits + Discipline PPE
- Shirt color from role token
- Discipline overlays: fire turnout, EMS, police, hazmat (A/B/C/D), public works
- Number-on-back for role severity

### Week 20 — Walking Animation
- Keyframe or simple skeletal walking animation
- Walking speed per scenario
- Time-in-motion logged to ICS-214

### Week 21 — Voice Lines
- Decide TTS vs recorded at kickoff
- Core canned lines per role
- Mute toggle

### Week 22 — Polish + Phase 4 Demo
- Bug fix buffer
- Accessibility pass (captions for voice lines required)
- Demo video

**Exit criteria (Phase 4 complete):** Recognizable avatars walk the scenario with role- and discipline-coded outfits.

---

## Phase 5 — Full 3D & Expanded Courses (deferred, no date)

Revisit when:
- Phases 1–4 are live and validated with real students
- Budget exists for 3D asset pipeline (modeling, rigging, animation)
- User research shows full 3D justifies the cost over stylized low-poly

Candidate work items:
- Rigged 3D characters
- Environment meshes (buildings, vehicles, terrain)
- CERT scenarios
- HazMat, Fire, Police, Media, Public Works, Phone/Power Utility specialized scenarios
- VR exploration

---

## Dependency Graph (which phase needs what)

```
Phase 1 ──────────────────────────────────┐
  auth, sessions, roles, one form, 3D scene│
  └───> Phase 2 ──────────────────────────┤
          resources, budget, IAP, meetings │
          └───> Phase 3 ──────────────────┤
                  realtime, movement, chat │
                  └───> Phase 4 ──────────┤
                          avatars, voice  │
                          └───> Phase 5   │
                                  full 3D │
```

Each phase depends only on what's literally needed from the previous. Do not pull forward Phase 3 realtime into Phase 1 to "save time" — it breaks SIMPLICITY FIRST and explodes the test matrix.

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Supabase Realtime can't handle 30 concurrent clients at low latency | Low | High | Load test in Week 12; fallback to polling + SWR if it fails |
| Legal blockers on scenario content derivation | Medium | Medium | Legal review before Phase 1 beta; write original scenarios as backup |
| 3D performance on mid-range tablets | Medium | Medium | Measure frame rate in Week 5; degrade gracefully (reduce shadows, lower poly) |
| Phase creep (user wants Phase 4 features in Phase 1) | High | High | Phase gates are contractual; no "just this one thing" pulls forward |
| Form complexity underestimated | Medium | Medium | ICS-201 in Phase 1 is the canary — if it takes 2x plan, re-estimate Phase 2 forms |
