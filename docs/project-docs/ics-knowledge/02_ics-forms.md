# ICS Forms

**Source:** FEMA ICS forms catalog + ICS 300/400 course handouts. These are the standard forms that flow through an incident. The simulator's form system must match these exactly — field names, signature blocks, and who can sign are all operationally meaningful.

---

## Form List (v1 coverage priority)

| Form | Name | Priority | Owner | Required Signatures |
|---|---|---|---|---|
| **ICS-201** | Incident Briefing | **P1** | Initial IC | IC |
| **ICS-202** | Incident Objectives | **P1** | Planning Section Chief | IC |
| **ICS-203** | Organization Assignment List | **P1** | Resources Unit (Planning) | PSC |
| **ICS-204** | Assignment List | **P1** | Resources Unit (Planning) | OSC, PSC |
| ICS-205 | Incident Radio Communications Plan | P2 | COML (Comms Unit Leader) | PSC |
| ICS-205A | Communications List | P2 | COML | — |
| ICS-206 | Medical Plan | P2 | MEDL (Medical Unit Leader) | MEDL, SOFR |
| ICS-207 | Incident Organization Chart | P2 | RESL (Resources Unit Leader) | — |
| ICS-208 | Safety Message/Plan | P2 | SOFR | SOFR |
| ICS-209 | Incident Status Summary | P2 | SITL (Situation Unit Leader) | PSC |
| ICS-210 | Resource Status Change | P3 | RESL | — |
| ICS-211 | Incident Check-In List | P2 | RESL / Check-in Recorder | — |
| ICS-213 | General Message | P2 | anyone | — |
| ICS-214 | Activity Log | P1 | anyone with a role | (unit leader on review) |
| ICS-215 | Operational Planning Worksheet | P2 | OSC with PSC | OSC, PSC |
| ICS-215A | Incident Action Plan Safety Analysis | P2 | SOFR | SOFR |
| ICS-218 | Support Vehicle/Equipment Inventory | P3 | GSUL (Ground Support) | — |
| ICS-219 | Resource Status Card (T-Card) | P3 | RESL | — |
| ICS-220 | Air Operations Summary | P3 | AOBD | OSC |
| ICS-221 | Demobilization Check-Out | P3 | DMOB | Unit Leader, DMOB, LSC |
| ICS-225 | Incident Personnel Performance Rating | P3 | Supervisor | Supervisor, Section Chief |

**P1** = Phase 1 MVP coverage (ship with one form: ICS-201; ICS-214 auto-generated from events). **P2** = Phase 2 (IAP-critical forms). **P3** = Later.

---

## The IAP Package

The **Incident Action Plan** is a bundle, not a single document. A complete IAP for one operational period usually contains:

- **ICS-202** Incident Objectives (IC signs)
- **ICS-203** Organization Assignment List
- **ICS-204** Assignment Lists (one per Division/Group)
- **ICS-205** Communications Plan
- **ICS-206** Medical Plan
- **ICS-208** Safety Message
- A map of the incident area
- Weather forecast, traffic plan, demobilization plan (as appropriate)

**Simulator implication (Phase 2):** The IAP auto-builder assembles these as students complete them. An IAP is "ready" when every required component is submitted and signed. The operational period cannot advance without a signed IAP.

---

## The Planning "P" / Operational Period Planning Cycle

This is the cadence the forms live inside. One operational period worth of planning:

```
Incident/Event                       Executing the Plan &
   ↓                                 Assessing Progress
Initial Response                           ↑
   ↓                                       │
Incident Briefing ICS-201  →  Tactics Meeting (ICS-215)
   ↓                              ↑                ↓
IC/UC Develop/Update           Prep Plan      Planning Meeting
Objectives Meeting  →  Command & General    (Select strategies/
(ICS-202)              Staff Meeting          tactics)
                                              ↓
                                        IAP Prep & Approval
                                              ↓
                                      Operational Period
                                          Briefing
                                              ↓
                                       (back to top)
```

**Simulator implication:** The timeline of forms across an operational period drives the student's task list. At the start of Period 1, the ICS-201 prompt appears. Once signed, ICS-202 unlocks. Completed ICS-202 unlocks ICS-203 + ICS-204 for Planning. And so on.

---

## Per-Form Field Schemas

**Authoritative field lists live in `lib/ics/forms/*.ts` as zod schemas.** This doc summarizes the *shape* for orientation. Implement each form against the actual FEMA PDF when building.

### ICS-201 — Incident Briefing (P1)

Used by the initial IC to brief the incoming IC and to record early incident details. Becomes part of the permanent record.

**Top-level blocks:**
1. Incident Name + Incident Number + Date/Time prepared + Operational Period
2. Map sketch (free-form notes in v1; drawable map in Phase 2+)
3. Current Situation Summary + Health/Safety Briefing
4. Current and Planned Objectives
5. Current and Planned Actions, Strategies, Tactics
6. Current Organization (mini org chart)
7. Resource Summary (requested, on scene, ETA, notes)

**Sign:** Prepared by (IC or initial IC) — name, position, signature, date/time.

### ICS-202 — Incident Objectives (P1)

**Blocks:**
1. Incident Name + Operational Period (from / to)
2. Objectives for the operational period (numbered list, SMART-validated)
3. Operational Period Command Emphasis (safety message, general situational awareness)
4. General Situational Awareness
5. Site Safety Plan required? Y/N → location if yes
6. Incident Action Plan attachments checklist
7. Approved by IC (sig block) + Date/Time

### ICS-203 — Organization Assignment List (P1)

**Blocks:**
1. Incident Name + Operational Period
2. Incident Commander(s) and Command Staff (names)
3. Agency/Jurisdiction representatives
4. Planning Section personnel
5. Logistics Section personnel
6. Operations Section personnel
7. Finance/Admin Section personnel
8. Prepared by (Resources Unit Leader) + Date/Time

### ICS-204 — Assignment List (P1)

One per Division/Group per operational period. This is what frontline teams actually carry.

**Blocks:**
1. Incident Name + Operational Period
2. Branch / Division or Group
3. Operations personnel (Branch Director, Div/Grp Supv, and contact info)
4. Resources assigned (list with leader name, # of persons, contact, reporting location, special equipment, notes)
5. Work Assignments
6. Special Instructions
7. Communications (per-frequency plan)
8. Prepared by (RESL) + Approved by (PSC) + Approved by (OSC)

### ICS-214 — Activity Log (P1, auto-generated)

Time-stamped log of activities for a position. In the sim, **auto-generated** from the `events` table filtered to the current user's actions per operational period. User can add free-text entries.

---

## Signature Gates (enforce in code)

A form cannot be submitted until:
1. All required fields per zod schema are present and valid
2. All required signatures are from users currently assigned to those role codes in this session
3. For signatures requiring hierarchy (e.g. OSC approves DIV_SUPV's 204), the signer must be above or equal to the role in the hierarchy defined in `lib/ics/roles.ts`

Signature object shape:
```typescript
type Signature = {
  roleCode: string       // e.g. "OSC"
  userId: string         // who actually signed
  displayName: string    // snapshot at sign time
  signedAt: string       // ISO 8601
}
```

---

## Form Lifecycle States

`draft → submitted → approved → rejected (back to draft) → archived`

- **draft**: owner is filling, not visible to others
- **submitted**: sent to approver(s); visible per RLS to the required-signature roles
- **approved**: all signatures collected; locked from edits; visible per section RLS rules
- **rejected**: approver pushed back with reason; owner can edit and re-submit
- **archived**: operational period closed; read-only

---

## Visibility Rules (RLS summary)

Per the user's core requirement — sections cannot see each other's forms:

| Form | Visible To |
|---|---|
| ICS-201 | IC, Command Staff, all Section Chiefs |
| ICS-202 | Everyone in session (it IS the objectives) |
| ICS-203 | Everyone in session |
| ICS-204 | The specific Division/Group, their supervisor chain up to OSC, PSC, IC, Safety |
| ICS-205/205A | Everyone (comms plan is universal) |
| ICS-206 | Medical Unit, Safety, all Section Chiefs, IC |
| ICS-208 | Everyone in session |
| ICS-209 | IC, Command Staff, Planning, EOC/MAC (off-incident) |
| ICS-214 | The owner, their supervisor chain, Documentation Unit, Planning Section Chief, IC |
| ICS-215 | Operations + Planning chain, IC |
| ICS-215A | Safety + Operations chain, IC |

**Finance forms** (time sheets, procurement, comp/claims, cost tracking) — visible within Finance section only; IC and Command see summaries, not line items.
