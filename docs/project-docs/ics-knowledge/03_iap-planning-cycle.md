# IAP Planning Cycle & Operational Periods

**Source:** FEMA ICS 400 Unit 2 (Incident Action Planning Process) + 0305 Type 3 IMT material.

This drives the **rhythm** of the simulator. Forms unlock, shifts change, and briefings fire based on the operational period clock.

---

## Operational Period

An **operational period** is a scheduled span of time (usually 12 or 24 hours; can be 8) during which a specific set of incident objectives is in effect. At the end of the period, the next IAP takes over.

- Common lengths: **12 hours** (day/night shift model) or **24 hours** (one period per day)
- **ICS 400 uses 24-hour periods** in the Area Command scenario
- **0305 Type 3 IMT** frequently uses 12-hour periods
- Simulator: default to 12h for training cadence (lets a 90-minute class experience 1–2 full cycles); instructor can override per scenario

---

## The Planning "P"

Named for its visual shape. One revolution = one operational period.

```
   Notification of Incident
           ↓
    Incident/Event Occurs
           ↓
      Initial Response
           ↓                  ┌──────────────────────────┐
    Agency Admin Briefing     │  Execute Plan & Assess  │
           ↓                  │       Progress          │
     Initial IC / UC          └────────────┬─────────────┘
           ↓                               │ (new period begins)
    Incident Briefing                      │
       (ICS-201)                           │
           ↓                               │
    IC / UC Develop or                     │
    Update Objectives ←────────────────────┘
           ↓
    Command & General
    Staff Meeting
           ↓
    Preparing for Tactics
    Meeting (work products:
    ICS-215 draft)
           ↓
    Tactics Meeting
    (OSC + PSC + Safety)
           ↓
    Preparing for Planning
    Meeting (ICS-215 final,
    ICS-215A safety analysis)
           ↓
    Planning Meeting
    (all Command + General)
           ↓
    IAP Prep & Approval
    (Plans writes; IC signs)
           ↓
    Operational Period
    Briefing (deliver IAP
    to Operations)
           ↓
    Begin Operational Period
    (New shift takes over)
           ↓
    (loop back to "Update Objectives")
```

**Each arrow is a form, a meeting, or both.** The simulator models these as sequenced unlocks.

---

## Meetings (chronological per period)

| Meeting | Attendees | Output | Sim Duration |
|---|---|---|---|
| **Incident Briefing** | Initial IC → Incoming IC | ICS-201 | 10 min |
| **Agency Admin Briefing** | IC + Agency Exec | Letter of Expectation (IC gets authority + constraints) | 5 min |
| **IC/UC Objectives Meeting** | IC (or UC members) | Draft objectives for next period | 10 min |
| **Command & General Staff Meeting** | IC + Command Staff + all Section Chiefs | Agreed objectives, strategies, constraints | 15 min |
| **Tactics Meeting** | OSC, PSC, SOFR, LSC (resource availability), COML | ICS-215 worksheet (tactics per division/group) | 20 min |
| **Planning Meeting** | Full command + general staff | Final IAP draft approved for writing | 15 min |
| **IAP Approval** | PSC presents, IC signs | Signed IAP | 5 min |
| **Operational Period Briefing** | IC → all operations personnel | IAP delivered | 15 min |

Total: ~95 minutes of meetings per cycle. Actual operational period is 12–24 hours; these meetings consume the first ~90 min of each cycle.

---

## Shift Changes & Transfer of Command

### Shift Change (routine)
At the end of each operational period, personnel hand off to their counterparts. Format: **brief + IAP walkthrough + ride-along on next op period if possible**.

Simulator: at T-30min to period end, the "incoming shift" students get a read-only preview of the current state. At period end, the swap executes: outgoing students lock out, incoming students take over their section positions.

### Transfer of Command (position change)
When the IC (or any section chief) transfers command to another person — same incident, new person in role. Must be done face-to-face when possible, and announced over comms. Form: no dedicated ICS form; typically documented in ICS-214 and announced on ICS-213.

**Required steps (simulator enforces):**
1. Outgoing IC briefs incoming IC on current situation, objectives, strategy
2. Incoming IC assumes responsibility explicitly
3. Announcement made to all command and general staff
4. Change reflected in ICS-203 (Organization Assignment List)

**Triggers for transfer:**
- Qualified replacement arrives (most common)
- IC fatigue / shift end
- Incident complexity increases (Type 4 → Type 3 → Type 2 → Type 1 requires more qualified ICs)
- Jurisdictional change

### Delegation of Authority / Letter of Expectation
When the agency executive formally hands control to the IC. Written document listing:
- Priorities
- Constraints
- Expectations
- Reporting requirements
- Political/legal context

Simulator: this appears as a modal when IC first assumes command. Student must read and acknowledge before proceeding.

---

## Time Tracking (Simulator Requirements)

Per user's requirements, **all time must be documented** and a **live clock** visible:

- **Wall clock** — real-world time (top of screen, always visible)
- **Incident clock** — time since incident start (scenario T+hh:mm)
- **Operational period clock** — time into current period (resets each period)
- **Next-milestone timer** — "Tactics Meeting in 0:14:22"

Every form submission, role assignment, resource allocation, and movement stamps an `events` row with both real and incident time. End-of-scenario debrief replays this timeline.

---

## Type-1 through Type-5 Incidents (complexity scale)

Lower number = more complex.

| Type | Scale | Example |
|---|---|---|
| **Type 5** | Small, 1-2 resources, 1 op period, no written IAP | Fender-bender, small fire |
| **Type 4** | Several resources, 1 op period, limited command | Small commercial fire |
| **Type 3** | Extended attack, multiple resources, written IAP, multi-day possible | Mid-size wildfire, multi-vehicle MCI |
| **Type 2** | Multi-agency, regional IMT, multi-op periods | Large wildfire, hurricane response region |
| **Type 1** | National IMT, multi-jurisdiction, sustained multi-week | Katrina, 9/11, major earthquake |

**Simulator scenario tiers:**
- Tutorial scenario: Type 4 (single op period, minimal forms)
- ICS 300 final: Type 3 (2 op periods, full IAP)
- ICS 400 final: Type 2 or 1 with Area Command (3+ op periods, multiple incidents)

---

## Advanced / Contingency Planning

Per ICS 400: for complex incidents, Planning should project **36–72 hours ahead**. This is distinct from the next-operational-period planning cycle. Outputs:
- Future resource needs
- Strategy alternatives
- Demobilization timeline
- Transition to recovery

Simulator Phase 2+: Planning Section gets a separate "Advanced Planning" tab where the PSC (or a Deputy) drafts forward-looking notes. Not required to progress the scenario, but affects the debrief score.
