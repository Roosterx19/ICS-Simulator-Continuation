# Platform Overview

## What It Is
A browser-based, near-3D training simulator that recreates FEMA Incident Command System classes (ICS 300, ICS 400, G191, 0305, L101–L105) so students can **physically move through the ICS structure** — picking roles, filling forms, managing resources and budgets, and walking their avatar between staging, base, camp, and the Emergency Operations Center — while the instructor progresses the course slideshow.

## The Problem It Solves
In traditional ICS classroom training, students consistently struggle with:
- Distinguishing **Unified Command** from **Incident Command** from **Unity of Command**
- Remembering which facility does what (Staging vs. Base vs. Camp vs. Incident Site vs. EOC)
- Keeping track of their own role's responsibilities, signatures, and reports
- Experiencing the **modular expansion** of the ICS org chart (what happens when someone gets added or pulled?)
- Filling the correct ICS form at the correct transition (who signs what, when?)
- Understanding how **section-level information silos** work in practice (finance can't see ops traffic, etc.)

This simulator lets them *do it* instead of just *hear about it*.

## Target User

### Primary
ICS 300/400 students — first responders, emergency managers, fire/EMS/police personnel, public works, public health, hospital emergency coordinators, utility ops, CERT team members. Mixed technical backgrounds. Often learning ICS for agency requirements or promotion, not by choice.

### Secondary
ICS instructors and training officers who run the courses and need a controllable "main screen" view of the full class plus the ability to inject scenario events.

## Core Features (MVP — Phase 1)
- **Auth + student roster** — students log in, instructor sees roll
- **Role-selection board** — modular chart of all ICS roles. Pick a role → it turns red/green → your name appears in Staging
- **Role-based dashboard** — you only see traffic for your section (Ops sees Ops, Finance sees Finance). IC sees all. Command Staff sees all command traffic.
- **Digital ICS forms** — ICS 201, 202, 203, 204 at minimum, with role-appropriate signature gates
- **Near-3D isometric classroom view** — look down on the class, see other students' avatars at their stations
- **One full scenario** tied to one Central City / Liberty County map from the FEMA training atlas (ICS 300 Central City Flood Scenario is the Phase 1 target)
- **Instructor "main screen"** — master view showing everyone in every section

## Core Features (Phase 2)
- **Resource catalog with real-world pricing** (water, medical supplies, fire equipment, personnel, vehicles, heavy equipment — dump truck, crane, helicopter)
- **Availability indicator** — easy to procure = green, hard = red/black
- **Budget tracker** — starts at a selected budget tier, ticks down as resources are deployed; Finance owns it
- **Budget warnings** at 75%, 50%, 15%, 5%, and over-budget, with recommended substitutions
- **IAP auto-builder** — fills as students complete forms, signed by all required roles
- **SMART objective validator** — flags objectives missing Specific / Measurable / Achievable / Relevant / Time-bound elements
- **Operational period clock** — 8 / 12 / 24 hour cycles with shift-change and transfer-of-command flows

## Core Features (Phase 3)
- **Multi-student realtime** via Supabase Realtime — 30 students, each moving their own avatar, all synchronized
- **Staging → Deployment movement** — walk your avatar to your assigned station, check in, check out
- **Chat / tablet UI** — each avatar carries a virtual tablet for section-scoped messaging and help requests
- **Letter-of-Expectation flow** — approving authority hands off to IC with proper documentation

## Core Features (Phase 4)
- **Avatar customization** — mixed race, gender, body size, outfit
- **Outfit color coding:**
  - Incident Commander = **pink**
  - Command Staff (Safety, PIO, Liaison) = **red**
  - General Staff Section Chiefs (Ops, Plans, Logistics, Finance, I/I) = **green**
  - Bosses / supervisors of any group = **white**
  - Hazmat / fire / police / public works use their discipline's PPE
- **Number on the back** = role severity level
- **Walking movement** — character walks between map locations, time documented
- **Voice lines + scripted audio** for roles and briefings

## Core Features (Phase 5 — deferred)
- **Full 3D avatars and environments** (currently blocked on hardware cost)
- **Expanded course coverage:** CERT team scenarios, HazMat/Fire/Police/Media/Public Works/Phone-company integrations

## What It Is NOT
- **Not a replacement for FEMA certification.** Students still take the official FEMA course; this is a supplementary practice environment.
- **Not a game.** Passing / failing is tied to ICS-correct behavior, not score-chasing.
- **Not multiplayer outside a class session.** Each session is scoped to one class with one instructor.
- **Not AI-in-the-simulation.** External AI tools (Gemini, Perplexity, Base44) are developer-side only; the simulation itself is deterministic.
- **Not mobile-first.** Tablet and desktop are the primary form factors. Phones are a stretch goal.
- **Not offline.** Requires live Supabase connection.

## Current Stage
- [x] Idea
- [x] Spec (this doc + PRD)
- [ ] Building MVP ← **we are here**
- [ ] Beta
- [ ] Live

## Revenue Model
TBD — likely per-seat licensing to training academies and emergency management agencies once MVP proves the concept. No revenue work in Phases 1–3.

## North Star Metric
**Scenario completion rate with correct form chain** — percentage of students who finish a scenario having filled every required ICS form, signed by every required role, on time, under budget.
