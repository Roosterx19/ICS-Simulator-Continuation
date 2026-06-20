# Decisions Log

Append-only record of non-trivial decisions. Newest on top. Do not edit past entries — add a new entry that supersedes.

---

## 2026-04-17 (v5) — FEMA scenario maps extracted; "Liberty City" → "Central City" naming corrected; geography primer added

**Context:** User uploaded `FEMA_Maps_and_Base.pdf` — the FEMA Exercise Simulation System *Maps and Diagrams* atlas, Appendix Z, Revision 3.0 (April 2012). This is the fictional-world reference every FEMA scenario uses: 33 maps covering the State of Columbia, Liberty County, Central City, Bayport, Roaring River Tribal Community, and surrounding counties. Also uploaded `ICS_300_AAM_CCFS_Unit-2_maps.pdf` (Central City Flood Scenario); the 3 flood maps from that file are also present in the main atlas.

**Resolves the v4 block:** v4 recorded that `/mnt/project/*.pdf` files were text dumps and map extraction was impossible. That's true of the files in `/mnt/project/`, but the new upload at `/mnt/user-data/uploads/FEMA_Maps_and_Base.pdf` is a genuine PDF. Extraction via `pdftoppm -r 120 -png` produced 33 usable PNGs.

**Decisions:**

1. **PNGs extracted and staged** at `supabase/storage-seed/scenario-maps/` with FEMA-index-based filenames (`z01_state_of_columbia.png` through `z33_stramford_county.png`). Blank / TOC pages removed. Claude Code should upload these to the `scenario-maps` Supabase Storage bucket preserving filenames; `scenarios.map_url` points to the correct PNG per scenario.

2. **New authoritative world reference** at `docs/ics-knowledge/10_state-of-columbia-geography.md`. Every scenario must source place names from this file. Fabricated place names are forbidden going forward.

3. **Naming correction: "Liberty City" → "Central City in Liberty County".** The user's original brief conflated these into "Liberty City," which doesn't exist in the FEMA materials. Six occurrences across five files were corrected surgically:
   - `CLAUDE.md` (project summary)
   - `docs/watts/02_platform-overview.md`
   - `docs/watts/07_architecture.md` (training-fiction examples)
   - `docs/ics-knowledge/08_legal-framework.md` (oil-spill example reassigned to Bayport — which in the FEMA atlas actually has the refinery, LNG terminal, and cruise/cargo ports)
   - `supabase/seed_scenarios.sql` (Phase-2 TODO comment)
   - `supabase/migrations/0001_initial.sql` (scenarios-section header comment)
   - **`Capital City` remains valid** — it is the state capital of Columbia in Hamilton County, a distinct place from Central City. No changes to scenarios already using Capital City.

4. **Central City Flood Scenario** (ICS 300 Unit 2, AAM-165–172) staged as `supabase/storage-seed/scenario-docs/central_city_flood_scenario.md` — Historical Background, Scenario narrative, Current Resources list, associated-map filenames, mapping from FEMA instructor tasks to simulator-equivalent flow. Ready to seed as an ICS-300 scenario alongside Phase-2 scenario work.

5. **Roaring River Tribal Community (RRTC)** flagged as a first-class Unified Command training trigger. Any scenario touching the RRTC footprint sets `involves_tribal = true` (column to be added in Phase-2 scenarios migration) so the role-select board opens a tribal IC slot.

6. **Note on scope relative to v4's scenarios library:** The v4 scenarios library defined 5 ICS 400 scenarios (Liberty Severe WX, Murkey River, Hurricane Gordon, Snow Storm, July 4th). Those names may predate the FEMA atlas — if any of them reference "Liberty City" or other fabricated geography, re-reconcile against `10_state-of-columbia-geography.md` before seeding. Flagged in the Claude Code follow-up prompt.

**Tradeoffs:**
- Atlas is April 2012 (Rev 3.0). If FEMA has since updated geography, we won't know. Acceptable — the training fiction doesn't need current events.
- 33 PNGs at 120 DPI ≈ 15 MB total. Fine for Supabase free tier; revisit only if Phase-4 avatar work needs higher-res close-ups.
- Renaming `Capital City` → `Central City` in every existing scenario would be incorrect — they're distinct real FEMA places.

---

## 2026-04-17 (v4) — Scenarios library + avatar scaling policy

**Context:** Phase 2 scenario seed was not yet in the prep package. User asked for avatars that are not huge on screen ("may fit more stuff on background if scaled") — this affects both r3f camera/character configuration and the design-system spec. Also discovered the `/mnt/project/*.pdf` files are text dumps, not real PDFs, so map-image extraction is blocked at the source.

**Decision:**
- Extract all 5 named ICS 400 scenarios (Liberty Severe WX, Murkey River, Hurricane Gordon, Snow Storm, July 4th) into `docs/ics-knowledge/10_scenarios-library.md` with full narrative, command-structure decision points, resource constraints, and ESF expectations.
- Write `supabase/seed_scenarios.sql` — **gated behind a future Phase-2 migration** (`0002_scenarios_phase2.sql`) that adds five columns (`scenario_type`, `legal_framework`, `lead_federal_agency`, `expected_esfs`, `initial_resource_constraints`). Seed uses `ON CONFLICT DO UPDATE` for idempotency. Do not run before Phase 2 starts.
- Add an "Avatar & Scene Scaling" section to `docs/watts/06_ui-design-system.md` codifying: characters 6–10% of viewport height at normal zoom, scene-to-character ratio ~1:12, 3 zoom presets (wide/normal/close), fixed isometric camera, role identity on three redundant channels (outfit color + floating badge + discipline PPE), diversity pool requirement, no animals on avatars, no licensed-character lookalikes.
- Scenario #4 (Snow Storm) flagged as the Phase 1 MVP tutorial scenario — lowest complexity, pre-planned posture, cleanest Area Command teaching example.
- Scenario maps remain blocked pending real PDF or PNG uploads from user.

**Tradeoffs:** Writing scenario seeds ahead of the Phase-2 schema means the file will not run on Phase-1 Supabase. Accepted — the file is clearly header-gated with "DO NOT APPLY YET" and the required migration is named. Alternative (wait until Phase 2) would have lost the content extraction work done now while the source text is readily indexed.

---

## 2026-04-17 (later update) — Legal framework + ESF/RSF reference extracted from ICS 400

**Context:** User asked for NIMS / NPG / laws / doctrine content. The NPG PDF and standalone legal framework docs are not in project knowledge. The ICS 400 Unit 5 deck contains substantial coverage of Stafford Act, HSPD-5, NRF, NDRF, PPD-8 mission areas, all 15 ESFs (Handout 5-3), and 6 RSFs (Handout 5-4) — enough to build scenario-coherent legal and support-function reference files without the standalone docs.

**Decision:**
- Create `docs/ics-knowledge/08_legal-framework.md` with Stafford/non-Stafford distinction, HSPD-5, NRF/NDRF overview, federal coordination structures (NOC, NRCC, RRCC, JFO, JIC, MAC Group), lead-federal-agency-by-incident-type table, mutual aid tiers, and a scenario-to-framework lookup table.
- Create `docs/ics-knowledge/09_esf-rsf-reference.md` with all 15 ESFs (coordinator + core capabilities + functional scope) and all 6 RSFs (coordinating agency + summary) plus a schema hook for a Phase-2 `esfs`/`rsfs` seed.
- Both files explicitly mark where NPG-specific content is thin and flag re-upload of the NPG PDF as the follow-up.
- Parallel-session naming collision was resolved by renumbering my two new files to 08 and 09 rather than renaming the existing 06 and 07.

**Tradeoffs:** Any claim in 08/09 not grounded in the April 2019 ICS 400 deck (e.g. recent Stafford Act amendments, 2024 NPG revisions) is out of scope until the source PDFs arrive. The files are not to be treated as legal advice — they are training reference only.

---

## 2026-04-17 (update) — NIMS 2017 content sourced via ICS 400 deck; NQS deferred

**Context:** User requested NIMS Doctrine 2017 PDF, NIMS ICS Forms Booklet v3, and NQS Guideline (Nov 2017) be uploaded and merged into `docs/ics-knowledge/`. Only their filenames came through; the three PDFs themselves are not in project knowledge.

**Decision:**
- Extract NIMS 2017 doctrine content from the ICS 400 slideshow (which IS in project knowledge and IS a NIMS 2017 doctrine-based curriculum) into a new `06_nims-doctrine-consolidated.md`. Clearly label sourcing.
- Create `07_nqs-qualifications-PENDING.md` as a labeled placeholder with the general NQS framework. Do NOT treat its contents as authoritative until the source PDF is uploaded.
- Phase 4+ PTB/QRB/CO/credentialing features remain roadmapped but unblocked — Phase 1–3 does not need NQS to ship.
- Continue ICS-204 build using existing `02_ics-forms.md` field descriptions (sourced from ICS 400 deck). Re-verify field names against the Forms Booklet v3 once uploaded.

**Reasoning:** Do not fabricate citations. Be honest about what's sourced and what's scaffolded from general knowledge. The user's rules explicitly say "never code around confusion" — this applies to documentation too.

**Tradeoffs:** ICS-204 ships with slightly-less-field-precise form layout than the official booklet would give us; we'll patch when the PDF lands. Users get a working ICS-204 now instead of waiting.

---

## 2026-04-17 (update) — ICS-201 and ICS-202 shipped; ICS-204 next

**Context:** Two Claude Code sessions ran in parallel (one paused mid-task, one resumed in a new session). Reconciling state before continuing.

**Decision:**
- ICS-201 and ICS-202 are considered DONE (schemas, components, pages, API, tests).
- Next sequential form is ICS-204 (Assignment List), per the natural IAP chain (201 → 202 → 203 → 204, but 203 is deprioritized because it auto-populates from `session_participants` once 45 roles are seeded, so 204 unblocks more scenario work).
- `current-sprint.md` updated to reflect this. No work lost.

**Reasoning:** Ship what unblocks the scenario flow fastest. 204 is the form frontline teams carry — high product value.

**Tradeoffs:** Mild — ICS-203 is trivial to build after 204 (same pattern, less logic), so deferring it by one sprint is cheap.

---

## 2026-04-17 — Use react-three-fiber for "near-3D" not full 3D

**Context:** User wants a 3D-feeling simulator but explicitly said the full-3D avatar/asset pipeline is cost-blocked. Needed a middle path: feels 3D, builds fast, runs in a browser with no asset pipeline.

**Decision:** react-three-fiber (Three.js wrapper for React) with:
- Isometric / top-down-angled camera
- Primitives only in MVP (boxes, cylinders, planes) — no imported meshes
- Flat-color materials with simple lighting (ambient + directional)
- Characters as capped cylinders with colored "shirts" matching role-color tokens

**Reasoning:** Gives depth, shadows, camera parallax without model files, animation rigs, or art pipeline. Upgrades cleanly to real assets in Phase 4+.

**Tradeoffs:** Will not look AAA. That's fine — this is a training tool, not a game. Character walking animation in Phase 3+ will be tile-based movement, not skeletal animation.

---

## 2026-04-17 — Next.js App Router over Vite SPA

**Context:** Need auth, server rendering for instructor roster (SEO irrelevant, but server components simplify RLS-bound data), API routes, realtime.

**Decision:** Next.js 14 App Router on Vercel.

**Reasoning:** Single deploy target, server components pair cleanly with Supabase RLS-bound fetches (JWT auto-attached via cookie), route handlers give us `/api/*` without a separate backend, Vercel preview URLs per PR.

**Tradeoffs:** App Router learning curve, more opinionated than Vite. 3D canvas has to be `"use client"` which we accept.

---

## 2026-04-17 — Supabase over self-hosted Postgres + custom auth

**Context:** Need DB, auth, realtime, storage, and RLS — fast.

**Decision:** Supabase managed. Reuse Roosterx19's Project if it suits; otherwise create a new dedicated project for this simulator.

**Reasoning:** User already has Supabase in their stack (per memory). RLS policies are the right tool for role-based section visibility. Realtime is included. Auth is included. One vendor, one dashboard, one MCP connection.

**Tradeoffs:** Vendor lock-in on auth and realtime. Acceptable at this stage. Migration path exists (Postgres is portable; auth could be re-implemented; realtime is the stickiest piece).

---

## 2026-04-17 — Zustand for client state, TanStack Query for server state

**Context:** Need local sim state (camera, open modals, form drafts) and server cache (sessions, participants, forms).

**Decision:** Zustand for client, TanStack Query for server. No Redux, no Context for data.

**Reasoning:** Smallest bundles, clearest boundaries, match current industry best practice for Next.js App Router apps.

**Tradeoffs:** Two state libraries instead of one. The bifurcation by data origin is actually clearer than one store for everything.

---

## 2026-04-17 — RLS enforced server-side, UI filtering is cosmetic

**Context:** Core product requirement: Finance cannot see Operations forms; Operations cannot see Finance; IC and Safety see everything.

**Decision:** Three layers, but Supabase RLS is the single source of truth:
1. Supabase RLS policies — enforced at DB (truth)
2. Server component queries — add explicit section filters (defense in depth)
3. Client UI — hides sections based on current role (cosmetic only)

**Reasoning:** If we ever rely only on client-side filtering, a student with browser dev tools could read other sections' traffic. Training simulator still has to demonstrate *real* information silos, not pretend ones.

**Tradeoffs:** RLS policy tests are now mandatory for every table touching session data. More testing overhead, but the invariant justifies it.

---

## 2026-04-17 — One Supabase Realtime channel per session

**Context:** Multi-student sessions need live updates of role assignments, form submissions, position.

**Decision:** Channel naming convention: `session:{sessionId}`. Clients subscribe on session page mount, unsubscribe on unmount. Realtime events bridged into TanStack Query cache via `setQueryData`, not by refetching.

**Reasoning:** One channel per session keeps scoping trivial and matches how RLS naturally partitions data. Bridging to cache (vs. refetch) keeps latency low under Realtime bursts.

**Tradeoffs:** Need careful lifecycle management (subscription leaks are a class of bug we'll see). Custom hook `useSessionRealtime` will own this.

---

## 2026-04-17 — ICS forms as zod schemas + react-hook-form, not a form builder

**Context:** Need digital versions of ICS 201, 202, 203, 204, 205, 206, 215, etc. Could build a generic dynamic form renderer; could hand-code each.

**Decision:** Hand-code each form as a component with its own zod schema in `lib/ics/forms/`. Schemas registered in `ics_form_templates` table for validation on the server.

**Reasoning:** ICS forms are legally/operationally specific — layout, labels, signature blocks have meaning. A generic renderer would hide the one thing we're teaching: the actual FEMA form. Hand-coded forms are also much easier to test and change per-form.

**Tradeoffs:** Higher up-front work (one component per form). Acceptable — there are ~20 forms and we ship a few at a time.

---

## 2026-04-17 — Phase 1 MVP scope explicitly excludes avatars, resources, budgets, multi-student realtime

**Context:** User's full vision is multi-year. MVP must be shippable in weeks.

**Decision:** Phase 1 ships with: single-user session join, role selection, one form (ICS-201), one scenario, static isometric scene showing role positions as colored markers. No walking avatars, no resource catalog, no budget, no realtime, no voice, no multi-student.

**Reasoning:** "SIMPLICITY FIRST." Prove the spine (auth → session → role → form → RLS-scoped view) before layering richness.

**Tradeoffs:** User has to see less of their vision in Phase 1 than they imagined. Managed by an explicit phased ROADMAP so they know exactly when each piece lands.

---
