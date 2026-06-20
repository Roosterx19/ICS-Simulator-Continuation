# NIMS Doctrine 2017 — Consolidated Reference

**Sources actually used:**
- *ICS 400 Advanced ICS for Complex Incidents* (April 2019) — Unit 2 "Fundamentals Review for Command and General Staff" is a full NIMS 2017 doctrine review and is the authoritative source we have.
- *0305 Type 3 All-Hazards IMT* (Pts 7, 11, 12) — NIMS glossary + coordination detail.

**Status:** The standalone *NIMS Doctrine 2017* PDF is **not in project knowledge at this time.** The content below is extracted from the ICS 400 deck, which explicitly references and teaches NIMS 2017 doctrine. If the standalone PDF is uploaded later, cross-check and update.

---

## The Three NIMS Components

NIMS is organized into three components. The simulator must model all three.

1. **Resource Management** — identifying, categorizing, ordering, dispatching, tracking, recovering, and demobilizing resources
2. **Command and Coordination** — includes **four NIMS Functional Groups:**
   - Incident Command System (ICS)
   - Emergency Operations Centers (EOCs)
   - Multiagency Coordination (MAC) Groups
   - Joint Information Systems (JIS)
3. **Communications and Information Management** — interoperability, reliability, scalability, portability, resilience, redundancy

**Sim implication:** every scenario touches at least the ICS functional group. Complex scenarios activate EOC, MAC Group, and JIC (our "invisible board"). Resource Management drives the Phase 2 resource catalog + budget. Communications drives the Phase 3 tablet chat system.

---

## Guiding Principles (NIMS 2017)

Three overarching principles that everything else rests on:

- **Flexibility** — NIMS components are adaptable to any incident, event, or capability; the system scales to need rather than forcing need to fit the system.
- **Standardization** — common terminology, common organizational structures, common processes. Enables interoperability across jurisdictions.
- **Unity of Effort** — coordination through cooperation and common interests; does **not** interfere with federal/agency statutory authority. **Distinct from Unity of Command** (see below).

---

## The 14 NIMS Management Characteristics

ICS 400 Unit 2 (SM-35 through SM-39) lists these as the foundation of incident command and coordination under NIMS. Memorize the groupings:

### Standardization
1. **Common Terminology** — organizational functions, resource descriptions, incident facilities all use standard names. No "Branch Chief vs. Branch Manager" confusion across jurisdictions.

### Command
2. **Modular Organization** — structure develops top-down from a baseline IC; grows only as complexity demands. Responsibility for any function defaults to the next-higher supervisor until explicitly delegated.
3. **Management by Objectives** — IC/UC sets specific, measurable objectives → strategies/tactics/tasks → assignments and protocols → documented results → next period's objectives.
4. **Incident Action Planning** — every incident has an action plan (not always written); complex or multi-period incidents require written IAP.
5. **Manageable Span of Control** — 1:3 to 1:7 direct reports, 1:5 optimal. Exceeded → supervisor must organize a new layer.
6. **Incident Facilities and Locations** — ICP, Base, Camp, Staging, Helispot/Helibase, etc. (see `04_facilities-and-locations.md`).
7. **Comprehensive Resource Management** — standardized categorization (Kind/Type), ordering, tracking, and recovery of all resources.
8. **Integrated Communications** — plan-driven, interoperable, situational-awareness-enabling.

### Professionalism
9. **Establishment and Transfer of Command** — command is explicitly established, clearly transferred; never ambiguous.
10. **Unified Command** — multiple agencies with jurisdiction work through a single ICP with shared objectives.
11. **Chain of Command and Unity of Command** — orderly line of authority; every individual reports to exactly one supervisor.
12. **Accountability** — check-in/check-out, personal responsibility, span of control adherence, resource tracking.
13. **Dispatch/Deployment** — only requested/dispatched resources go; no spontaneous deployment.
14. **Information and Intelligence Management** — EEIs (Essential Elements of Information), gather → analyze → share. In NIMS, "intelligence" specifically means threat-related info from law enforcement, medical surveillance, or other investigative orgs.

**Simulator implications — each characteristic maps to a sim feature:**

| Characteristic | Sim Feature |
|---|---|
| Common Terminology | Role codes + form field names locked to FEMA terms |
| Modular Organization | Role-select board enables parent roles first; children unlock after |
| Management by Objectives | ICS-202 workflow, SMART validator |
| Incident Action Planning | IAP auto-builder (Phase 2) |
| Manageable Span of Control | 1:5 soft warning, 1:7 hard warning on org chart |
| Incident Facilities and Locations | Spawn locations + map markers |
| Comprehensive Resource Management | Resource catalog + allocations table (Phase 2) |
| Integrated Communications | Tablet chat + comms plan (Phase 3) |
| Establishment and Transfer of Command | Transfer-of-command modal with 5-step flow |
| Unified Command | UC option on scenario setup — multiple IC participants share ICS-202 |
| Chain of Command / Unity of Command | Messages route through hierarchy; tooltips clarify the distinction |
| Accountability | check-in/check-out on every location change; `events` audit log |
| Dispatch/Deployment | Only Finance/Logistics-approved resources appear in Staging |
| Information & Intelligence Management | Intel/Investigations section (ISC role) with scoped visibility |

---

## Command vs. Coordination (NIMS 2017 distinction)

- **Command** — "the act of directing, ordering, or controlling by virtue of explicit statutory, regulatory, or delegated authority."
- **Coordination** — "the exchange of information systematically among principals who have or may have a need to know certain information to carry out specific incident management responsibilities."

An organization can have **command and control over its own resources and policies** without being **in command of the incident scene**. Example: technical specialists from a state or federal agency arrive on-scene; they retain command of their own people but operate under the direction of the on-scene IC.

---

## Unity of Command vs. Unified Command vs. Unity of Effort

This is the triplet students most frequently confuse. ICS 400 Unit 5 explicitly addresses it.

| Term | Definition | Remember by |
|---|---|---|
| **Unity of Command** | *Principle.* Every individual reports to exactly ONE supervisor. | "I have one boss." |
| **Unified Command** | *ICS application.* Multiple agencies with incident jurisdiction share one set of objectives through one ICP. Can exist at Area Command or Incident Command level. | "We have multiple ICs with one shared set of objectives." |
| **Unity of Effort** | *Guiding principle.* Coordination through cooperation across agencies, without overriding statutory authority. | "We cooperate but keep our own hats." |

**Sim implication:** the onboarding tour and the role-selection screen must explain this triplet with both a tooltip and an interactive example. The user flagged this as a top-3 student confusion.

---

## Transfer of Command — 5 Steps

From ICS 400 Unit 2 (SM-39 to SM-40). The simulator enforces these steps as gated actions in the transfer-of-command modal.

1. **Incoming IC performs situation assessment** with the existing IC (face-to-face when possible).
2. **Incoming IC is briefed** by the current IC, face-to-face if possible. Briefing covers:
   - Incident history
   - Priorities and objectives
   - Current plan
   - Resource assignments
   - Incident organization
   - Resources ordered/needed
   - Facilities established
   - Status of communications
   - Constraints/limitations
   - Incident potential
   - Delegation of authority
3. **Agree on appropriate transfer time.**
4. **Notify** of the command change:
   - Agency headquarters (through dispatch)
   - General Staff members (if designated)
   - Command Staff members (if designated)
   - All incident personnel
5. **Reassign the outgoing IC** to another position on the incident when appropriate. Benefits: retains first-hand incident knowledge, gives outgoing IC learning opportunity.

The **ICS-201** is designed to support Step 2 — a completed 201 functions as the briefing artifact.

---

## Modular Organization — key points

- Starts from Incident Commander as baseline (all five functions default to IC).
- Expands only as complexity demands.
- Responsibility for any function **defaults to the next-higher supervisor** until explicitly delegated. Example: if there's no Logistics Section Chief yet, the IC owns Logistics.
- The **flexibility does not supersede common terminology** — you can scale the chart, but position titles remain FEMA-standard.

**Position Titles (standard)** — enforce these in DB `ics_roles.tier` field:

| Organizational Element | Leadership Title | Support Title |
|---|---|---|
| Incident Command | Incident Commander | Deputy |
| Command Staff | Officer | Assistant |
| Section | Chief | Deputy / Assistant |
| Branch | Director | Deputy |
| Division / Group | Supervisor | (none) |
| Unit | Unit Leader | Manager, Coordinator |
| Strike Team / Task Force | Leader | Single Resource Boss |
| Single Resource | Boss / Leader | (none) |
| Technical Specialist | Specialist | (none) |

---

## Planning "P" Recap

The Planning "P" (see `03_iap-planning-cycle.md` for the full diagram) is the NIMS-standard rhythm of one operational period. NIMS 2017 confirms:

- **Leg of the P** (initial response): Notifications → Initial Response/Assessment → Agency Administrator Briefing → Incident Briefing (ICS-201) → Initial/Unified Command Meeting
- **Top of the P** (operational period cycle): Develop/Update Objectives → Strategy/C&GS Meeting → Prep Tactics Meeting → Tactics Meeting → Prep Planning Meeting → Planning Meeting → IAP Prep & Approval → Operations Briefing → Execute & Assess → (cycle repeats)

---

## Incident Complexity and Types (NIMS 2017 definitions)

NIMS 2017 separates three closely related but distinct concepts. ICS 400 Unit 2 is explicit:

- **Incident Complexity** — the level of difficulty, severity, or overall resistance faced by incident management. Assessed on a five-point scale: **Type 5 (least) → Type 1 (most)**.
- **Complex Incidents** — incidents of high complexity (typically Type 1 or 2) extending into multiple operational periods with multi-jurisdictional/multi-disciplinary effort.
- **Incident Complex** — "two or more individual incidents located in the same general area and assigned to a single Incident Commander or Unified Command." A management construct, not a complexity rating.

**Factors considered in complexity analysis:**
- Impacts to life, property, and economy
- Community and responder safety
- Potential hazardous materials
- Weather and other environmental influences
- Likelihood of cascading events
- Potential crime scene (including terrorism)
- Political sensitivity, external influences, media relations
- Area involved, jurisdictional boundaries
- Availability of resources

**Sim implication:** scenario metadata includes `complexity_type` (1–5). Display it on the scenario card and gate prerequisite courses (e.g., Type 1 scenarios require ICS-400 enrollment).

---

## Gaps — NIMS 2017 content we do NOT have from sourced material

These areas of NIMS 2017 are referenced but not fully detailed in the materials we actually have access to. Flag and re-check when the standalone PDF arrives:

- Full prevention/mitigation/preparedness/response/recovery (PMRR) cycle details
- NIMS training requirements per position beyond the prerequisite list shown in ICS 400 Unit 1 (IS-100, IS-200, ICS-300, IS-700, IS-800)
- Specific resource typing definitions beyond the reference to **https://rtlt.preptoolkit.fema.gov/Public**
- Full specification of the National Qualification System (see `07_nqs-qualifications-PENDING.md`)
- Complete specification of the National Resource Management framework

---

## Course Prerequisites (ICS 400 Unit 1)

For the sim's "learning mode" unlocks, this is the real FEMA prerequisite chain:

- **ICS 400 prerequisites** (must have all before enrolling):
  - IS-0100.c — An Introduction to the Incident Command System
  - IS-0200.c — Basic ICS for Initial Response
  - E/L/G 0300 — Intermediate ICS for Expanding Incidents (ICS 300)
  - IS-0700.b — An Introduction to the National Incident Management System
  - IS-0800 — National Response Framework (NRF)
- **Recommended:** E/L/G 0191 — EOC/ICS Interface

**Completion criteria for ICS 400:** 75% or higher on closed-book final exam, active participation in unit activities, end-of-course evaluation submitted.

**Sim implication:** a student's profile tracks completed prerequisite courses. Role-access in Phase 4+ is gated by these. Before then, treat every role as unlocked for practice.
