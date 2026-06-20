-- Per-user scenario completion tracking (powers the leaderboard + profile pages).
--
-- Backfilled 2026-04-28. Version 20260419130534 was applied to the
-- production database via MCP on 2026-04-19 without writing the
-- corresponding .sql file. The DDL below is the verbatim text recovered
-- from supabase_migrations.schema_migrations.statements on the live DB,
-- so a fresh `supabase db reset` (or any clean-clone deploy) creates the
-- same table, RLS policies, trigger function, and trigger that
-- production already has.
--
-- DO NOT MODIFY — this is a historical record. Schema changes should
-- land in a new dated migration after this one.
--
-- ─── Notes for future readers ─────────────────────────────────────
-- The trigger fires AFTER UPDATE on public.sessions and inserts one
-- row per session_participant when status flips to 'ended'. The
-- UNIQUE(user_id, scenario_id) constraint plus ON CONFLICT DO UPDATE
-- means re-running the same scenario overwrites the prior completion
-- with the latest aar_grade — a user's leaderboard entry reflects
-- their *most recent* attempt at each scenario, not their best.
--
-- SECURITY DEFINER + SET search_path = public is the standard pattern
-- for triggers that touch tables the invoking user may not have direct
-- RLS write access to. Same shape as 0003_decision_score_trigger.sql
-- and the score_for_form_submission trigger.
-- ──────────────────────────────────────────────────────────────────

-- Track which scenarios each user has completed (AAR submitted)
CREATE TABLE IF NOT EXISTS public.scenario_completions (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  scenario_id  uuid NOT NULL REFERENCES public.scenarios(id) ON DELETE CASCADE,
  session_id   uuid NOT NULL REFERENCES public.sessions(id) ON DELETE CASCADE,
  aar_grade    text,
  completed_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, scenario_id)
);

ALTER TABLE public.scenario_completions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "completions_self_read" ON public.scenario_completions
  FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "completions_instructor_read" ON public.scenario_completions
  FOR SELECT USING (EXISTS (
    SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.is_instructor = true
  ));

-- Function: auto-record completion when session ends with AAR
CREATE OR REPLACE FUNCTION public.record_scenario_completion()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF NEW.status = 'ended' AND OLD.status != 'ended' THEN
    INSERT INTO public.scenario_completions (user_id, scenario_id, session_id, aar_grade)
    SELECT
      sp.user_id,
      NEW.scenario_id,
      NEW.id,
      ss.aar_grade
    FROM public.session_participants sp
    LEFT JOIN public.session_scores ss ON ss.session_id = NEW.id
    WHERE sp.session_id = NEW.id
    ON CONFLICT (user_id, scenario_id) DO UPDATE
      SET aar_grade = EXCLUDED.aar_grade, completed_at = now(), session_id = EXCLUDED.session_id;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER session_ended_record_completion
  AFTER UPDATE ON public.sessions
  FOR EACH ROW EXECUTE FUNCTION public.record_scenario_completion();
