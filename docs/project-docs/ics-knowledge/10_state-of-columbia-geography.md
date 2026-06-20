# State of Columbia — Fictional Training Geography

**Source:** FEMA Exercise Simulation System Document, *Maps and Diagrams* Revision 3.0 (April 2012), Appendix Z. Uploaded as `FEMA_Maps_and_Base.pdf`. Supplemented by the ICS 300 *Central City Flood Scenario* (AAM-165 to AAM-172).

**Status:** This is the authoritative world reference for every scenario. If any scenario, form, or tooltip names a place not listed here, it is invented and should be flagged for removal.

---

## Critical naming correction

**Earlier drafts of this project referenced "Liberty City."** That place does not exist in the FEMA training world. The correct name is **Central City**, which sits inside **Liberty County**. The user's original brief conflated the two, and that conflation propagated into several files before this reference was extracted. See `decisions-log.md` entry dated 2026-04-17 (map extraction) for the full correction log.

- ❌ "Liberty City" — does not exist
- ✅ **Central City** — the primary training city
- ✅ **Liberty County** — the county containing Central City
- ✅ **Capital City** — **a different place**; the state capital of Columbia, located in Pine County

---

## State of Columbia — top-level facts

A fictional U.S. state created by FEMA for incident command training exercises. Modeled loosely on a mid-Atlantic coastal state.

- **Neighbors:** State of Marshall (north-west), State of Franklin (north-east), State of Taft (south-west), Mexico (south-west), Canada (north tip), Atlantic Ocean (east and south)
- **Major waterways:** Grand River, Mossy Creek, Roaring River, East Lake River, Swatera Creek, Turtle River, Columbia Bay
- **Major lakes:** East Lake, Gulz Lake, Lake Modor, Lake Kilgore, Lake George, Deer Lake, Gold Mine Lake
- **Interstates:** I-102 (east-west southern), I-107 (north-south)
- **Reference map:** `z01_state_of_columbia.png`

---

## Counties (shown in FEMA atlas)

The state atlas includes at least these counties. Only the ones with their own detailed map are primary training zones; the others provide context for mutual-aid and MAC-group scenarios.

### Primary training zone
| County | Seat / Major City | Population tier | Notes |
|---|---|---|---|
| **Liberty** | **Central City** | Over 50,000 | Main training zone. Coastal. Has a tribal enclave (see RRTC). |

### Secondary/context counties (with individual maps)
| County | Seat | Notable |
|---|---|---|
| Apple | Crows Point | Rural; Shelby and Levering are small towns |
| Granite | Jamestown | I-102 runs through; also has Schwartz and Hibbing |
| Green | Monroe | Adjacent to Liberty; contains Roaring River Tribal Community area + Zurich |
| Kane | Clifton | Contains Deer Lake, Murray Hill, Rusten, Gable, Lodge, Largot |
| Mineral | Bradley | Ceresco, Wicks, Danton, Sumpter; Roaring River runs through |
| Stramford | Tower Beach | Forksville, Hughsville, Lewisburg, Harbor Place; Lonely River |

### Referenced-but-not-in-detail counties
- Laye, Johnson, George, Witcher (northern tier)
- Cass, Pine, Redstone (mid-tier)
- Triangle, Hamilton (central — Hamilton contains **Capital City**)
- Lober (south-western — contains Lamar, Cassel, Hyerstown)

---

## Liberty County — the primary training zone

### Cities and towns within Liberty County
| Name | Population tier | Role |
|---|---|---|
| **Central City** | Over 50,000 | County seat; core training city |
| **Harvest Junction** | Over 50,000 | Secondary city; east of Central City |
| Apple Valley | 0–25,000 | West of Central City |
| Blue Water | 0–25,000 | Far north near Mineral County line |
| Deep River | 0–25,000 | South, between Central City and coast |
| Fisherville | 0–25,000 | South, coastal-adjacent |
| Jasper | 0–25,000 | Southeast, on Highway 69 |
| Kingston | 25,001–50,000 | East, near Liberty International Airport |
| **Bayport** | 0–25,000 | Coastal city on Columbia Bay; contains Buffets Landing, refinery, ports |
| Orchard Pike | — | Rural road area |

### Key Liberty County features
- **East Lake** — large lake in north-east; the dam that could fail in the flood scenario
- **Liberty International Airport** — at Kingston, the only major airport in-county
- **Mineral Mountains** — northwest elevation (county line with Mineral County)
- **Van Deusen Park and Campground** — large state park in the west
- **Gish Island National Wildlife Refuge** — coastal, Atlantic side
- **Robert S. Haywood State Park** — coastal south
- **Columbia Bay** — Bayport's waterfront, Atlantic access
- **Roaring River** — flows through the county east-west
- **Turtle River** — flows from north through Deep River, Fisherville, to Columbia Bay
- **Reference maps:** `z04_liberty_county.png`, `z05_liberty_county_land_use.png`, `z03_liberty_county_beaches_marshes.png`

---

## Central City — the primary training city

A gridded city divided by the Roaring River. North of the river is bordered by Swatera Creek (northwest). Scale: **10.5 blocks = 1 mile.** Grid coordinates use letters (A–SS, horizontal) and numbers (0–41, vertical) — this grid is how Division Supervisors carve geographic divisions in the sim.

### Landmarks (from `z06_central_city.png`)
- **Fire Stations** 1–11 plus Training Center, plus **Station 12** at Liberty International Airport in Kingston
- **Central City Police Station** (plus satellites per CCPD map)
- **Hospitals:** Columbia Veterans, Faith, Levine, Central City Hospital (plus Farmers A&M University campus hospital)
- **Universities:** Farmers A&M University (north), Columbia State University (south-east)
- **Parks:** Northside Park, Southside Park, Central City Public Golf Course
- **Water features:** Central City North Lake, Central City South Lake, Roaring River, Swatera Creek
- **Utilities:** Electric power stations, telephone switchboards, radio/TV stations, reservoirs
- **Government:** County Courthouse, Nelson Center, City Hall, Emergency Management Center
- **Logistics:** Food storage warehouses, fuel storage tanks (1–5), City Equipment Yard, Heavy Equipment Areas, City Transportation Centers, National Guard Facilities, Relocation Centers

### Central City land use (from `z07_central_city_land_use.png`)
The city is zoned into Single Family Housing (numbered/lettered subdivisions 1–14 and A–H), Multi-Family Housing, Commercial Area, Industrial Area (primarily along the south-central belt), a **Down Town Business District** in the center, Educational zone (north-east, Farmers A&M), and mixed Industrial/Commercial/Multi-Family at the north border.

### Central City administrative divisions
- **Fire Marshal Quadrants:** FM 3 NW, FM 4 NE, FM 5 SW, FM 6 SE (from `z18`)
- **Police Areas:** 1, 2, 3, 4 (from `z22`)
- **Storm drain network:** extensive grid, flow direction mapped (from `z26`)

---

## Roaring River Tribal Community (RRTC)

A federally recognized tribal community spanning parts of Liberty, Mineral, Green, and Kane counties — critical for Unified Command training because **tribal jurisdiction is a co-equal sovereign authority**. Any incident on tribal land automatically makes the tribal IC a Unified Command member.

- **Reference map:** `z02_roaring_river_tribal_community.png`
- **Extent:** Green-hatched region spanning Blue Water (north) to Monroe (south), Roaring River valley
- **Key places:** Murray Hill, Big Rock, Tribal Route 1
- **Hospital:** Roaring River Tribal Hospital (`z10` state map, `z02` detail)
- **Simulator implication:** scenarios tagged `involves_tribal = true` must open a tribal IC slot in the role-select board and route scenario messages to the tribal IC alongside the jurisdictional IC(s).

---

## Capital City — the state capital (different place)

- **Location:** Pine County, central-west part of the state
- **Not** a primary training zone for the materials we have — the FEMA atlas does not include a Capital City city-detail map
- Listed here only so Claude Code doesn't confuse it with Central City

If a scenario is set in Capital City (e.g., the tutorial warehouse fire currently seeded), it uses generic industrial/residential descriptions rather than the grid-accurate map content that's available for Central City.

---

## Bayport — coastal city with critical infrastructure

A smaller city in Liberty County on Columbia Bay, but critically includes:
- **Refinery** (Bayport Refinery)
- **Cruise Ship Port of Entry** and **Cargo Ship Port of Entry**
- **LNG Terminal**
- **Power Substation** (Edison Electric)
- **Bayport Water & Sewer** treatment
- **Fuel Storage Tanks** (6)
- **Liberty Lighthouse** (US Coast Guard)
- **Border Patrol and ICE Marine co-located with USCG**
- **Fire Stations 91, 92, Volunteer**
- **Bayport Schools** (Elementary, Middle, High)
- **Ferry Terminals** to Gish Island

**Reference map:** `z08_buffets_landing_bayport.png`

**Simulator implication:** Bayport scenarios trigger maritime / port security / hazmat complexities that involve USCG and potentially EPA (ESF-10) as lead federal agencies.

---

## Other named infrastructure (for scenario richness)

### Hospitals (state-wide — from `z10`)
Central City Hospital, Columbia Veterans Hospital, Faith Hospital, Levine Hospital, Harvest Junction Community Hospital, Kingston Regional Medical Facility, Bayport Clinic, Alder Hospital, Noble General Hospital, Roaring River Tribal Hospital, Pony Primary Care Clinic, St. Dorothy's Hospital, Capital City Hospital (in Pine County), Triangle Community Hospital, Elliot Community Hospital, Granite County General Hospital, Mineral County Hospital, Kane County Memorial Hospital, Crows Point Hospital, Tower Beach Community Hospital, Hyerstown Regional Hospital, Newday Hospital, Metropolis General Hospital, Grand County Hospital, Brooksville Regional Hospital, Franklin Community Hospital, Laye County Hospital, George County Hospital, Phillipboro Community Hospital.

### State-level coordination points
- **State Police Districts 1, 2, 3** (from `z20`) — District 2 covers Liberty + Kane + Green + Mineral
- **Columbia State Ports of Entry + Weigh Stations** (from `z13`) — for border/import scenarios
- **Columbia State Prison for Men (CSPM)** (from `z23`) — for civil unrest / escape scenarios

### County-level LE
- **Liberty County Sheriff patrol sectors** — North, West, East, South, Satellite Station (from `z21`)
- **Central City Police Areas** — 1 (NW), 2 (NE), 3 (SE), 4 (SW) (from `z22`)

### Detention facilities
- **Columbia State Prison for Men (CSPM)** — `z23` diagram
- **Liberty County Jail** — floor diagrams `z24` (1st floor), `z25` (2nd/3rd floors)

### Liberty County Library System (potential shelter sites)
Main library Central City + branches in Kingston, Jasper, Fisherville, Deep River, Blue Water, Gold Mine, Harvest Junction, Apple Valley, Bayport (9 total including main). `z27`.

### Liberty County Fairgrounds (potential Base site)
Large facility with Event Center, Multi-Purpose Exhibit Halls, Butler & Fleming Livestock Barns, Outdoor Arena, Horse Stalls, Indoor Arena, Horse Race Track, Grandstand, Midway Area, RV Parking, multiple parking lots. `z09`. **In multi-day flood or disaster scenarios this is the natural Base location.**

---

## Geographic disaster risk profile

From the Central City Flood Scenario (AAM-166) + the Storm Surge map (`z14`):

| Hazard | Affected area | Notes |
|---|---|---|
| **Freshwater flooding** | Central City, Liberty County | Roaring River, East Lake River, Swatera Creek, Turtle River. Historical 1997 flood: 28 dead, 656 injured, 75,000 evacuated |
| **Dam failure** | East Lake Dam → all four rivers downstream | Catastrophic; compounds with rain |
| **Hurricane storm surge** | Southern coast of state, hitting Liberty/Green/Stramford counties — specifically the beach/marsh belt from Tower Beach through Bayport to Zurich | Yellow hazard zone on `z14` |
| **Wildland fire** | Van Deusen Park/Campground, Mineral Mountains, rural counties | |
| **Hazmat** | Bayport refinery, LNG terminal, I-102/I-107 corridor | Triggers USCG/EPA Unified Command |
| **Civil unrest** | Columbia State Prison for Men, Liberty County Jail, Central City downtown | |
| **Mass casualty** | Liberty International Airport (Kingston), university campuses, cruise port (Bayport) | |

---

## How Claude Code should use this file

1. **Before creating any new scenario**, pick a city + county combination from this reference. Never invent place names.
2. **Before populating the `resources` catalog** with "departments," use the FEMA-listed agencies (Central City Police Department, Liberty County Sheriff, etc.). Real-sounding but fictional is the goal — all from this document.
3. **For scenario maps**, the PNGs are in `supabase/storage-seed/scenario-maps/`. Upload them to the `scenario-maps` storage bucket with matching filenames. The `scenarios.map_url` column should hold the full Supabase storage URL.
4. **For the `city` column** in `scenarios` table, use canonical values: `CENTRAL_CITY`, `CAPITAL_CITY`, `BAYPORT`, `HARVEST_JUNCTION`, or the county-scale `LIBERTY_COUNTY` for multi-city scenarios.
5. **Tribal involvement** — scenarios touching the RRTC footprint set `involves_tribal = true` so the role-select board opens the tribal IC slot.
