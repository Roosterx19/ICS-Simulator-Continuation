# Product Requirements Document (PRD)

**Product:** ICS Training Simulator
**Version:** 0.1 (pre-MVP spec)
**Last updated:** 2026-04-17

> This is the authoritative requirements document. When `docs/watts/02_platform-overview.md` and this PRD disagree, the overview wins for *why* and this PRD wins for *what to build*.

---

## 1. Vision

Recreate the experience of a live FEMA Incident Command System classroom (ICS 300, ICS 400, G191, 0305, L101–L105) in a browser, such that a student can move a virtual person through the ICS structure, fill real ICS forms, and experience modular expansion, section-level information silos, and operational period cadence — in parallel with the instructor's slide progression.

## 2. Non-Goals

- Replacing FEMA certification courses
- Gamification for its own sake
- Non-US ICS variants (Canadian, international)
- Mobile-phone-first experience (tablet + desktop only in v1)
- Offline use
- In-app AI assistants in v1 (developer-side only)
- SaaS billing in v1

## 3. Core Use Cases

| # | Actor | Use Case | Success Criterion |
|---|---|---|---|
| 1 | Student | Log in, join a session, pick a role | Role is persisted and visible on instructor's screen |
| 2 | Student | Fill and submit an ICS-201 | Form is validated, stored, signature gate enforced |
| 3 | Student (OSC) | See Ops section traffic only | Cannot read Finance forms — enforced by RLS (tested) |
| 4 | Instructor | View all students across all sections | Master screen shows live state of 30 participants |
| 5 | Student | Move avatar from Staging to assigned Division | Position persists; instructor sees movement |
| 6 | Planning Section | Assemble signed IAP at end of operational period | All required forms present + signed; operational period advances |
| 7 | Finance Section | Approve resource request; budget decrements | Budget display updates; over-threshold alert fires at correct %s |
| 8 | Student | Request help from supervisor via tablet chat | Message arrives scoped to section + chain of command |

---

## 4. Functional Requirements by Phase

Phases are cumulative — Phase 2 includes everything in Phase 1.

### Phase 1 — MVP Foundation

**Target:** ~6 weeks of focused Claude Code work.

#### 1.1 Authentication
- Email/password sign up and sign in via Supabase Auth
- Magic link as alternative
- Session cookie refreshed by Next.js middleware on every request
- Profile row auto-created on first login

#### 1.2 Session Management
- Instructor creates a session from a scenario template
- Session shows: name, scenario, operational period (static in Phase 1 at period 1), participant count, status (lobby / active)
- Session join link (URL with session ID)
- Students land on session page → auto-insert into `session_participants` if not already present

#### 1.3 Role Selection (Modular Chart)
- Visual org chart rendered as connected nodes (IC at top, Command Staff branching right, General Staff sections below)
- Nodes are color-coded per `docs/watts/06_ui-design-system.md` (IC=pink, Command=red, Section=green, Boss=white)
- Roles with no parent assigned are **disabled** (grayed out) — enforces modular expansion
- Click an available node → confirmation modal → role assigned, node turns a "taken" state, name shows below
- Student's name appears in Staging area panel immediately after selection
- A student can release their role (node goes back to open)
- Prerequisite role assignments are enforced:
  - Cannot pick OSC without IC being assigned
  - Cannot pick Division Supervisor without Operations Section Chief
  - Etc. — hierarchy derived from `ics_roles.reports_to_code`

#### 1.4 Role-Based Dashboard
- Single-column section feed
- Shows events (role assignments, form submissions, messages) scoped to the student's section + command chain visible to them
- Finance sees Finance. Ops sees Ops. IC sees all. Command Staff (Safety, PIO, Liaison) sees all command traffic and their respective domains.
- Real-time updates (Phase 1: polling every 10s; Phase 3: Supabase Realtime)

#### 1.5 ICS-201 Digital Form (first form shipping)
- Full form UI matching FEMA ICS-201 structure
- Sections: Incident details, Current Situation, Objectives, Org, Resources
- Validation via zod; required fields flagged
- Draft autosave every 30s
- Submit requires IC signature (role must be assigned IC)
- Submitted form locks and appears in visible feeds per RLS

#### 1.6 Isometric Classroom View (near-3D)
- react-three-fiber canvas, isometric camera
- Shows the classroom as a top-down-angled 3D scene with:
  - One desk per student (simple box geometry)
  - Role-labeled facility markers (ICP, Base, Staging, Incident Site) as colored plinths
  - Each participant represented as a colored capped cylinder (color = role color)
- No walking animation in Phase 1 — avatars "jump" between locations on assignment
- Camera orbit + zoom (drei OrbitControls)
- Instructor sees all avatars; students see all avatars too (this is a classroom view)

#### 1.7 Instructor Master Screen
- Separate URL: `/instructor/[sessionId]`
- Live roster: name, role, location, last activity
- Form submission status per form per student
- Event timeline (append-only)
- NO ability to inject events in Phase 1 (added in Phase 2)

#### 1.8 One Seeded Scenario
- Derived from ICS 400 Unit 4 Katrina Area Command scenario OR a simpler ICS 300 tabletop
- One map asset (PNG extracted from course PDF) uploaded to `scenario-maps` bucket
- Single operational period, single incident (not Area Command yet)
- Initial objectives list and starting resource set

#### 1.9 Non-Functional
- All API routes have Vitest tests
- Every new DB table has RLS policy tests
- Lighthouse: Performance >80, Accessibility >95 on the session page
- Page loads: <2s initial on broadband tablet

---

### Phase 2 — Resources, Budget, IAP, SMART

**Target:** ~5 weeks after Phase 1.

#### 2.1 Resource Catalog
- Seeded `resources` table with personnel, vehicles, equipment, supplies, facilities
- Each resource: category, discipline, NIMS type (I–V), unit cost (cents), availability tier (easy/moderate/hard/blocked)
- Resources visible catalog UI scoped to Logistics Section Chief + Operations leadership
- Filter/search UI
- Request resource → creates `resource_allocations` row in `requested` state

#### 2.2 Budget System
- Session starts with `remaining_budget_cents` from scenario template
- Finance Section approves `requested` allocations → moves to `approved`, debits budget
- Real-time budget HUD visible to Finance + IC
- Alert bands fire at 75%, 50%, 15%, 5%, and over-budget (see design system color tokens)
- Over-threshold alerts include **substitution suggestions** (e.g. "Type I engine unavailable → suggest Type II engine, cost delta: –$X")

#### 2.3 Additional Forms
- ICS-202 (Incident Objectives) — required signatures: IC
- ICS-203 (Organization Assignment List) — auto-generated from `session_participants`
- ICS-204 (Assignment List) — one per Division/Group, signed by OSC + PSC
- ICS-205 (Radio Comms Plan) — COML fills, PSC signs
- ICS-206 (Medical Plan) — MEDL + SOFR sign
- ICS-208 (Safety Message) — SOFR signs
- ICS-214 (Activity Log) — auto-generated per user from `events` table
- ICS-215 (Operational Planning Worksheet) — OSC + PSC sign

#### 2.4 IAP Auto-Builder
- Background job (Supabase Edge Function) monitors form submissions
- When all required forms for an operational period are submitted + signed → IAP assembled
- IAP PDF generated and stored in `form-exports` bucket
- IC receives signature request for final IAP
- Operational period cannot advance without signed IAP

#### 2.5 SMART Objective Validator
- On ICS-202 objective entry, each objective passes through `lib/ics/smart-validator.ts`
- Flags missing elements per letter (Specific, Measurable, Achievable, Relevant, Time-bound)
- Non-blocking in Phase 2 (visible warning); blocking in Phase 3 (cannot submit ICS-202 without all 5)
- Examples shown inline: "Your objective lacks a time element. Example: '…by end of operational period 2.'"

#### 2.6 Operational Period Clock + Shift Changes
- Live clock: wall time, incident time, op period time, next-milestone countdown
- Scheduled meetings fire as toasts at correct times in the Planning P
- Transfer of Command flow: outgoing IC → incoming IC hand-off modal with required steps
- Shift change at period boundary: outgoing participants read-only for 10 min, then locked out; incoming take over

#### 2.7 Instructor Event Injection
- Instructor master screen gets "Inject Event" button
- Catalog: resource shortage, key personnel injury (forces transfer of command), weather change, political pressure, media surge
- Injections emit `events` rows and trigger corresponding UI state in affected student dashboards

---

### Phase 3 — Multi-Student Realtime & Movement

**Target:** ~5 weeks after Phase 2.

#### 3.1 Supabase Realtime Channels
- One channel per session: `session:{sessionId}`
- Subscribed tables: `session_participants`, `form_submissions`, `resource_allocations`, `messages`, `events`
- Client hook `useSessionRealtime` bridges DB events to TanStack Query cache
- Dashboard polling removed

#### 3.2 Avatar Movement on Grid
- Classroom + map = grid of tiles
- Click-to-move: student clicks a destination tile → avatar walks there at fixed tile/second rate
- Pathfinding: simple A* on a pre-authored grid (not procedural)
- Movement events time-stamped in `events`
- Movement blocked by assignment: you cannot walk to a Division you aren't assigned to

#### 3.3 Check-in / Check-out Flow
- Student takes "badge" in classroom → appears as wearable
- Walks to Staging → scans in at check-in station → ICS-211 entry generated
- Receives assignment (auto-assigned from ICS-204) → walks to Division
- At period end, walks back to check-out → logs off

#### 3.4 Tablet UI (In-Sim Messaging)
- Every avatar carries a virtual tablet
- Open tablet: chat panel with section-scoped channels
  - My Section (e.g. Operations)
  - My Supervisor / Chain of Command
  - All-Hands (from IC only)
- Send help request button → routes to supervisor
- Messages stored in `messages` table; visible per RLS scope

#### 3.5 Delegation of Authority Flow
- At scenario start, Agency Admin (NPC, not a student role) sends Letter of Expectation modal to IC
- IC must acknowledge before session becomes "active"
- Letter content is scenario-specific (pulled from `scenarios.delegation_letter_md`)

---

### Phase 4 — Avatars, Outfits, Walking

**Target:** ~6 weeks after Phase 3. Scope subject to change based on Phase 3 learnings.

#### 4.1 Custom Avatars
- Character customizer: race, gender presentation, body type (within reasonable library of pre-built options)
- No copyrighted likenesses; all avatars are stylized, non-photorealistic
- Avatar config stored in `profiles.avatar_config` (jsonb)

#### 4.2 Outfit Color Coding
- Role shirt color auto-assigned by `ics_roles.color_token`
- Discipline PPE when applicable: fire turnouts, EMS jumpsuit, police uniform, hazmat suit (Level A/B/C/D), public works hi-vis
- Number on back = role severity level (1–5 by incident Type)

#### 4.3 Walking Animation + Time Cost
- Proper walking animation (keyframe or simple skeletal)
- Walking speed configurable per scenario
- Time spent walking logged in ICS-214 auto-entries

#### 4.4 Voice Lines + Scripted Audio
- Per-role canned voice lines for key moments (assuming command, transferring command, reporting in)
- Text-to-speech OR pre-recorded clips (decide in Phase 4 kickoff)
- Mute toggle per student

---

### Phase 5 — Full 3D & Expanded Courses

**Deferred.** User has noted hardware cost is a blocker. Revisit when budget permits.

Scope likely includes:
- Full 3D avatars with skeletal rigs
- Environment meshes (buildings, vehicles, terrain)
- Full discipline coverage: CERT, HazMat drills, fire/police/media/public works/phone-company scenarios
- VR mode exploration

---

## 5. Non-Functional Requirements (All Phases)

### Performance
- Session page TTI <2s on tablet broadband
- 3D canvas maintains 30fps with 30 participants + avatars
- Real-time message delivery <500ms in Phase 3+

### Security
- RLS on every table; service-role key server-only
- Auth cookies HttpOnly, Secure, SameSite=Lax
- No PII beyond email + display name
- Audit log (`events` table) is append-only, never deleted

### Accessibility
- Lighthouse Accessibility >95 on all non-canvas pages
- Keyboard navigation for all actions (canvas-independent fallback for role select, forms, dashboards)
- ARIA labels on all interactive components
- Color never the only signal (icon + text accompany all color states)

### Reliability
- Every route handler wrapped in `handleError`
- Sentry (Phase 2+) captures all unhandled errors with session context (no PII)
- Graceful offline detection: "Lost connection, reconnecting…" banner

### Testing
- Unit coverage: `lib/ics/*` ≥90%
- RLS policy tests mandatory per table
- E2E coverage of critical path: login → join → role → submit form

### Compliance
- No reproduction of copyrighted FEMA content beyond factual reference (concepts, form structures, terminology are factual/functional, not copyrighted expression)
- All scenario narratives original; coordinates and layouts derived from course maps may need licensing review before beta

---

## 6. Out of Scope (Explicit)

- Offline mode
- Native mobile apps
- Multi-language (English only v1)
- Custom scenario authoring by end-users (Phase 5+)
- Course content delivery (the slides are FEMA's; we supplement, not replace)
- Grading/certification issuance
- LMS integration (SCORM/xAPI) — post-v1

---

## 7. Open Questions

1. **Scenario content licensing** — can we derive scenario maps directly from ICS 400 course PDFs for training, or do we need original maps? **Action:** legal review before Phase 1 beta.
2. **TTS vs recorded audio** — Phase 4 decision.
3. **Billing model details** — Phase 5 decision; out of scope for Phases 1–4.
4. **Single- vs multi-tenant** — is each training academy a separate Supabase project, or is this one shared instance with tenant row? **Current assumption:** single-tenant in v1, revisit at beta.
