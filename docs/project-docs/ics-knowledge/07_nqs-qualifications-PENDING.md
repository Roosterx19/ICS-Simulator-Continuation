# NIMS National Qualification System (NQS) — PENDING

**⚠️ Status: DRAFT / PENDING SOURCE UPLOAD.**
The *FEMA NIMS Guideline for the National Qualification System* PDF (Nov 2017, ~49 pp) is **not in project knowledge.** The framework below is a known-outline scaffold from general NIMS knowledge — **treat it as planning context, not an authoritative citation.** When the PDF is uploaded, Claude Code should re-read it and rewrite this file with line-accurate references.

---

## Why this matters for the sim

Qualification, certification, and credentialing are how people become ICs, Section Chiefs, Unit Leaders, etc. in the real world. If the sim is going to be authentic, Phase 4+ should model this progression. Phase 1–3 deliberately do **not** gate roles — every student can pick anything for practice.

---

## The three NQS processes (high-level)

```
QUALIFICATION → CERTIFICATION → CREDENTIALING
```

- **Qualification** — trainee completes prerequisites (courses, licenses, medical/fitness) AND a **Position Task Book (PTB)** signed by an evaluator.
- **Certification** — the **Authority Having Jurisdiction (AHJ)** — typically via a **Qualification Review Board (QRB)** and a **Certifying Official (CO)** — reviews the completed PTB and issues formal certification.
- **Credentialing** — the AHJ issues an identity card / badge attesting to identity and certified qualifications. Expires; revoked on decertification.

---

## Position Task Book (PTB) — conceptual model

A structured document listing, for ONE specific position, every competency/behavior/task the trainee must demonstrate. Each has a signature block.

Common features (to be verified against source):
- Issued by AHJ to trainee, typically via the trainee's supervisor
- Timeframe to complete (often 5 years; AHJ may set shorter)
- Evaluation at real incidents preferred; full-scale exercises acceptable
- Only one PTB per position at a time
- Final evaluator typically must be qualified in the target position
- **ICS Form 225** (Incident Personnel Performance Rating) from supervisor on each qualifying incident is filed alongside

---

## Incident Complexity Types → qualifications

Real-world pattern:
- Type 5 / 4 positions: minimal PTB, mostly course prerequisites
- Type 3: full PTB, moderate prerequisite stack
- Type 2 / 1: extensive PTB, complex prerequisite chain, typically national-level certification bodies

Our sim's scenario complexity maps to this tier structure.

---

## Currency (maintaining qualification)

Commonly: must perform the role (real or qualifying exercise) at least once every **5 years** or revert to trainee status. AHJ has discretion.

---

## Decertification triggers (commonly cited)

- Unsafe actions endangering self or others
- Misrepresentation of qualifications
- Failure to follow delegation of authority
- Inappropriate conduct
- Ignoring safe practices
- Unacceptable performance rating

**Sim implication:** Phase 4+ could fire a "decert warning" when a student in-sim approves an unsafe action, mis-signs a form, or violates delegation.

---

## Proposed Sim Data Model (Phase 4+)

```
position_task_books
  id · user_id · position_code · issued_by · issued_at
  expires_at · status (open | completed | expired | revoked)

ptb_tasks
  id · ptb_id · task_number · description · category
  (competency | behavior | task) · required_for_type
  evaluator_user_id · signed_at · notes

qualification_records
  id · user_id · position_code · qualified_at · qualified_by
  certification_type (trainee | qualified | instructor | evaluator)
  expires_at · status

qualifying_performances
  id · user_id · position_code · session_id · ics225_form_id
  rating · occurred_at

credentials
  id · user_id · issued_at · expires_at · revoked_at
  card_number · qualifications (array of position_codes)
```

---

## Do NOT build this in Phase 1–3

Per `ROADMAP.md`:
- Phase 1–3: every role open-pick, no gating
- Phase 4: profile qualifications tracked, role-select board respects them in "certification mode" but remains open in "practice mode"
- Phase 5: full PTB / QRB / CO workflow

**Reason:** premature complexity. The core product value is *experiencing* ICS roles. Gating access defeats that until a student has already explored.

---

## Action item for the user

**Re-upload these three PDFs to the Claude project so this placeholder can be replaced with source-accurate content:**

1. *NIMS Guideline for the National Qualification System* (FEMA, Nov 2017) — `fema_nims_nqs_guideline_0.pdf`
2. *NIMS Doctrine* (FEMA, 2017) — `FEMA_NIMS_Doctrine_2017.pdf` (content already partially extracted into `06_nims-doctrine-consolidated.md`; cross-check when available)
3. *NIMS ICS Forms Booklet v3* — `nims_ics_forms_booklet_v3.pdf`

When those are in project knowledge, Claude Code (or another session) should:
1. Read each PDF in full
2. Rewrite this file from scratch citing specific section numbers
3. Cross-validate `06_nims-doctrine-consolidated.md` against the standalone Doctrine PDF
4. Create a new `08_ics-forms-booklet-fields.md` mapping every form field to the zod schema in `lib/ics/forms/*.ts`
