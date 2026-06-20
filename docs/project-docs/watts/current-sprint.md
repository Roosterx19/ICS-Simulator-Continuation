# Current Sprint

**Sprint:** Phase 1 — MVP Foundations, Week 1 of ~6
**Sprint Goal:** A single student can log in, join a session, pick an ICS role from the modular board, and see their assignment persisted in Supabase. No 3D, no forms yet — just the spine.

---

## In Progress
- [ ] **ICS-204 Assignment List** — build zod schema in `lib/ics/forms/ics204.ts`, component `components/forms/ics204-form.tsx`, page under `app/(sim)/session/[id]/forms/new/ics-204/`, extend `app/api/forms/route.ts` discriminated union
- [ ] **Read `docs/ics-knowledge/06_nims-doctrine-consolidated.md`** before coding ICS-204 — field names and hierarchy must match NIMS 2017 terminology
- [ ] **Provide `SUPABASE_SERVICE_ROLE_KEY`** in `.env.local` so RLS-bypass server utilities work (blocker for any server-side seed/admin path)
- [ ] **Seed `esfs` and `rsfs` reference tables** (Phase 2 migration) — from `docs/ics-knowledge/09_esf-rsf-reference.md`. Do not build yet; queue for Phase 2 resource-catalog work.

## Blocked On
- [ ] **`SUPABASE_SERVICE_ROLE_KEY` paste** — user needs to grab from Supabase dashboard → Settings → API and paste into `.env.local`. Until then, any server-side flow that needs RLS bypass will fail.
- [ ] **Re-upload of 3 FEMA PDFs** — NIMS Doctrine 2017, NIMS ICS Forms Booklet v3, NQS Guideline Nov 2017. PDFs were named but not attached. Without the Forms Booklet, ICS-204 field names are sourced from the ICS 400 deck's form description, which is accurate but less field-precise than the booklet.
- [x] **RESOLVED: Scenario maps** — `FEMA_Maps_and_Base.pdf` (the genuine FEMA Exercise Simulation Maps atlas, Rev 3.0 April 2012) was uploaded this turn. 33 PNGs extracted via `pdftoppm -r 120 -png`, renamed by FEMA index (`z01_state_of_columbia.png` through `z33_stramford_county.png`), staged at `supabase/storage-seed/scenario-maps/`. Claude Code: upload to the `scenario-maps` Supabase Storage bucket preserving filenames. Covers State of Columbia, Liberty County, Central City, Bayport, Roaring River Tribal Community, storm surge, flood zones, hospitals, fire/police coverage, county jail, prison, plus 6 peripheral counties. See `docs/ics-knowledge/10_state-of-columbia-geography.md` for the authoritative place-name reference. **Naming correction applied:** 5 files updated from "Liberty City" (doesn't exist in FEMA materials) to "Central City in Liberty County" (the real FEMA training city). `Capital City` (state capital, Hamilton County) remains valid — it is a distinct place.

## Done This Sprint
- [x] Project prep package v1 (CLAUDE.md, Watts docs, PRD, ROADMAP, schema, ICS knowledge 01–05)
- [x] Next.js 14 repo scaffolded, Supabase wired (client/server/middleware), auth flow live
- [x] `0001_initial.sql` applied; 45 ICS roles seeded
- [x] Role-selection board live — click-to-claim, red/green state, persists to `session_participants`
- [x] **ICS-201 Incident Briefing** shipped — schema (`lib/ics/forms/ics201.ts`), form component, `/session/[id]/forms/new/ics-201/` page, API route, signature gate (only `role_code = 'IC'` can submit), enforced at UI + API
- [x] **ICS-202 Incident Objectives** shipped — schema (`lib/ics/forms/ics202.ts`), form component, `/session/[id]/forms/new/ics-202/` page, discriminated-union API handles both 201 and 202
- [x] 6/6 role unit tests passing
- [x] Prep package v2 supplement — `06_nims-doctrine-consolidated.md`, `07_nqs-qualifications-PENDING.md` added to `docs/ics-knowledge/`
- [x] Prep package v3 supplement — `08_legal-framework.md` (Stafford Act, HSPD-5, NRF, NDRF, PPD-8/NPG, lead federal agencies, mutual aid), `09_esf-rsf-reference.md` (all 15 ESFs + 6 RSFs + core capability mappings) added to `docs/ics-knowledge/`
- [x] Prep package v4 supplement — `10_scenarios-library.md` (all 5 named ICS 400 scenarios: Liberty Severe WX, Murkey River, Hurricane Gordon, Snow Storm, July 4th), `supabase/seed_scenarios.sql` (Phase 2-gated seed), and `docs/watts/06_ui-design-system.md` avatar-scaling + diversity section added
- [x] Prep package v5 supplement — 33 FEMA scenario map PNGs extracted + staged in `supabase/storage-seed/scenario-maps/`; `docs/ics-knowledge/10_state-of-columbia-geography.md` (authoritative world reference); `supabase/storage-seed/scenario-docs/central_city_flood_scenario.md` (ICS-300 Unit-2 scenario ready to seed); "Liberty City" → "Central City" naming fixed across 5 files

## Next Up (after ICS-204)
- **ICS-203 Organization Assignment List** — Resources Unit Leader (RESL) owned; auto-prepopulates from `session_participants`
- **ICS-214 Activity Log (auto-generated)** — read-only view derived from `events` table filtered by user + operational period
- **RLS policy tests** for `form_submissions` — prove that a student assigned to Finance cannot `SELECT` an ICS-204 whose visibility is scoped to Operations
- Unit tests for ICS-202 and ICS-204 schemas (mirror the ICS-201 test file)

---

## Notes

- **Two Claude Code sessions ran in parallel** (one paused and resumed, one continued from another). State is reconciled as of this doc update; if divergences show up, the file on disk is the truth.
- **Phase 1 scope reminder:** no avatars, no resource catalog, no budget, no realtime, no multi-student. Those are Phases 2–4. Do not pull forward.

---

## Daily Log

### [Fill in as work progresses]
- **Date —** what shipped, what blocked, what's next

---

## Definition of Done (every task)
- TypeScript compiles with no errors (`pnpm typecheck`)
- Lint passes (`pnpm lint`)
- Unit tests written + passing (`pnpm test:unit`)
- If it touches the DB: migration file committed + RLS policy test
- If it's a UI component: renders in light mode without hardcoded colors
- PR has a one-line success criterion in the description
