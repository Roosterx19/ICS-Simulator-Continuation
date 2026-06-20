# Scenarios Library

**Source:** Extracted from the ICS 400 Slideshow (April 2019, `/mnt/project/ICS400_SLideshow.pdf` — text dump). These are the official FEMA training scenarios used in the course. The simulator should reproduce them with high fidelity so that instructor Dana (persona) can use the sim without deviating from the curriculum.

**⚠️ Status on maps:** The file in `/mnt/project/ICS400_SLideshow.pdf` is a text extract, **not an actual PDF**. Scenario map images cannot be extracted from it. Two follow-up options:
1. User uploads the original PDF (then maps can be extracted via `pdftoppm` / `pdfimages`)
2. User exports the relevant scenario-map pages as PNGs and uploads them directly

Scenarios below can be seeded without map images; `map_url` stays null until maps arrive.

---

## Naming Convention

Scenario code: `<COURSE>_U<UNIT>_<SLUG>`
Examples: `ICS400_U3_LIBERTY_SEVERE_WX`, `ICS400_U4_MURKEY_RIVER`, `ICS400_U5_GORDON`.

---

## SCENARIO 1 — Liberty County Severe Weather (ICS 400, Unit 3, Activity 3.1)

**Code:** `ICS400_U3_LIBERTY_SEVERE_WX`
**Course:** ICS 400
**Unit:** 3 — Complex Incident Management
**Activity:** 3.1 — Create an Incident Complex Structure
**Type:** Type 2 (approaching Type 1 due to multi-incident + media + volunteers)
**Incident Type Mix:** Severe weather + multiple simultaneous response incidents
**Legal Framework:** Local + state mutual aid; Stafford-eligible if state requests
**Operational Periods:** 2–3 × 12h
**Objective (instructional):** Students create an Incident Complex structure and decide single vs. Unified Command, whether to split Operations/Logistics/Planning, whether to establish Intel/Investigations.

### Narrative
A major portion of Liberty County has been affected by sudden severe weather. During the severe weather incident, a passenger train derailed. Four incidents are currently reported within a 10-square-mile area of the county that includes portions of Central City. During the initial response these are being managed as individual incidents. The incidents are being reported on national-level news networks. The city and county possess limited resources.

### The Four Incidents
| # | Incident | Location | Key Details |
|---|---|---|---|
| 1 | Hospital damage | Central City (private hospital) | Evacuation, SAR, relocation of 50 patients |
| 2 | Mobile home park damage | Liberty County, outside Central City | 50-unit MHP; 6 residents trapped in two overturned units; others unaccounted |
| 3 | School roof partial collapse | Central City limits | Unknown number trapped; injuries expected, fatalities possible; volunteers self-deploying |
| 4 | AMTRAK train derailment | Central City limits | 40 people onboard; multi-casualty; blocking major road; cause unknown — requires investigation |

### Command Structure Decision Points (what the sim must surface)
- Single IC vs. **Unified Command** (EMS + Fire + LE + AMTRAK + FBI for derailment cause)
- **Incident Complex** structure encompassing all four incidents under a single IC/UC
- Whether to add **Intel/Investigations section** (yes, due to derailment cause investigation)
- Volunteer management (CERT integration — user explicitly wanted this)
- Media coordination (PIO + JIC posture)

### Resource Pressure
Implied by "city and county possess limited resources" — budget scarcity should be active. Trigger for state mutual aid request, trigger for EMAC if multi-state.

---

## SCENARIO 2 — Murkey River Area Command (ICS 400, Unit 4)

**Code:** `ICS400_U4_MURKEY_RIVER`
**Course:** ICS 400
**Unit:** 4 — Area Command
**Type:** Type 2 / Type 1
**Incident Type Mix:** Flooding + jail damage + hazmat + train derailment + gas fire
**Legal Framework:** State disaster declaration likely; EPA/USCG involvement for hazmat in river (navigable waters?); Stafford-eligible
**Operational Periods:** 3+ × 12h
**Objective (instructional):** Students develop an **Area Command organization** to manage competing resource demands across four simultaneous incidents in Jackson County.

### Narrative
The Murkey River flows south through the Granite Mountain foothills and then through Prosperous Valley. Severe weather followed by flooding caused by emergency release of water from a weakened upstream dam has created several major incidents along the east bank of the river in Jackson County. More rain and wind expected over the next several days.

### The Four Incidents
| # | Incident | Command Posture | Key Details |
|---|---|---|---|
| 1 | County Jail + Juvenile Detention damage | County Sheriff's Captain as IC | 450 adult males, 175 females, 250 male juveniles; no power/water; relocation may be required; cold meals and limited water only |
| 2 | Baytown flooding (Incident Complex) | Baytown PD IC | 10-block extensive flooding; SAR + evacuations underway; no power; damaged water/sewer |
| 3 | Train derailment over Murkey River | **Unified Command** (county fire + sheriff) | Southbound train derailed due to undermined track; tank car with unknown chemical leaking into river |
| 4 | Fryville gas-line rupture + grocery warehouse fire | Fryville Volunteer FD Chief as IC | Ignited gas line → warehouse fire; injuries; fire spread risk; low water pressure |

### Scarce Resources (explicit in curriculum)
- Only **2 uncommitted IMTs** in next 12 hours
- Only **1 LE supervisor + 40 LE with patrol vehicles** uncommitted
- Only **4 engine companies + 2 Type-I water tenders** available

### Outstanding Resource Orders (per incident — use as budget/resource tracking seed)
**Baytown Complex:**
- 20 LE officers + patrol vehicles
- 5 Type III BLS Ambulances
- 2 Truck companies (Type I trucks)
- 2 Type I Swiftwater/Flood SAR + Dive Rescue Teams
- FSC + Cost UL + Time UL

**Jail/Juvenile Center:**
- 20 LE officers + patrol vehicles
- Generator (facility-sized)
- Full Planning Section (PSC, RESL, SITL, Intel UL, DOCL)
- Logistics SC + Supply + Food + Ground Support ULs

**Train Derailment:**
- 1 Type I Hazmat Entry Team
- 4 Engine companies (Type I)
- 10 LE officers + patrol vehicles + LE supervisor
- FSC + PSC + RESL + SITL
- LSC + Supply UL + Comms UL + Ground Support UL

**Fryville:**
- 10 LE officers + patrol vehicles + LE supervisor
- 4 Engine companies (Type I)
- 4 Type I Water Tenders
- PSC + RESL + SITL
- LSC + Supply UL + Comms UL + Ground Support UL

### Command Structure Decision Points
- **Area Command** is the pre-declared answer — but students must justify: proximity, life safety, multi-operational-period, similar resources, inter-incident allocation difficulty all present
- Unified Area Command (cross-jurisdiction) likely warranted
- EOC (county) is active
- MAC Group activation once state resources engage
- Hazmat in river = potential EPA (inland) or USCG (if navigable) lead on that specific incident

---

## SCENARIO 3 — Hurricane Gordon / State of Columbia (ICS 400, Unit 5 Capstone)

**Code:** `ICS400_U5_GORDON`
**Course:** ICS 400
**Unit:** 5 — Interconnectivity of NIMS Command and Coordination Structures (Capstone Activity)
**Type:** Type 1 (catastrophic)
**Incident Type Mix:** Category 2 hurricane → widespread damage, infrastructure collapse, multi-county
**Legal Framework:** Stafford Act major disaster declaration; full NRF/NDRF activation; multiple ESFs; state EOC → RRCC → NRCC → JFO
**Operational Periods:** Multiple — scenario is "T+48 hours"
**Objective (instructional):** Use the **full range** of NIMS command and coordination functional groups to organize a disaster.

### Narrative
On October 17, the State of Columbia was struck by Hurricane Gordon, a Category 2 hurricane. Seven counties were hard hit (Stramford, Granite, Redstone, Liberty, Green, Mineral, Kane), with the most damage in **Liberty County**. Hurricane came ashore between Masland and Gish islands; eye tracked over Bayport, Fisherville, Deep River, Central City. Track then turned east along Highway 19 to Brooksville before downgrading to tropical storm. **48 hours have passed** — basic services restoring in Liberty County; some areas have basic water/power; attention turning to long-term damage assessment, debris removal, and economic restoration.

### Liberty County Detail
- Direct hit; hurricane passed between Masland and Gish
- Bayport, Fisherville, Deep River: severe wind + flooding
- 8–12 ft storm surge + torrential rain
- Central City: 14 inches of rain in 36 hours → river flooding + severe wind damage
- Many roads washed out or impassable (downed trees + power lines)
- Kingston Airport: severe damage to main terminal + support facilities
- Columbia Bay Bridge (Bayport–Fisherville): **closed**
- Rail transportation in Liberty County: **suspended pending inspection**
- Central City Hospital: **operating on backup generator**

### State of Columbia
- State EOC activated to address county EOC needs across all 7 hit counties

### The Four Groups in the Capstone (all simultaneously active)
| Group | Body | Primary Task |
|---|---|---|
| 1 | **Central City Incident Complex** | Run the largest concentrated response — multi-incident complex under single IC/UC |
| 2 | **Turtle River Area Command** | Area Command over multiple incidents along Turtle River watershed |
| 3 | **Liberty County EOC** | County-level coordination, resource allocation, policy |
| 4 | **Columbia State EOC** | State-level MAC/coordination, federal liaison, state-to-state mutual aid (EMAC) |

Communication between groups uses **ICS Form 213 General Message**. Groups must negotiate — some strategies depend on other groups' actions.

### ESF Activation (expected)
- ESF-1 Transportation (road/rail/airport)
- ESF-3 Public Works & Engineering (debris, infrastructure)
- ESF-6 Mass Care (sheltering displaced residents)
- ESF-8 Public Health & Medical (hospital on backup, medical surge)
- ESF-12 Energy (grid restoration)
- ESF-13 Public Safety & Security
- ESF-15 External Affairs (JIC active)

### Recovery (48h in, entering recovery phase)
All 6 RSFs potentially engageable:
- Community Planning & Capacity Building
- Economic Recovery
- Health and Social Services
- Housing
- Infrastructure Systems
- Natural and Cultural Resources

---

## SCENARIO 4 — Area Command: Pre-Planned Snow Storm (ICS 400, Unit 4 teaching example)

**Code:** `ICS400_U4_SNOW_STORM`
**Course:** ICS 400
**Unit:** 4 — Area Command
**Type:** Type 3 (pre-planned event, multi-jurisdiction)
**Incident Type Mix:** Planned response to forecast severe weather
**Legal Framework:** County emergency declaration; mutual aid
**Operational Periods:** 2 × 24h (planning period + response period)
**Objective (instructional):** Demonstrate proactive Area Command establishment.

### Narrative
County government officials have been briefed by the local weather service, which is predicting a major snowfall of **3 feet within the next 36 hours**. Officials are concerned about the large amount of snowfall in an area not used to receiving much snow. The current infrastructure will not be able to remove snow quickly enough. Officials will be shutting down businesses and all schools while maintaining operations of critical emergency response infrastructure. Three cities — **Springfield, Dayton, and River Bend** — will each have their own Incident Management Teams, with the Area Command being located in the **county courthouse**.

### Command Structure
- Three city-level Incident Commanders (Springfield, Dayton, River Bend)
- County-level **Area Command** at the county courthouse
- County EOC in support

### Teaching Points
- Area Command as *proactive* choice, not just reactive
- Consistent strategy across three cities with different demographics/infrastructure
- Resource competition for plows, salt, fuel, sheltering capacity

---

## SCENARIO 5 — Area Command: July 4th / Terrorist Threat (ICS 400, Unit 4 teaching example)

**Code:** `ICS400_U4_JULY_4TH`
**Course:** ICS 400
**Unit:** 4 — Area Command
**Type:** Type 2 (NSSE-adjacent, intel-driven)
**Incident Type Mix:** Planned event + elevated terrorism threat + possible WMD indicators
**Legal Framework:** Local + state + federal (FBI counterterrorism) coordination; potential DOJ/FBI lead for investigation; ATF if explosives
**Operational Periods:** 3 × 8h (pre-event, event, post-event)
**Objective (instructional):** Area Command for a pre-planned event with significant intel/investigations component.

### Narrative
Two adjacent communities — **Central City and River Bend** — and the county (**Liberty**) are all planning large July 4th celebrations: parades, fairs, evening fireworks. The three celebrations' organizers are planning separately and are not coordinating. Local government leaders are concerned about the lack of coordination and the need for tight security. Law enforcement has heard chatter indicating a high probability of **civil unrest and potential WMD activity**. The region has limited vendor resources and has experienced severe health problems when using fair vendors from outside the area. Traffic problems associated with each celebration will impact the others.

### Command Structure
- Three city/county-level ICs
- **Area Command** over the three events
- **Intel/Investigations** function heavily engaged (threat fusion, FBI JTTF coordination)
- JIC for unified public messaging
- MAC Group for resource prioritization (LE tactical teams, bomb squads, hazmat)

### Teaching Points
- Area Command for distributed planned events
- Intelligence management under NIMS (Management Characteristic #14)
- Multi-agency public safety posture
- Health/vendor safety concerns (ESF-8 engagement)

---

## Phase Mapping

| Scenario | MVP (Phase 1)? | Full Feature Need |
|---|---|---|
| **#4 Snow Storm** | ✅ Tutorial scenario (lowest complexity) | Basic: role selection + ICS-201 + ICS-202 |
| **#1 Liberty Severe WX** | — | Phase 2: Incident Complex, full IAP, budget, resources |
| **#5 July 4th** | — | Phase 2: Area Command, Intel/Investigations |
| **#2 Murkey River** | — | Phase 2/3: Area Command + UC, realtime if multi-student |
| **#3 Hurricane Gordon** | — | Phase 3+: Capstone — 4 groups simultaneous, full federal coord, NRCC/RRCC/JFO |

For Phase 1 MVP, **Scenario #4 (Snow Storm)** is the cleanest tutorial because it has a pre-planned posture (no surprise), only 3 ICPs + 1 Area Command, minimal resource pressure compared to the others, and a natural stopping point.

---

## Data Model Alignment

The `scenarios` table (per `supabase/migrations/0001_initial.sql` and `docs/watts/07_architecture.md`) already supports these scenarios. Additional columns useful in Phase 2:

```sql
alter table public.scenarios
  add column scenario_type text,                  -- 'incident_complex' | 'area_command' | 'single_incident' | 'capstone'
  add column legal_framework text,                -- 'stafford' | 'non_stafford' | 'local_state' | 'local'
  add column lead_federal_agency text,            -- null | 'FEMA' | 'USCG' | 'EPA' | 'DOJ/FBI' | etc.
  add column expected_esfs text[],                -- ['ESF-1', 'ESF-3', 'ESF-6', ...]
  add column initial_resource_constraints jsonb;  -- the "2 IMTs, 40 LE, 4 engines" seed
```

Seed rows live in `supabase/seed_scenarios.sql`. Create in Phase 2 migration.
