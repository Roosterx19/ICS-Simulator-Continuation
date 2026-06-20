-- Expand the Capital City Hazmat Spill scenario from 4 → 11 injects.
--
-- The existing 4 injects (sort_order 0-3, see scenario 00000000-...-012)
-- form a doctrinally sound but skeletal timeline: dispatch + plume update
-- + HazMat Team arrival + instructor-fired resolution. Adds 7 new injects
-- (sort_order 4-10) extending the timeline through 85 minutes of compressed
-- classroom time and broadening HSEEP core capability coverage to include
-- Operational Communications, Critical Transportation, Mass Care, Public
-- Health & Medical, Situational Assessment, and On-scene Security.
--
-- Doctrine traceability per inject is documented inline. Annotations
-- distinguish "ESSD/OSHA-traceable" content from "fictional-plausible"
-- framing — instructors verifying against reference materials should
-- focus eyes-on review on the latter category.
--
-- All 7 new rows are pure DML inserts against the existing schema. No
-- new tables, columns, types, or constraints. Re-running this migration
-- after first apply WILL create duplicates (no ON CONFLICT — the schema
-- doesn't have a natural unique key on (scenario_id, sort_order)). The
-- supabase_migrations.schema_migrations tracker prevents re-runs in
-- normal operation.

INSERT INTO public.scenario_injects
  (scenario_id, sort_order, trigger_type, trigger_minutes, title, body, severity, affected_sections, related_form_codes)
VALUES

  -- ─────────────────────────────────────────────────────────────────
  -- Inject #4 — JIC activation, t=15min
  -- HSEEP capability: Operational Communications + Public Information & Warning
  -- ⚠️ FRAMING FICTIONAL-PLAUSIBLE (not ESSD-traceable):
  --   Capital City inter-jurisdictional JIC framework is plausible but
  --   not specified in ESSD reference materials. Verify with reference
  --   materials if instructor flags during demo.
  -- ─────────────────────────────────────────────────────────────────
  ('00000000-0000-0000-0000-000000000012', 4, 'time', 15,
   'JIC Activation Required — Media Surge',
   'Local TV affiliates and AP wire requesting on-scene access. PIO has fielded 14 calls in the last 12 minutes. Recommend Joint Information Center activation per ESF-15. Pine County PIOs and CCFD PIO can co-locate. Need Public Affairs Officer assignment within OP.',
   'warning',
   ARRAY['COMMAND','LOG'], ARRAY['ICS-205']),

  -- ─────────────────────────────────────────────────────────────────
  -- Inject #5 — Traffic control conflict, t=20min
  -- HSEEP capability: Critical Transportation + On-scene Security & LE
  -- ⚠️ FRAMING FICTIONAL-PLAUSIBLE (not ESSD-traceable):
  --   I-Capital Highway and the residential-streets-inside-shelter-zone
  --   conflict are scenario fictional geography (no Capital City detail
  --   map exists in ESSD). The traffic-vs-life-safety teaching tension
  --   is doctrine-valid as an HSEEP exercise inject.
  -- ─────────────────────────────────────────────────────────────────
  ('00000000-0000-0000-0000-000000000012', 5, 'time', 20,
   'Traffic Control — I-Capital Backup vs Shelter Zone',
   'I-Capital Highway closed at MM 47-50. State Patrol reports 5-mile backup northbound. SP requesting authority to detour southbound traffic through residential streets — but those streets are INSIDE the 1-mile shelter-in-place zone. Conflict between traffic flow and life safety. Need OPS guidance on detour routing.',
   'warning',
   ARRAY['OPS'], ARRAY['ICS-204']),

  -- ─────────────────────────────────────────────────────────────────
  -- Inject #6 — School day decision, t=25min, CHOICE-TYPE
  -- HSEEP capability: Mass Care Services + Public Information & Warning
  -- ⚠️ FRAMING FICTIONAL-PLAUSIBLE (not ESSD-traceable):
  --   School names (Capital North, Pine Hills, Westridge) are fictional.
  --   "Schools in plume path during school hours" is an HSEEP-classic
  --   teaching inject and was already established by existing inject #1.
  -- 🔍 VERIFICATION FLAG: this is the only choice-type inject in the
  --   round. The hardcoded ChoiceInjectPanel buttons (Order Evacuation /
  --   Shelter In Place / Monitor) map to this decision; verify in dev
  --   that the panel actually surfaces this inject when fired.
  -- ─────────────────────────────────────────────────────────────────
  ('00000000-0000-0000-0000-000000000012', 6, 'choice', NULL,
   'School Day Status — Bus Decision',
   'Three elementary schools (Capital North, Pine Hills, Westridge Elementary) are inside the plume path. School day in session — approximately 1,400 students plus staff. Superintendent requesting immediate guidance: continue shelter-in-place, evacuate to gymnasium-distance receiving sites, or hold buses pending plume clearance? Each option has different parent-notification and family-reunification implications.',
   'warning',
   ARRAY['COMMAND'], ARRAY['ICS-201']),

  -- ─────────────────────────────────────────────────────────────────
  -- Inject #7 — Medical surge, t=35min
  -- HSEEP capability: Public Health & Medical
  -- ✓ ESSD-TRACEABLE: Capital City Hospital is documented in
  --   docs/ics-knowledge/10_state-of-columbia-geography.md line 160.
  --   ESF-8 (Public Health and Medical Services) and MCI surge protocol
  --   are NIMS-standard.
  -- ─────────────────────────────────────────────────────────────────
  ('00000000-0000-0000-0000-000000000012', 7, 'time', 35,
   'Medical Surge — 4 Confirmed Exposures at Capital City Hospital',
   'First 4 chlorine-exposure patients arriving at Capital City Hospital ED. Hospital activating MCI surge protocol per ESF-8. Charge nurse requesting estimated additional patient count and ongoing medevac priority. Decon corridor at hospital being prepped. Coordinate with Medical Unit Leader on continuing patient flow and resource needs.',
   'warning',
   ARRAY['OPS','LOG'], ARRAY['ICS-206']),

  -- ─────────────────────────────────────────────────────────────────
  -- Inject #8 — Operational Period transition, t=50min
  -- HSEEP capability: Operational Coordination + Situational Assessment
  -- ✓ DOCTRINE-TRACEABLE: NIMS Planning P cycle. ICS-202 (Incident
  --   Objectives) and ICS-203 (Organization Assignment List) are
  --   the canonical OP-transition forms. ICS-203 has not been used by
  --   any existing inject in the DB; this is its first reference, and
  --   it's the doctrinally correct one.
  -- ─────────────────────────────────────────────────────────────────
  ('00000000-0000-0000-0000-000000000012', 8, 'time', 50,
   'Operational Period Transition — OP-2 IAP Required',
   'Approaching OP-1 boundary. Develop OP-2 Incident Action Plan. Decisions: continuity of current IC vs transition; updated objectives based on plume status; Section Chief assignments for OP-2; resource ordering for sustained operations. Planning P cycle: brief at OP transition. Submit ICS-202 + ICS-203 by end of OP-1.',
   'info',
   ARRAY['PLAN'], ARRAY['ICS-202','ICS-203']),

  -- ─────────────────────────────────────────────────────────────────
  -- Inject #9 — Level A hot zone entry, t=70min
  -- HSEEP capability: Hazmat Response + Operational Coordination
  -- ✓ DOCTRINE-TRACEABLE: OSHA HAZWOPER 1910.120 governs Level A
  --   entry procedures, SCBA air-supply discipline, accountability,
  --   and backup team requirements. RIT (Rapid Intervention Team)
  --   staging is NFPA-aligned standard practice.
  -- ─────────────────────────────────────────────────────────────────
  ('00000000-0000-0000-0000-000000000012', 9, 'time', 70,
   'Hot Zone Entry — Level A Tanker Patch Attempt',
   'HazMat Team executing Level A entry to attempt tanker patch. Per OSHA HAZWOPER 1910.120: 30-minute SCBA air-supply limit; entry team accountability via tag system; backup team in Level A standing by; Safety Officer briefed on entry plan. Medevac on standby elevation. Confirm RIT (Rapid Intervention Team) staged at decon corridor.',
   'warning',
   ARRAY['OPS','COMMAND'], ARRAY['ICS-204']),

  -- ─────────────────────────────────────────────────────────────────
  -- Inject #10 — Re-entry authorization, manual-fired
  -- HSEEP capability: Situational Assessment + Public Information & Warning
  -- ✓ DOCTRINE-TRACEABLE: OSHA chlorine PEL is 1ppm (8-hr TWA). Using
  --   <1ppm at perimeter monitoring stations as a re-entry threshold
  --   is conservative and defensible. Re-entry committee + phased lift
  --   is FEMA Recovery Framework standard practice.
  -- Manual trigger: instructor fires when they decide the response
  -- phase has run long enough to transition to recovery. Pairs with
  -- existing inject #3 ("HazMat Resolved — Decon Complete") which
  -- closes out the scenario after re-entry has been authorized.
  -- ─────────────────────────────────────────────────────────────────
  ('00000000-0000-0000-0000-000000000012', 10, 'manual', NULL,
   'Plume Cleared — Re-Entry Authorization Decision',
   'Atmospheric monitoring at all four perimeter stations confirms <1ppm chlorine (OSHA PEL ceiling). Re-entry committee recommending phased lift of shelter-in-place. Decision: phased re-entry by zone (start farthest from spill) or hold for 1-hour confirmation period across all stations? Public messaging via JIC required either path.',
   'info',
   ARRAY['COMMAND','OPS'], ARRAY['ICS-209']);
