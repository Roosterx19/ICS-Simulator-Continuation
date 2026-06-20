-- Auto-award score points when an ICS form is submitted.
--
-- Backfilled 2026-04-28. Version 20260419133324 was applied to the
-- production database via MCP on 2026-04-19 without writing the
-- corresponding .sql file. The DDL below is the verbatim text recovered
-- from supabase_migrations.schema_migrations.statements on the live DB,
-- so a fresh `supabase db reset` (or any clean-clone deploy) creates the
-- same trigger function and trigger that production already has.
--
-- DO NOT MODIFY — this is a historical record. Schema changes should
-- land in a new dated migration after this one.
--
-- ─── Notes for future readers ─────────────────────────────────────
-- Why SECURITY DEFINER: the trigger updates public.session_scores
-- (and inserts a row if missing). Form submitters typically only have
-- RLS write access to their own form_submissions row, not to the
-- session-scoped scores row. Running the trigger as the function
-- definer (not the invoking user) lets the score update bypass RLS
-- the same way 0003_decision_score_trigger.sql's apply_decision_to_score
-- does for decisions. `SET search_path = public` is the standard
-- security hardening so a malicious schema-shadow attack can't redirect
-- inserts to a different table.
--
-- Why AFTER UPDATE (not AFTER INSERT): forms are typically inserted as
-- drafts and UPDATEd to status='submitted' on submit. The trigger uses
-- OLD.status to detect the draft → submitted transition; it short-circuits
-- if the form was already submitted (re-submit shouldn't double-count).
-- A form created directly with status='submitted' in a single INSERT
-- would NOT fire this trigger — verify in the Supabase dashboard that
-- the create-form UI in the app actually goes through the draft-then-update
-- path before relying on this for scoring.
--
-- Cumulative effect on session_scores: each submission bumps `score`
-- and `max_score` by the same per-form amount (so percentage stays
-- monotonic) and `decisions_made` by 1. The decisions_made bump
-- matters because computeAar() in lib/sim/aar.ts auto-grades a session
-- with decisions_made = 0 as F — submitting forms therefore counts as
-- "decisions" for AAR purposes.
-- ──────────────────────────────────────────────────────────────────

-- Award points when ICS forms are submitted (encourages proper IAP documentation)
CREATE OR REPLACE FUNCTION public.award_form_submission_score()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  form_points integer;
BEGIN
  -- Only award on submission (not draft)
  IF NEW.status != 'submitted' THEN RETURN NEW; END IF;
  -- Only award once (not on re-submit)
  IF OLD.status = 'submitted' THEN RETURN NEW; END IF;

  -- Points by form type (higher for more complex forms)
  form_points := CASE NEW.template_code
    WHEN 'ICS-201' THEN 15
    WHEN 'ICS-202' THEN 20
    WHEN 'ICS-204' THEN 15
    WHEN 'ICS-205' THEN 10
    WHEN 'ICS-206' THEN 10
    WHEN 'ICS-208' THEN 10
    WHEN 'ICS-211' THEN 8
    WHEN 'ICS-221' THEN 12
    ELSE 5
  END;

  -- Upsert score
  INSERT INTO public.session_scores (session_id)
  VALUES (NEW.session_id)
  ON CONFLICT (session_id) DO NOTHING;

  UPDATE public.session_scores
  SET
    score       = score + form_points,
    max_score   = max_score + form_points,
    decisions_made = decisions_made + 1,
    updated_at  = now()
  WHERE session_id = NEW.session_id;

  RETURN NEW;
END;
$$;

CREATE TRIGGER form_submitted_award_score
  AFTER UPDATE ON public.form_submissions
  FOR EACH ROW EXECUTE FUNCTION public.award_form_submission_score();
