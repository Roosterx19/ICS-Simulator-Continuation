# User Personas

## Purpose
Claude should reference these personas when making product decisions, writing UI copy, designing flows, or suggesting features. Always ask: *"Does this serve the persona we're building for right now?"*

---

## Primary Persona — **Marcus**

### Who They Are
- **Age:** 32
- **Role:** Lieutenant, municipal fire department; nominated by his chief to attend ICS 300/400
- **Tech comfort:** Comfortable — uses a department CAD system, smartphone, Google Workspace
- **Works at:** Mid-size city fire department, ~250 personnel

### Their Situation
Marcus has been told he needs ICS 300 and 400 to be considered for Battalion Chief. He's run plenty of structure fires but never an incident that expanded beyond his own engine company. He already passed ICS 100 and 200 online years ago and barely remembers them. The in-person class is a full week and his shift trade has to be approved.

### The Problem They Have
Marcus sat through three hours of slides explaining the difference between Incident Command, Unified Command, and Unity of Command, and he still mixes them up. When the instructor said "the Ops Section Chief reports to the IC but doesn't see Finance traffic," he could not picture what that meant in practice. The ICS 204 form looked like tax paperwork. He's anxious about the final scenario exercise.

### What They've Tried
- FEMA's online ICS courses (boring, multiple choice, no retention)
- YouTube ICS videos (mostly 15-year-old talking-head lectures)
- His department's SOPs (written for his specific dept, don't match FEMA terminology)

### What They Want
To feel the shape of ICS in his head the way he already feels the shape of a fireground. He wants to click a role, see what he'd actually have to do, what forms he'd sign, who he'd talk to, and what happens when the incident grows beyond him.

### What They Fear
- Failing the class and having to explain it to his chief
- Walking into a real Type-2 incident and freezing because he picked the wrong form
- Looking confused in front of younger firefighters who already know this

### How They Find Us
His training officer assigns it. He would not sign up on his own.

### Willingness to Pay
Zero direct — the department or training academy pays. He'll use what they give him.

### Quote That Captures Them
*"I've run a hundred fires. I just need somebody to show me where the Planning Section Chief actually stands and what they're actually doing, not another flowchart."*

---

## Secondary Persona — **Dana**

### Who They Are
- **Age:** 47
- **Role:** ICS course instructor — retired county emergency manager now contracting to teach ICS 300/400 for a state fire academy
- **Tech comfort:** Moderate — uses PowerPoint daily, can run a Zoom, prefers physical handouts
- **Works at:** Freelance, contracted ~20 courses per year

### Their Situation
Dana teaches the same FEMA slide deck four times a month. The material is locked — she can't change the slides or the exam. What she can change is how she runs the in-class exercises and tabletop scenarios. She consistently sees the same student struggles: "staging vs. base vs. camp," "who signs ICS 202," modular expansion confusion. She'd like a tool she can project on the screen and drive the class through.

### The Problem They Have
The official FEMA tabletop exercises are paper-based and slow. Half the class finishes early and disengages; the other half falls behind and needs hand-holding. Dana wants every student working their own role in parallel while she watches a master view and injects events ("MCI just expanded — your Operations Section Chief got hurt, transfer command now").

### What They Want
- A master instructor screen that shows every student's position, role, and form status
- The ability to inject a scenario event that forces transfer of command, budget overrun, or resource shortage
- Confidence that the tool matches FEMA content exactly — she cannot deviate from the curriculum

### What They Fear
- A tool that "looks like a game" and gets her pulled from the contractor list
- Bugs during a live class
- Students using it to cheat through activities instead of learning

### Willingness to Pay
Not personally — recommends to academies who pay per-seat.

### Quote That Captures Them
*"If I can stop saying 'imagine you're the Ops Chief' and instead say 'you ARE the Ops Chief, what do you do,' I've won the week."*

---

## Tertiary Persona — **Priya** (CERT volunteer)

### Who They Are
- **Age:** 29
- **Role:** Community Emergency Response Team (CERT) volunteer, software designer by day
- **Tech comfort:** Power user
- **Works at:** Tech company; volunteers evenings/weekends

### Their Situation
Priya joined CERT after a local wildfire. She's done ICS 100 and wants to go further but can't take a week off work to attend a full classroom course. She's the future audience — self-directed, motivated, willing to practice on her own.

### The Problem They Have
Self-study options are either too shallow (online quizzes) or assume classroom context (references to handouts she doesn't have). No bridge.

### What They Want
Practice the mechanics of ICS roles on her own schedule before attending a live class.

### What They Fear
Showing up to CERT deployments and being the weak link.

### Willingness to Pay
Would pay $20–50 for self-directed access if the tool were excellent.

### Quote That Captures Them
*"I want to drill this the way I drill anything else — repetition, realistic scenarios, see my mistakes."*

---

## Personas We Are NOT Building For (v1)

- **Non-English speakers** — English only in v1; ICS terminology is English-first in US FEMA materials
- **Federal-level emergency managers** running Stafford Act incidents — they already run Type-1 incidents live; our scope is Type 3/4 training
- **Gamers looking for an action sim** — this is professional training, not entertainment
- **K–12 students** — content is adult-professional
- **Non-US emergency response frameworks** (Canadian ICS is similar but distinct; ignore for v1)

---

## Decision Filter
When Claude suggests a feature, flow, or piece of copy — run it through:

1. Does **Marcus** immediately understand this without reading a tooltip?
2. Does it match exactly what **Dana** would see in the FEMA curriculum? (No made-up ICS terms.)
3. Does **Priya** have enough context to use it solo, or does it require an instructor?
4. Does it accidentally serve gamers or K–12 students?

If it fails 1 or 2, redesign. If it fails 3, mark it "instructor-led only." If it fails 4, cut it.
