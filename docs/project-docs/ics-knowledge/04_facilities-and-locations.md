# ICS Facilities & Locations

**Source:** FEMA ICS 300/400 + 0305 Type 3 IMT reference.

The user called out that students get confused about the difference between **Staging**, **Base**, **Camp**, **Incident Site**, and the **EOC**. This reference exists so the simulator maps each to a visually distinct location with a clearly labeled function. Get this wrong and the whole training value collapses.

---

## Facility Types

### Incident Command Post (ICP)
- **Function:** Where the IC (or UC) directs the incident. Command and General Staff work here.
- **Location:** Near, but safely outside, the active incident area.
- **Marker:** ICP flag (orange in standard ICS symbology; use `role-command` red in our UI)
- **In sim:** Fixed structure the IC's avatar occupies once they assume command. Has IC desk, Command Staff desks, and a big status board.

### Incident Base
- **Function:** Primary support location. **One** base per incident. Logistics, Finance, food services, sleeping quarters (for short stays), and equipment staging for long-term support are based here. Is NOT where tactical resources wait.
- **Location:** Within or adjacent to the incident area, but outside the hazardous zone.
- **Marker:** Base flag
- **In sim:** One large location containing Logistics, Finance, comms, supply, and administrative buildings. Logistics and Finance avatars are based here.

### Camp (aka Incident Camp)
- **Function:** Remote support location when the Base can't cover the geography. Provides sleeping, food, sanitation, medical, and minor equipment maintenance. **Multiple camps** allowed — one per geographic area that needs one.
- **Location:** Far from the Base; near an assigned division/group operating area.
- **Marker:** Camp flag
- **In sim:** Secondary support nodes. Phase 1 scenario doesn't require one. Phase 2+ complex scenarios (Area Command, multi-division wildland) use multiple camps.

### Staging Area
- **Function:** Where **tactical resources wait** — fresh, fed, fueled, and ready for immediate assignment. **Operations owns this** (managed by a Staging Area Manager). Resources in staging are "ready" and can deploy in 3 minutes or less.
- **Location:** Close to tactical operations but outside active hazard zone.
- **Marker:** S (Staging) symbol
- **In sim:** This is where students go **immediately after picking a role**. Their avatar spawns here until deployed to a section/division. Critical that this is visually distinct from Base.

### Incident Site
- **Function:** The actual area of the incident — where the work is happening (the fire, the collapsed building, the spill, the flooded neighborhood).
- **Location:** It's *the thing*. Can be a point, a perimeter, or a sprawling area.
- **Marker:** The map shape for the incident itself
- **In sim:** The scenario map. Divisions and Groups are assigned to sub-areas of this site.

### Helispot / Helibase
- **Function:** Helispot = temporary helicopter landing zone; Helibase = ongoing helicopter operations (fueling, maintenance, crew rest).
- **In sim:** Phase 3+ for aviation scenarios. Air Operations Branch uses these.

### Emergency Operations Center (EOC)
- **Function:** **NOT part of the incident command structure.** The EOC is the jurisdiction's (city/county/state) coordination center. It supports the incident from the outside — resource requests, public information coordination, multi-incident prioritization. Staffed by emergency management, not the IMT.
- **Relationship to IC:** The IC requests resources *through* the EOC (when resources beyond the incident's immediate authority are needed); the EOC coordinates with MAC Groups and mutual-aid partners.
- **In sim:** A separate, visually distinct building. EOC avatars aren't in the scenario classroom — they're off to the side on the map, connected to the IC via messaging.

### Multiagency Coordination (MAC) Group
- **Function:** Policy-level group that prioritizes across multiple incidents when resources are contested. Not a physical facility — a group of senior agency reps, can meet in person or by teleconference.
- **In sim:** The "invisible board" the user described. MAC members are listed as present but not placed physically. They receive escalations from the IC through the EOC.

### Joint Information Center (JIC)
- **Function:** Coordinates public information and media from multiple agencies in a unified voice. Works with each incident's PIO.
- **In sim:** Also on the invisible board. Connected to the PIO via messaging.

---

## Typical Spatial Layout (for scenario maps)

```
               ┌─────────────────┐
               │      EOC        │ (off-incident, reachable by message)
               └────────┬────────┘
                        │
   ─────────────────────┼─────────────────────
                        │
     ┌──────────────┐   │   ┌──────────────┐
     │ Incident     │   │   │   MAC / JIC  │
     │ Command Post │   │   │  (invisible) │
     └──┬───────────┘   │   └──────────────┘
        │               │
        │       ┌───────┴───────┐
        │       │ Incident Site │  (the event)
        │       │  (Divisions   │
        │       │   A, B, C)    │
        │       └───────┬───────┘
        │               │
     ┌──┴──────┐   ┌────┴────┐
     │ Staging │   │  Camp 1 │ (if needed)
     └─────────┘   └─────────┘
          │
     ┌────┴──────┐
     │  Base     │
     │ (Log/Fin) │
     └───────────┘
```

Every ICS 400 scenario map in the course materials follows a variant of this layout. The simulator should reuse the exact coordinates and labels from each course's map when recreating a scenario.

---

## The Distinctions Students Miss (simulator must highlight)

The user named these specifically as common confusions:

1. **Staging ≠ Base.** Staging holds *ready tactical resources* (Operations). Base holds *support* (Logistics, Finance, sleeping, admin). A student who drives fresh resources into Base instead of Staging is making an operationally real mistake. Simulator should flag it.

2. **Base ≠ Camp.** One Base per incident. Multiple Camps allowed. Camps support areas the Base can't reach practically.

3. **ICP ≠ EOC.** ICP is *on* the incident, runs the incident. EOC is *off* the incident, coordinates the jurisdiction. IC is at ICP. Emergency Manager / Mayor / County Exec is at EOC.

4. **EOC ≠ MAC Group.** EOC is operational coordination. MAC Group is policy / resource prioritization across multiple incidents. EOC staff run plays; MAC Group picks the playbook.

5. **JIC ≠ PIO.** The PIO sits with the IC on-scene (Command Staff). The JIC is an off-scene coordinating body that unifies messaging from multiple PIOs.

---

## Simulator Rules

- **Every role has a "home" facility.** Spawn there on role-select.
  - Staging Area Manager → Staging
  - Logistics / Finance personnel → Base
  - IC / Command Staff → ICP
  - Operations (active) → Divisions on the incident site
  - Planning → ICP or Base (scenario-dependent)
  - EOC Director / MAC / JIC → off-incident, stationary
- **Move events are time-stamped.** Walking from Base to ICP costs sim-time. Helps students feel the geography.
- **Map tooltips** on hover show the facility type + function + a "when to use" one-liner.
- **First-time-user overlay** (appears once per student lifetime): a quick tour of each facility with the distinctions above.
