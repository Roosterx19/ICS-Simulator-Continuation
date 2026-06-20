# Legal Framework & Federal Doctrine

**Source:** FEMA ICS 400 Unit 5 (Interconnectivity of NIMS Command and Coordination Structures) + 0305 Type 3 IMT references.

Most of this lives *above* the in-simulator action — but it determines *why* the IC can or cannot request certain resources, *who* declares what, and *how* federal support plugs into a training scenario. The sim uses this to make scenarios legally coherent.

---

## HSPD-5 — Homeland Security Presidential Directive 5

**What it is:** The 2003 presidential directive that mandates NIMS and the NRF for all federal departments and agencies, and requires state, local, tribal, territorial, and private-sector adoption as a condition of federal preparedness funding.

**Why it matters to the sim:** Every ICS form, role code, and facility name in this simulator is standardized *because* HSPD-5 requires it. If the sim ever makes up terminology, it breaks HSPD-5 alignment — which is exactly what we promised the instructor persona (Dana) we would not do.

---

## Stafford Act (Robert T. Stafford Disaster Relief and Emergency Assistance Act, 42 U.S.C. §5121)

**What it is:** The federal statute authorizing the President to declare **emergencies** or **major disasters** at the request of a governor (or tribal leader), triggering federal assistance administered by FEMA.

**Two declaration types:**
- **Emergency Declaration** — narrower, faster, caps on federal funding; used for imminent or short-duration events
- **Major Disaster Declaration** — broader, unlocks full range of FEMA programs; used for large-scale natural disasters

**Key point from ICS 400:**
> *"The Federal Government provides assistance when the President declares an emergency or major disaster under the Robert T. Stafford Disaster Relief and Emergency Assistance Act (Stafford Act)."*

**Simulator implication:** Scenarios above Type 2 complexity should include a "Stafford Declaration pending / issued / denied" state that unlocks or restricts federal resources. Teaches students that federal assets aren't just "there for the asking."

---

## Stafford vs. Non-Stafford Incidents

Not every incident requiring federal coordination is a Stafford event. Examples of non-Stafford federal coordination:
- **Oil and hazmat spills on navigable waters** — governed by the **National Contingency Plan** under **CERCLA** / **Clean Water Act**; EPA or USCG is the lead federal agency
- **Public health emergencies** — HHS leads under the **Public Health Service Act**
- **Terrorism** — DOJ/FBI lead for investigation
- **NSSE (National Special Security Events)** — Secretary of Homeland Security designates; USSS leads

Per ICS 400 Unit 5:
> *"Emergency Support Functions (ESFs) may be selectively activated for both Stafford Act and non-Stafford Act incidents. Not all incidents requiring Federal support result in the activation of ESFs."*

**Simulator implication:** Scenario types should be distinguishable — a Capital City hurricane scenario is Stafford-eligible; a Bayport / Columbia Bay oil spill scenario is non-Stafford (Clean Water Act / NCP; Bayport has a refinery, LNG terminal, and cruise/cargo ports per `10_state-of-columbia-geography.md`). Different activation patterns, different lead agencies.

---

## Lead Federal Agencies by Incident Type

From ICS 400 Unit 5 Visual 5.31:

| Incident Type | Lead Federal Agency |
|---|---|
| Major disaster / emergency (Stafford) | FEMA |
| Public health emergency | HHS |
| Major hazmat spill (inland) | EPA |
| Major hazmat spill (coastal/navigable waters) | USCG |
| Terrorism — law enforcement response & investigation | DOJ / FBI |
| Agricultural emergency / foreign animal disease | USDA |
| Radiological/nuclear | DOE (technical), DHS (coordination), DOD (assets) |
| Transportation incident | DOT; NTSB for investigation |
| NSSE | DHS / USSS |

**Simulator implication:** In the invisible-board logic, the lead federal agency for a given scenario determines which federal representatives appear in the MAC Group / EOC linkages. Drop-down of "lead agency" per scenario populates the off-incident coordination tree.

---

## Presidential Policy Directive 8 (PPD-8) / National Preparedness System

**What it is:** 2011 presidential policy directive establishing the **National Preparedness System**, which:
- Defines **five mission areas**: Prevention, Protection, Mitigation, Response, Recovery
- Directs FEMA to publish the **National Preparedness Goal (NPG)** and the supporting **National Planning Frameworks**
- Establishes **core capabilities** as the functional units of preparedness

**Note on sourcing:** The full PPD-8 / NPG content is a separate FEMA document not present in the ICS 400 / 0305 materials in the project. The content below is extracted from what IS present plus the Core Capabilities referenced in each ESF definition. If a definitive NPG reference is needed, upload the "National Preparedness Goal" PDF (latest edition is 2015, 2nd edition) and extend this file.

### The Five Mission Areas (PPD-8)

1. **Prevention** — avoid, prevent, or stop an imminent, threatened, or actual act of terrorism
2. **Protection** — safeguard against acts of terrorism and natural disasters
3. **Mitigation** — reduce loss of life and property by lessening impact
4. **Response** — save lives, protect property and the environment, meet basic human needs
5. **Recovery** — restore, strengthen, and revitalize infrastructure, housing, economy, health, and the environment

### National Planning Frameworks (one per mission area)

- **National Prevention Framework**
- **National Protection Framework**
- **National Mitigation Framework**
- **National Response Framework (NRF)** ← most relevant to the sim
- **National Disaster Recovery Framework (NDRF)** ← relevant for recovery-phase scenarios

### Core Capabilities (32 total across mission areas)

Each ESF and RSF maps to specific **Core Capabilities** (the exact names appear in `08_esf-rsf-reference.md`). Examples:
- Planning
- Public Information and Warning
- Operational Coordination
- Situational Assessment
- Mass Search and Rescue Operations
- Critical Transportation
- Logistics and Supply Chain Management
- Mass Care Services
- Public Health, Healthcare, and Emergency Medical Services
- Fatality Management Services
- Infrastructure Systems
- On-Scene Security, Protection, and Law Enforcement
- Environmental Response/Health and Safety
- Fire Management and Suppression
- Operational Communications

**Simulator implication:** When a scenario activates an ESF, it should surface the associated Core Capabilities in the Planning Section's resource planning view. Reinforces that ESFs deliver *capabilities*, not just agencies.

---

## National Response Framework (NRF)

From ICS 400 Unit 5 Visual 5.29:

> *"The National Response Framework (NRF):*
> *- Presents an overview of key response principles, roles, and structures that guide the national response.*
> *- Describes how communities, States, the Federal Government, and private-sector and nongovernmental partnerships apply these principles for a coordinated, effective national response.*
> *- Identifies the special circumstances where the Federal Government exercises a larger role, including incidents where Federal interests are involved and catastrophic incidents where a State would require significant support."*

### NRF Guiding Principles

1. **Engaged Partnership** — whole-community approach
2. **Tiered Response** — incidents managed at the lowest possible jurisdictional level
3. **Scalable, Flexible, Adaptable Operational Capabilities**
4. **Unity of Effort Through Unified Command**
5. **Readiness to Act**

### "Catastrophic Incident" (NRF definition)

> *"Any natural or manmade incident, including terrorism, that results in extraordinary levels of mass casualties, damage, or disruption severely affecting the population, infrastructure, environment, economy, national morale, and/or government functions."*

Triggers massive federal coordination including the **NRCC** (National Response Coordination Center), **RRCC** (Regional Response Coordination Center), and **JFO** (Joint Field Office).

---

## Federal Coordination Structures (the "off-incident" bodies)

These map to the simulator's "invisible board" — they are present in the scenario's world but not physically placed in the classroom canvas. The IC and Command Staff communicate with them via messages.

### National Operations Center (NOC)
Primary national-level hub for situational awareness, information fusion, and executive communications. 24/7 operation at DHS. Think: "the dashboard the Secretary of Homeland Security looks at."

### National Response Coordination Center (NRCC)
Multiagency EOC that coordinates overall Federal support for major incidents and emergencies at the national level. FEMA-operated. Activities:
- Monitor potential/developing incidents
- Support regional and field components
- Initiate mission assignments or reimbursable agreements
- Activate and deploy national-level specialized teams
- Resolve Federal resource support conflicts

### Regional Response Coordination Center (RRCC)
Standing facility at each of FEMA's 10 regions. Activated by the FEMA Regional Administrator based on level of response required. Activities:
- Establishes initial Federal objectives
- Provides Federal support to affected states
- Deploys teams to establish the JFO

### Joint Field Office (JFO)
Temporary facility providing a central location for coordination of Federal, State, tribal, and local governments and private-sector businesses and NGOs with primary responsibility for response and short-term recovery. Led by the **JFO Unified Coordination Group**.

**Typically one JFO per disaster declaration.**

### Joint Information Center (JIC)
Facility (or virtual structure) where public information officials from all participating agencies co-locate or coordinate. Central point of contact for media. Supports the **Joint Information System (JIS)**.

### MAC Group (Multiagency Coordination Group)
Group of agency administrators or executives (or their appointed representatives) authorized to commit agency resources and funds. **Policy-level, not operational.** Decides inter-incident resource priorities when resources are contested.

**Simulator implication:** When a scenario escalates past a threshold (e.g. over-budget with multiple ESFs activated), a MAC Group and JFO activation prompt can appear. Student IC learns to request federal support through these channels, not by going around them.

---

## Mutual Aid and Assistance Agreements

From ICS 400:

> *"Complex Incidents will frequently require assistance from outside the State. Mutual aid and assistance agreements provide a mechanism to quickly obtain emergency assistance in the form of personnel, equipment, materials, and other associated services."*

**Types:**
- **Automatic Mutual Aid** — pre-configured, no request needed (common between neighboring fire departments)
- **Local Mutual Aid** — between adjoining jurisdictions, activated on request
- **Regional Mutual Aid** — larger region, often state-level coordination
- **Statewide / Intrastate Mutual Aid** — under state emergency management statute
- **Interstate Mutual Aid** — often through **EMAC (Emergency Management Assistance Compact)**, a congressionally ratified interstate compact

**Simulator implication:** Resource requests in the sim should include a "source" field — direct purchase, mutual aid, state, federal (Stafford or ESF). Different sources have different lead times and cost models. Teaches procurement reality.

---

## Whole Community Approach

Per NRF and subsequent FEMA doctrine:

> *"Response to an incident is a shared responsibility of governments at all levels and also involves the whole community: individuals, households, the private sector, and nongovernmental organizations."*

**Simulator implication:** Scenarios should include civilian/volunteer elements (the user asked for CERT integration explicitly). The Liaison Officer's agency-rep panel includes private-sector and NGO reps, not just government agencies.

---

## Administrative Law and Compliance (touched briefly in ICS 400)

Aspects that appear in scenarios but aren't taught in depth in the ICS track:
- **Posse Comitatus Act** — limits on military (federal) involvement in domestic law enforcement
- **Insurrection Act** — exceptions to Posse Comitatus
- **Robert T. Stafford Act** — already covered above
- **National Emergencies Act** — presidential emergency powers framework
- **Environmental compliance** — NEPA, Endangered Species Act, Historic Preservation Act affect recovery actions (see Natural and Cultural Resources RSF)

**Simulator implication:** Advanced scenarios (Phase 4+) may include a "compliance check" interaction where Planning / Legal advises the IC of statutory constraints. Out of scope for Phase 1 MVP.

---

## Scenario-Side Lookup Table (for Claude Code when building scenarios)

| Scenario Type | Typical Legal Framework | Lead Federal Agency | Typical Activations |
|---|---|---|---|
| Major hurricane | Stafford (major disaster) | FEMA | NRCC, RRCC, JFO, most ESFs, NDRF for recovery |
| Wildland fire (interface) | Stafford (FMAG) / FIRESCOPE | FEMA / USFS | RRCC, ESF-4, state mutual aid |
| Inland hazmat spill | Clean Water Act / CERCLA | EPA | ESF-10, ESF-8, state/local |
| Navigable-water oil spill | OPA-90 / NCP | USCG | ESF-10, USCG District, UC with industry |
| Terrorism (active) | WMD / Stafford if declared | DOJ/FBI (LE), FEMA (coordination) | ESF-13, JIC, MAC |
| Pandemic | Public Health Service Act / Stafford if declared | HHS / CDC | ESF-8, multiple RSFs |
| Mass casualty (MCI) — local | State / local statutes | Local IC | Local mutual aid |

The sim's scenario table should denormalize this — each scenario row stores its framework, lead agency, and likely activations so the Planning Section students don't have to guess.
