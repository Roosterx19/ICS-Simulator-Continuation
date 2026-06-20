-- ===================================================================
-- seed.sql
-- Reference data for Phase 1.
-- Safe to re-run (upserts only).
-- ===================================================================

-- -----------------------------------------------------------------
-- ics_roles
-- -----------------------------------------------------------------

insert into public.ics_roles (code, name, tier, section, reports_to_code, color_token, sort_order, description) values
  -- Command
  ('IC',          'Incident Commander',              'ic',      'COMMAND', null,   'role-ic',        100, 'Overall authority and responsibility for the incident.'),
  ('DEP_IC',      'Deputy Incident Commander',       'ic',      'COMMAND', 'IC',   'role-ic',        101, 'Fully qualified; can assume command.'),

  -- Command Staff
  ('SOFR',        'Safety Officer',                  'command', 'COMMAND', 'IC',   'role-command',   110, 'Monitors operational safety; can halt unsafe ops.'),
  ('ASST_SOFR',   'Assistant Safety Officer',        'command', 'COMMAND', 'SOFR', 'role-command',   111, null),
  ('PIO',         'Public Information Officer',      'command', 'COMMAND', 'IC',   'role-command',   120, 'Coordinates with media and public.'),
  ('ASST_PIO',    'Assistant PIO',                   'command', 'COMMAND', 'PIO',  'role-command',   121, null),
  ('LOFR',        'Liaison Officer',                 'command', 'COMMAND', 'IC',   'role-command',   130, 'Contact for assisting/cooperating agencies.'),
  ('ASST_LOFR',   'Assistant Liaison Officer',       'command', 'COMMAND', 'LOFR', 'role-command',   131, null),

  -- General Staff — Section Chiefs
  ('OSC',         'Operations Section Chief',        'section', 'OPS',     'IC',   'role-section',   200, 'Directs tactical operations.'),
  ('DEP_OSC',     'Deputy Operations Section Chief', 'section', 'OPS',     'OSC',  'role-section',   201, null),
  ('PSC',         'Planning Section Chief',          'section', 'PLAN',    'IC',   'role-section',   210, 'Collects info; prepares IAP.'),
  ('DEP_PSC',     'Deputy Planning Section Chief',   'section', 'PLAN',    'PSC',  'role-section',   211, null),
  ('LSC',         'Logistics Section Chief',         'section', 'LOG',     'IC',   'role-section',   220, 'Provides services and support.'),
  ('DEP_LSC',     'Deputy Logistics Section Chief',  'section', 'LOG',     'LSC',  'role-section',   221, null),
  ('FSC',         'Finance/Administration Section Chief', 'section', 'FIN', 'IC',  'role-section',   230, 'Money: time, procurement, claims, cost.'),
  ('DEP_FSC',     'Deputy Finance Section Chief',    'section', 'FIN',     'FSC',  'role-section',   231, null),
  ('ISC',         'Intelligence/Investigations Section Chief', 'section', 'II', 'IC', 'role-section', 240, 'Used when I/I established as its own section.'),

  -- Operations: Branch / Division / Group / Team / Resource
  ('OPS_BRANCH_DIR', 'Operations Branch Director',   'branch',   'OPS',    'OSC',  'role-boss',      300, null),
  ('DIV_SUPV',    'Division Supervisor',             'division', 'OPS',    'OSC',  'role-boss',      310, 'Geographic area.'),
  ('GRP_SUPV',    'Group Supervisor',                'division', 'OPS',    'OSC',  'role-boss',      320, 'Functional area.'),
  ('STAM',        'Staging Area Manager',            'leader',   'OPS',    'OSC',  'role-boss',      330, 'Manages tactical resources awaiting assignment.'),
  ('STRIKE_TEAM_LDR', 'Strike Team Leader',          'leader',   'OPS',    'DIV_SUPV', 'role-boss',  340, 'Same kind & type of resources.'),
  ('TASK_FORCE_LDR',  'Task Force Leader',           'leader',   'OPS',    'DIV_SUPV', 'role-boss',  350, 'Mixed resources.'),
  ('SINGLE_RESOURCE', 'Single Resource',             'resource', 'OPS',    'DIV_SUPV', 'role-staff', 360, 'One unit with a leader.'),
  ('AOBD',        'Air Operations Branch Director',  'branch',   'OPS',    'OSC',  'role-boss',      370, null),
  ('ATGS',        'Air Tactical Group Supervisor',   'division', 'OPS',    'AOBD', 'role-boss',      371, null),
  ('ASGS',        'Air Support Group Supervisor',    'division', 'OPS',    'AOBD', 'role-boss',      372, null),

  -- Planning Section units
  ('RESL',        'Resources Unit Leader',           'unit', 'PLAN', 'PSC', 'role-boss', 400, null),
  ('SITL',        'Situation Unit Leader',           'unit', 'PLAN', 'PSC', 'role-boss', 410, null),
  ('DOCL',        'Documentation Unit Leader',       'unit', 'PLAN', 'PSC', 'role-boss', 420, null),
  ('DMOB',        'Demobilization Unit Leader',      'unit', 'PLAN', 'PSC', 'role-boss', 430, null),
  ('THSP',        'Technical Specialist',            'unit', 'PLAN', 'PSC', 'role-staff', 440, 'Assigned to the section needing their skill.'),

  -- Logistics Section units
  ('SVBD',        'Service Branch Director',         'branch', 'LOG', 'LSC',  'role-boss', 500, null),
  ('SUBD',        'Support Branch Director',         'branch', 'LOG', 'LSC',  'role-boss', 510, null),
  ('COML',        'Communications Unit Leader',      'unit',   'LOG', 'SVBD', 'role-boss', 520, null),
  ('MEDL',        'Medical Unit Leader',             'unit',   'LOG', 'SVBD', 'role-boss', 530, null),
  ('FDUL',        'Food Unit Leader',                'unit',   'LOG', 'SVBD', 'role-boss', 540, null),
  ('SPUL',        'Supply Unit Leader',              'unit',   'LOG', 'SUBD', 'role-boss', 550, null),
  ('FACL',        'Facilities Unit Leader',          'unit',   'LOG', 'SUBD', 'role-boss', 560, null),
  ('GSUL',        'Ground Support Unit Leader',      'unit',   'LOG', 'SUBD', 'role-boss', 570, null),

  -- Finance/Admin Section units
  ('TIME',        'Time Unit Leader',                'unit', 'FIN', 'FSC', 'role-boss', 600, null),
  ('PROC',        'Procurement Unit Leader',         'unit', 'FIN', 'FSC', 'role-boss', 610, null),
  ('COMP',        'Compensation/Claims Unit Leader', 'unit', 'FIN', 'FSC', 'role-boss', 620, null),
  ('COST',        'Cost Unit Leader',                'unit', 'FIN', 'FSC', 'role-boss', 630, null),

  -- Agency rep
  ('AREP',        'Agency Representative',           'agency', null, 'LOFR', 'role-agency-rep', 700, 'Delegated to make agency decisions at the incident.')
on conflict (code) do update
  set name            = excluded.name,
      tier            = excluded.tier,
      section         = excluded.section,
      reports_to_code = excluded.reports_to_code,
      color_token     = excluded.color_token,
      sort_order      = excluded.sort_order,
      description     = excluded.description;


-- -----------------------------------------------------------------
-- ics_form_templates — Phase 1 ships ICS-201 only. Others are Phase 2+.
-- NOTE: json_schema here is a minimal stub. The canonical schema is
-- the zod definition in lib/ics/forms/ics201.ts, which should be
-- JSON-serialized and loaded here at seed time via a build step
-- (out of scope for this initial seed; hardcoded stub for now).
-- -----------------------------------------------------------------

insert into public.ics_form_templates (code, name, json_schema, required_signatures, visible_to_role_codes, phase) values
  ('ICS-201', 'Incident Briefing', '{"type":"object","required":["incident_name","prepared_by"],"properties":{"incident_name":{"type":"string"},"prepared_by":{"type":"string"},"date_time_prepared":{"type":"string","format":"date-time"},"operational_period":{"type":"integer"},"map_sketch_notes":{"type":"string"},"situation_summary":{"type":"string"},"health_safety_briefing":{"type":"string"},"current_objectives":{"type":"array","items":{"type":"string"}},"current_actions":{"type":"array","items":{"type":"string"}},"current_organization":{"type":"object"},"resource_summary":{"type":"array"}}}', array['IC'], array['IC','DEP_IC','SOFR','PIO','LOFR','OSC','PSC','LSC','FSC','ISC'], 1),

  ('ICS-202', 'Incident Objectives', '{"type":"object","required":["incident_name","operational_period","objectives","approved_by"]}', array['IC'], array['*'], 2),
  ('ICS-203', 'Organization Assignment List', '{"type":"object"}', array['PSC'], array['*'], 2),
  ('ICS-204', 'Assignment List', '{"type":"object"}', array['OSC','PSC'], array['DIV_SUPV','GRP_SUPV','STRIKE_TEAM_LDR','TASK_FORCE_LDR','OSC','PSC','IC','SOFR'], 2),
  ('ICS-205', 'Incident Radio Communications Plan', '{"type":"object"}', array['PSC'], array['*'], 2),
  ('ICS-206', 'Medical Plan', '{"type":"object"}', array['MEDL','SOFR'], array['MEDL','SOFR','LSC','PSC','OSC','IC','DEP_IC'], 2),
  ('ICS-208', 'Safety Message/Plan', '{"type":"object"}', array['SOFR'], array['*'], 2),
  ('ICS-209', 'Incident Status Summary', '{"type":"object"}', array['PSC'], array['IC','DEP_IC','SOFR','PIO','LOFR','OSC','PSC','LSC','FSC','ISC'], 2),
  ('ICS-214', 'Activity Log', '{"type":"object"}', array[]::text[], array['*'], 1),
  ('ICS-215', 'Operational Planning Worksheet', '{"type":"object"}', array['OSC','PSC'], array['OSC','DEP_OSC','PSC','DEP_PSC','SOFR','IC'], 2),
  ('ICS-215A', 'Incident Action Plan Safety Analysis', '{"type":"object"}', array['SOFR'], array['SOFR','OSC','PSC','IC'], 2)
on conflict (code) do update
  set name                  = excluded.name,
      json_schema           = excluded.json_schema,
      required_signatures   = excluded.required_signatures,
      visible_to_role_codes = excluded.visible_to_role_codes,
      phase                 = excluded.phase;


-- -----------------------------------------------------------------
-- scenarios — one seeded scenario for Phase 1 demo
-- -----------------------------------------------------------------

insert into public.scenarios (
  id, course_code, unit_code, title, city, summary,
  map_url, initial_budget_cents, operational_period_hours,
  delegation_letter_md, incident_type
) values (
  '00000000-0000-0000-0000-000000000001',
  'ICS300',
  'Unit-Demo',
  'Capital City — Warehouse Fire (Tutorial)',
  'CAPITAL',
  'A two-alarm warehouse fire in the Capital City industrial district. Mutual aid engines responding. Smoke plume affecting the adjacent residential block. Use this scenario to practice initial command, role selection, and filing the ICS-201.',
  null,  -- map_url: upload to scenario-maps bucket, set via admin
  50000000,  -- $500,000 initial budget
  12,
  '# Letter of Expectation — Capital City Warehouse Fire

**To:** Incident Commander
**From:** Capital City Fire Chief

You are assigned as Incident Commander for the warehouse fire at 1400 Industrial Way. You are authorized to commit all on-duty Capital City Fire resources and to request mutual aid as needed.

**Priorities:**
1. Life safety — evacuate the adjacent block if smoke conditions warrant.
2. Protect exposures — prevent spread to adjacent warehouse.
3. Confine and extinguish.

**Constraints:**
- Budget ceiling for operational period 1: $250,000
- Report status to this office every 2 hours
- No interior operations until building stability confirmed

**Political context:**
- Media presence expected within 30 minutes
- Adjacent residential block includes an assisted-living facility',
  4  -- Type 4
)
on conflict (id) do update
  set title               = excluded.title,
      summary             = excluded.summary,
      initial_budget_cents = excluded.initial_budget_cents;
