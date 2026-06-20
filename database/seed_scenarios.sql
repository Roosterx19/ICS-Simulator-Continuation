-- ===================================================================
-- seed_scenarios.sql
-- Training scenarios extracted from ICS 400 curriculum.
-- Source: docs/ics-knowledge/10_scenarios-library.md
--
-- ⚠️  PHASE 2 — DO NOT APPLY YET.
-- This file depends on Phase 2 schema additions to the `scenarios` table:
--   alter table public.scenarios
--     add column scenario_type text,
--     add column legal_framework text,
--     add column lead_federal_agency text,
--     add column expected_esfs text[],
--     add column initial_resource_constraints jsonb;
--
-- Apply that migration first (supabase/migrations/0002_scenarios_phase2.sql
-- which Claude Code will write when Phase 2 begins), then run this seed.
--
-- Idempotent: uses ON CONFLICT (code) DO UPDATE so repeated runs are safe.
-- Map URLs are NULL until the actual ICS 400 PDF is uploaded and maps are
-- extracted into the `scenario-maps` Storage bucket.
-- ===================================================================

insert into public.scenarios (
  code,
  course_code,
  unit_code,
  title,
  city,
  map_url,
  summary,
  initial_budget_cents,
  operational_period_hours,
  scenario_type,
  legal_framework,
  lead_federal_agency,
  expected_esfs,
  initial_resource_constraints
) values

-- -------------------------------------------------------------------
-- SCENARIO 1 — Liberty County Severe Weather (Unit 3 Activity 3.1)
-- -------------------------------------------------------------------
(
  'ICS400_U3_LIBERTY_SEVERE_WX',
  'ICS400',
  'U3',
  'Liberty County Severe Weather + AMTRAK Derailment',
  'Central City',
  null,
  'Sudden severe weather has caused four simultaneous incidents across a 10-square-mile area of Liberty County including portions of Central City: hospital damage requiring evacuation of 50 patients, a 50-unit mobile home park with residents trapped, partial school roof collapse with volunteers self-deploying, and an AMTRAK derailment with 40 onboard. City and county resources are limited. National media is on scene.',
  5000000,        -- $50,000 starting budget (constrained)
  12,
  'incident_complex',
  'local_state',
  null,
  array['ESF-5','ESF-6','ESF-8','ESF-9','ESF-13','ESF-15'],
  jsonb_build_object(
    'hospital_patients_to_relocate', 50,
    'mobile_home_trapped', 6,
    'train_onboard', 40,
    'media_presence', 'national',
    'volunteers_self_deploying', true
  )
),

-- -------------------------------------------------------------------
-- SCENARIO 2 — Murkey River Area Command (Unit 4)
-- -------------------------------------------------------------------
(
  'ICS400_U4_MURKEY_RIVER',
  'ICS400',
  'U4',
  'Murkey River Area Command — Multi-Incident Flooding',
  'Jackson County',
  null,
  'Severe weather + emergency release from a weakened upstream dam have created four major incidents along the east bank of the Murkey River: county jail + juvenile detention damage requiring relocation of 875 inmates, 10-block flooding in Baytown, hazmat train derailment with chemical leak into river (Unified Command), and a gas-line rupture causing warehouse fire in Fryville. More rain/wind expected. Scarce resources: 2 uncommitted IMTs, 40 LE, 4 engine companies, 2 Type-I water tenders.',
  10000000,       -- $100,000 starting budget
  12,
  'area_command',
  'stafford',
  'FEMA',
  array['ESF-3','ESF-4','ESF-8','ESF-9','ESF-10','ESF-13'],
  jsonb_build_object(
    'uncommitted_imts', 2,
    'uncommitted_le_supervisors', 1,
    'uncommitted_le_officers', 40,
    'available_engine_companies', 4,
    'available_water_tenders_type1', 2,
    'jail_population_adult_male', 450,
    'jail_population_adult_female', 175,
    'jail_population_juvenile_male', 250,
    'hazmat_in_navigable_water', true
  )
),

-- -------------------------------------------------------------------
-- SCENARIO 3 — Hurricane Gordon (Unit 5 Capstone)
-- -------------------------------------------------------------------
(
  'ICS400_U5_GORDON',
  'ICS400',
  'U5',
  'Hurricane Gordon — State of Columbia Capstone',
  'Liberty County',
  null,
  'Category 2 Hurricane Gordon struck the State of Columbia on October 17, hitting seven counties with Liberty County suffering the worst. T+48 hours: basic services restoring, 8-12 ft storm surge, Kingston Airport terminal severely damaged, Columbia Bay Bridge closed, rail suspended, Central City Hospital on backup generator. Four simultaneous groups activate: Central City Incident Complex, Turtle River Area Command, Liberty County EOC, Columbia State EOC. Full NRF activation expected.',
  100000000,      -- $1,000,000 starting budget (catastrophic)
  24,
  'capstone',
  'stafford',
  'FEMA',
  array['ESF-1','ESF-3','ESF-6','ESF-8','ESF-12','ESF-13','ESF-15'],
  jsonb_build_object(
    'counties_affected', 7,
    'hours_since_impact', 48,
    'storm_surge_feet', '8-12',
    'central_city_rainfall_inches', 14,
    'rainfall_window_hours', 36,
    'hospital_on_backup', true,
    'bridge_closed', 'Columbia Bay Bridge (Bayport-Fisherville)',
    'airport_damaged', 'Kingston Airport',
    'rail_suspended', true,
    'active_groups', 4
  )
),

-- -------------------------------------------------------------------
-- SCENARIO 4 — Pre-Planned Snow Storm (Unit 4 teaching example) — MVP TUTORIAL
-- -------------------------------------------------------------------
(
  'ICS400_U4_SNOW_STORM',
  'ICS400',
  'U4',
  'Pre-Planned Area Command: 3-Foot Snowfall',
  'County Seat',
  null,
  'Weather service predicts 3 feet of snowfall within 36 hours in an area not accustomed to heavy snow. County officials shut down businesses and schools while maintaining critical emergency response infrastructure. Three cities (Springfield, Dayton, River Bend) establish their own IMTs; Area Command is located at the county courthouse. Proactive, pre-event activation — the cleanest demonstration of when and why to use Area Command.',
  2500000,        -- $25,000 starting budget (planned event, low intensity)
  24,
  'area_command',
  'local',
  null,
  array['ESF-1','ESF-3','ESF-6'],
  jsonb_build_object(
    'forecast_snowfall_feet', 3,
    'forecast_window_hours', 36,
    'cities_with_imt', array['Springfield','Dayton','River Bend'],
    'area_command_location', 'County Courthouse',
    'pre_planned', true
  )
),

-- -------------------------------------------------------------------
-- SCENARIO 5 — July 4th Celebration + Terrorist Threat (Unit 4 teaching example)
-- -------------------------------------------------------------------
(
  'ICS400_U4_JULY_4TH',
  'ICS400',
  'U4',
  'Area Command: July 4th Events + Elevated Terror Threat',
  'Central City',
  null,
  'Central City, River Bend, and Liberty County are each planning separate large July 4th celebrations (parades, fairs, evening fireworks) with no inter-event coordination. Law enforcement has received chatter indicating high probability of civil unrest and potential WMD activity. Regional vendor resources are limited and prior fair vendors have caused severe health problems. Traffic from each celebration impacts the others. Heavy Intel/Investigations component; JIC required for unified public messaging.',
  7500000,        -- $75,000 starting budget (pre-planned + security surge)
  8,
  'area_command',
  'non_stafford',
  'DOJ/FBI',
  array['ESF-8','ESF-13','ESF-15'],
  jsonb_build_object(
    'events', array['Central City Parade/Fireworks','River Bend Fair','Liberty County Fair'],
    'threat_level', 'elevated',
    'wmd_chatter', true,
    'civil_unrest_risk', 'high',
    'prior_vendor_health_issues', true,
    'intel_investigations_active', true
  )
)

on conflict (code) do update set
  course_code = excluded.course_code,
  unit_code = excluded.unit_code,
  title = excluded.title,
  city = excluded.city,
  summary = excluded.summary,
  initial_budget_cents = excluded.initial_budget_cents,
  operational_period_hours = excluded.operational_period_hours,
  scenario_type = excluded.scenario_type,
  legal_framework = excluded.legal_framework,
  lead_federal_agency = excluded.lead_federal_agency,
  expected_esfs = excluded.expected_esfs,
  initial_resource_constraints = excluded.initial_resource_constraints;
  -- map_url intentionally NOT overwritten — it may be set manually after
  -- scenario-maps storage bucket is populated.

-- ===================================================================
-- Follow-up TODO for Phase 2 scenario work:
--   1. Create supabase/migrations/0002_scenarios_phase2.sql with the
--      column additions listed in the header comment above.
--   2. PNGs for the FEMA training atlas are already extracted into
--      supabase/storage-seed/scenario-maps/ (33 maps covering State of
--      Columbia, Liberty County, Central City, Bayport, RRTC, etc. —
--      see docs/ics-knowledge/10_state-of-columbia-geography.md).
--      Upload them to the `scenario-maps` Storage bucket preserving
--      filenames. Update map_url per scenario.
--   3. Build scenario-specific resource_allocations seed for
--      ICS400_U4_MURKEY_RIVER using the "Outstanding Resource Orders"
--      table in docs/ics-knowledge/10_scenarios-library.md.
-- ===================================================================
