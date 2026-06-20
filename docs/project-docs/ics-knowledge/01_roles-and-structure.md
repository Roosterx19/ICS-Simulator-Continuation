# ICS Roles and Structure

**Source:** FEMA ICS 400 (April 2019), 0305 Type 3 All-Hazards IMT, supplemented by ICS 300 material. Use this as the canonical reference when modeling roles in code. When in doubt, the PDF is authoritative — don't invent positions.

---

## The Five (Plus One) Functional Areas

Every incident, regardless of size, potentially involves these six functions. On small incidents, one person (the IC) may handle several. As complexity grows, each function becomes its own section with a chief.

1. **Command** — Incident Commander or Unified Command (overall direction)
2. **Operations** — Tactical work, the actual response
3. **Planning** — Information, resources, documentation, demobilization
4. **Logistics** — Support: facilities, supplies, comms, medical unit, food, ground support
5. **Finance / Administration** — Money: time, procurement, comp/claims, cost
6. **Intelligence / Investigations** (the "sixth function") — Used when the incident needs specialized intel or criminal investigation capability. Can sit as a Command Staff element, a branch under Operations, or a full section — depends on need.

---

## Command Staff vs. General Staff

This is one of the things students confuse most, per the user's notes. Be precise:

### Command Staff
Reports directly to the Incident Commander. Not in the org chart under a section. Three positions:

- **Safety Officer (SOFR)** — monitors operations for unsafe conditions and hazardous situations. Has authority to stop or modify any unsafe operation.
- **Public Information Officer (PIO)** — interface with media and public. Gathers and releases incident information.
- **Liaison Officer (LOFR)** — point of contact for assisting and cooperating agency representatives.

Each can have **Assistants** if the workload warrants.

### General Staff
The five section chiefs:

- **Operations Section Chief (OSC)**
- **Planning Section Chief (PSC)**
- **Logistics Section Chief (LSC)**
- **Finance/Administration Section Chief (FSC)**
- **Intelligence/Investigations Section Chief (ISC)** — when established as a section

Each section chief may have a **Deputy** with full qualifications to assume command of the section.

---

## Command Variants (the part students mix up)

- **Single Incident Command** — One IC. One set of objectives. Most incidents.
- **Unified Command** — Multiple ICs from different jurisdictions/agencies, working together under one set of shared objectives. Not a committee — roles are defined. Used when multiple agencies have statutory authority over the same incident (e.g. oil spill: USCG + EPA + state).
- **Area Command** — Oversight of multiple incidents each run by its own IC, or one very large incident divided into multiple incidents. Sets overall priorities and allocates critical resources between incidents. Does not run tactical operations.
  - Can also be **Unified Area Command** when multi-jurisdiction.
- **Unity of Command** — A NIMS *principle*, not a structure. Every person reports to exactly ONE supervisor. Does not conflict with Unified Command — Unified Command is about who's in charge at the top; Unity of Command is about every individual having a single reporting line below that.

**Memory aid for the simulator's onboarding tooltip:**
> *Unity of Command = "I have one boss."*
> *Unified Command = "We have multiple ICs who share one set of objectives."*
> *Area Command = "One authority coordinating multiple incidents."*

---

## Full Role Codes (seed these into `ics_roles` table)

Codes are stable identifiers used across the code, DB, and forms. Names match FEMA terminology.

### Command
| Code | Name | Tier | Reports To | Color Token |
|---|---|---|---|---|
| `IC` | Incident Commander | ic | (approving authority) | `role-ic` |
| `DEP_IC` | Deputy Incident Commander | ic | IC | `role-ic` |

### Command Staff
| Code | Name | Tier | Reports To | Color Token |
|---|---|---|---|---|
| `SOFR` | Safety Officer | command | IC | `role-command` |
| `ASST_SOFR` | Assistant Safety Officer | command | SOFR | `role-command` |
| `PIO` | Public Information Officer | command | IC | `role-command` |
| `ASST_PIO` | Assistant PIO | command | PIO | `role-command` |
| `LOFR` | Liaison Officer | command | IC | `role-command` |
| `ASST_LOFR` | Assistant Liaison Officer | command | LOFR | `role-command` |

### General Staff — Section Chiefs
| Code | Name | Tier | Section | Reports To | Color Token |
|---|---|---|---|---|---|
| `OSC` | Operations Section Chief | section | OPS | IC | `role-section` |
| `DEP_OSC` | Deputy Operations Section Chief | section | OPS | OSC | `role-section` |
| `PSC` | Planning Section Chief | section | PLAN | IC | `role-section` |
| `DEP_PSC` | Deputy Planning Section Chief | section | PLAN | PSC | `role-section` |
| `LSC` | Logistics Section Chief | section | LOG | IC | `role-section` |
| `DEP_LSC` | Deputy Logistics Section Chief | section | LOG | LSC | `role-section` |
| `FSC` | Finance/Administration Section Chief | section | FIN | IC | `role-section` |
| `DEP_FSC` | Deputy Finance Section Chief | section | FIN | FSC | `role-section` |
| `ISC` | Intelligence/Investigations Section Chief | section | II | IC | `role-section` |

### Operations Branch / Division / Group
| Code | Name | Tier | Section | Reports To | Color Token |
|---|---|---|---|---|---|
| `OPS_BRANCH_DIR` | Operations Branch Director | branch | OPS | OSC | `role-boss` |
| `DIV_SUPV` | Division Supervisor (geographic) | division | OPS | Branch Dir or OSC | `role-boss` |
| `GRP_SUPV` | Group Supervisor (functional) | division | OPS | Branch Dir or OSC | `role-boss` |
| `STRIKE_TEAM_LDR` | Strike Team Leader | leader | OPS | Div/Grp Supv | `role-boss` |
| `TASK_FORCE_LDR` | Task Force Leader | leader | OPS | Div/Grp Supv | `role-boss` |
| `SINGLE_RESOURCE` | Single Resource (Leader of one unit) | resource | OPS | Div/Grp/ST/TF Ldr | `role-staff` |
| `STAM` | Staging Area Manager | leader | OPS | OSC | `role-boss` |
| `AOBD` | Air Operations Branch Director | branch | OPS | OSC | `role-boss` |
| `ATGS` | Air Tactical Group Supervisor | division | OPS | AOBD | `role-boss` |
| `ASGS` | Air Support Group Supervisor | division | OPS | AOBD | `role-boss` |

### Planning Section Units
| Code | Name | Tier | Section | Reports To |
|---|---|---|---|---|
| `RESL` | Resources Unit Leader | unit | PLAN | PSC |
| `SITL` | Situation Unit Leader | unit | PLAN | PSC |
| `DOCL` | Documentation Unit Leader | unit | PLAN | PSC |
| `DMOB` | Demobilization Unit Leader | unit | PLAN | PSC |
| `THSP` | Technical Specialist | unit | PLAN (assigned where needed) | PSC |

### Logistics Section Units
| Code | Name | Tier | Section | Reports To |
|---|---|---|---|---|
| `SVBD` | Service Branch Director | branch | LOG | LSC |
| `SUBD` | Support Branch Director | branch | LOG | LSC |
| `COML` | Communications Unit Leader | unit | LOG | SVBD |
| `MEDL` | Medical Unit Leader | unit | LOG | SVBD |
| `FDUL` | Food Unit Leader | unit | LOG | SVBD |
| `SPUL` | Supply Unit Leader | unit | LOG | SUBD |
| `FACL` | Facilities Unit Leader | unit | LOG | SUBD |
| `GSUL` | Ground Support Unit Leader | unit | LOG | SUBD |

### Finance/Admin Section Units
| Code | Name | Tier | Section | Reports To |
|---|---|---|---|---|
| `TIME` | Time Unit Leader | unit | FIN | FSC |
| `PROC` | Procurement Unit Leader | unit | FIN | FSC |
| `COMP` | Compensation/Claims Unit Leader | unit | FIN | FSC |
| `COST` | Cost Unit Leader | unit | FIN | FSC |

### Agency Representatives (not in a section)
| Code | Name | Tier | Reports To | Color Token |
|---|---|---|---|---|
| `AREP` | Agency Representative | agency | LOFR | `role-agency-rep` |

### MAC Group / EOC / JIC (Off-incident; coordination only)
These are not IC roles. They exist *around* the incident.

| Code | Name | Notes |
|---|---|---|
| `MAC_CHAIR` | MAC Group Chair | Policy / resource allocation across incidents |
| `EOC_DIR` | EOC Director | Coordinates at emergency operations center level |
| `JIC_MGR` | JIC Manager | Joint Information Center — coordinates multi-agency public info |

Per user's requirements: these appear on the **invisible board** — their presence is tracked, they can receive messages from IC, but they're not physically placed in the simulator's classroom.

---

## Modular Expansion Rule

The core insight to teach via the simulator:

> *Every function exists on every incident. On small incidents one person handles many. As the incident grows, the IC delegates — and each delegation creates a new box on the org chart. Responsibility for any function defaults to the next-higher supervisor until it's explicitly delegated.*

Example progression:
1. Engine company arrives: **Engine Captain = IC** (also does Ops, Plans, Logs, Finance implicitly)
2. Incident grows: **IC establishes Operations Section Chief** (now IC handles Plans/Logs/Finance, OSC handles tactics)
3. Multi-day incident: **IC establishes all four sections** + Command Staff
4. Multi-incident event: **Area Command** established above multiple ICs

**Simulator implication:** the role-select board should show ALL roles, but with positions greyed/disabled when the parent role isn't assigned (can't pick Strike Team Leader if no Division Supervisor exists; can't pick Division Supervisor if no OSC).

---

## Span of Control

NIMS guideline: supervisors should manage **3 to 7** direct reports, with **5** being the sweet spot. Enforce as a warning (not hard block) in the sim — if a DivSupv has >7 resources assigned, display a span-of-control warning in the Planning dashboard.
