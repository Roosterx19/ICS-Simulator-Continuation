-- Seed resources_catalog from data/resources.json
-- Source: FEMA ICS 300/400, NIMS Resource Typing Library
-- unit_cost_cents = cost_estimate * 100 (dollars → cents)

INSERT INTO public.resources_catalog
  (id, name, category, unit_cost_cents, unit, description, availability)
VALUES
  -- Fire
  (gen_random_uuid(), 'Type 1 Engine',           'fire',              120000, 'per day', 'Heavy structural fire engine, 1,000+ GPM pump, 400 gal tank, crew of 4', 'moderate'),
  (gen_random_uuid(), 'Type 3 Engine (Wildland)', 'fire',              90000, 'per day', 'Wildland/urban interface engine, 120 GPM pump, 500 gal tank, crew of 3', 'moderate'),
  (gen_random_uuid(), 'Ladder Truck',             'fire',             150000, 'per day', 'Aerial ladder platform, 100+ ft reach, crew of 4', 'moderate'),
  (gen_random_uuid(), 'Engine Strike Team',       'fire',             650000, 'per day', '5 Type 1 engines with leader — standardized resource for rapid deployment', 'difficult'),
  -- Medical / EMS
  (gen_random_uuid(), 'ALS Ambulance',            'medical',           80000, 'per day', 'Advanced Life Support ambulance, 2-person paramedic crew', 'easy'),
  (gen_random_uuid(), 'BLS Ambulance',            'medical',           60000, 'per day', 'Basic Life Support ambulance, 2-person EMT crew', 'easy'),
  (gen_random_uuid(), 'Mass Casualty Bus',        'medical',           40000, 'per day', 'Patient transport for non-critical MCI victims, seats 30', 'moderate'),
  (gen_random_uuid(), 'Medevac Helicopter',       'medical',          500000, 'per day', 'Air medical transport, single patient critical care', 'difficult'),
  -- Vehicles / Air
  (gen_random_uuid(), 'Recon Helicopter',         'vehicles',         350000, 'per day', 'Light helicopter for aerial observation and situation assessment', 'difficult'),
  (gen_random_uuid(), 'Swift Water Rescue Boat',  'vehicles',          60000, 'per day', 'Inflatable rescue craft for flood/swift water ops, crew of 2', 'moderate'),
  (gen_random_uuid(), 'Flat-Bottom Rescue Boat',  'vehicles',          40000, 'per day', 'Motorized flat-bottom for shallow flood water rescues, crew of 2', 'easy'),
  (gen_random_uuid(), 'Patrol Vehicle',           'law_enforcement',   35000, 'per day', 'Law enforcement patrol car, 1–2 officers', 'easy'),
  (gen_random_uuid(), 'Personnel Transport Bus',  'vehicles',          50000, 'per day', '55-passenger bus for evacuee or responder transport', 'easy'),
  (gen_random_uuid(), 'Fuel Tender',              'vehicles',          70000, 'per day', 'Mobile refueling truck, 2,500-gal capacity for field operations', 'moderate'),
  (gen_random_uuid(), 'Water Tender',             'vehicles',          55000, 'per day', 'Bulk potable water transport, 3,000-gal tank for incident camps', 'moderate'),
  -- Personnel teams
  (gen_random_uuid(), 'Swift Water Rescue Team',  'personnel',        240000, 'per day', '6-person swift water technician team with boats and gear', 'difficult'),
  (gen_random_uuid(), 'USAR Task Force',          'personnel',       2800000, 'per day', 'Urban Search and Rescue task force, 70 personnel with heavy rescue equipment', 'critical'),
  (gen_random_uuid(), 'HazMat Team',              'hazmat',           600000, 'per day', '12-person hazardous materials response team with decon and detection equipment', 'difficult'),
  (gen_random_uuid(), 'Red Cross Shelter Team',   'personnel',             0, 'per day', '8-person team to operate mass care shelter per ARC standards', 'easy'),
  (gen_random_uuid(), 'National Guard Platoon',   'military',         800000, 'per day', '40-person NG platoon for evacuation support, security, and logistics', 'moderate'),
  -- Equipment
  (gen_random_uuid(), 'Generator (100 kW)',       'communications',    45000, 'per day', 'Trailer-mounted 100 kW diesel generator for base camp or critical facilities', 'moderate'),
  (gen_random_uuid(), 'Generator (10 kW)',        'communications',    15000, 'per day', 'Portable 10 kW generator for field command post or light tower', 'easy'),
  (gen_random_uuid(), 'Light Tower',              'communications',    20000, 'per day', 'Trailer-mounted LED light tower, 4 × 1,000W, 360° coverage', 'easy'),
  (gen_random_uuid(), 'High-Volume Pump (6-inch)', 'vehicles',         30000, 'per day', 'Diesel trash pump, 6-inch, 3,000 GPM for flood dewatering', 'moderate'),
  (gen_random_uuid(), 'Satellite Comms Unit',     'communications',    80000, 'per day', 'VSAT broadband terminal for ICP connectivity when terrestrial networks fail', 'difficult'),
  (gen_random_uuid(), 'Radio Cache (25-unit)',     'communications',    50000, 'per day', '25 programmable P25-compliant portables with chargers and batteries', 'moderate'),
  -- Facilities / Command
  (gen_random_uuid(), 'Mobile Command Post',      'vehicles',         120000, 'per day', 'Self-contained ICP trailer with comms, displays, and workspace for 12', 'moderate'),
  (gen_random_uuid(), 'General Population Shelter','shelter',          200000, 'per day', 'ARC-compliant public shelter, school or civic center, capacity 200–500', 'easy'),
  (gen_random_uuid(), 'Medical Needs Shelter',    'shelter',           400000, 'per day', 'Shelter for evacuees with medical/functional needs, capacity 100, staffed by medical personnel', 'moderate'),
  (gen_random_uuid(), 'Base Camp (250 responders)','shelter',          800000, 'per day', 'Incident base with sleeping, food, sanitation, and refueling for 250 responders', 'moderate'),
  (gen_random_uuid(), 'Incident Command Post',    'vehicles',           50000, 'per day', 'Fixed or mobile location from which incident command operations are directed', 'easy'),
  (gen_random_uuid(), 'Staging Area',             'vehicles',           20000, 'per day', 'Designated location where resources await tactical assignment near incident', 'easy')
ON CONFLICT DO NOTHING;
