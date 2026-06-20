-- HSEEP AAR observations.
--
-- Backfilled 2026-04-27. Version 20260418210944 was applied to the
-- production database via MCP on 2026-04-18 without writing the
-- corresponding .sql file. The DDL below is the verbatim text recovered
-- from supabase_migrations.schema_migrations.statements on the live DB,
-- so a fresh `supabase db reset` (or any clean-clone deploy) creates the
-- same type, table, RLS policies, and realtime publication entry that
-- production already has.
--
-- DO NOT MODIFY — this is a historical record. Schema changes should
-- land in a new dated migration after this one.

DO $$ BEGIN
  CREATE TYPE public.hseep_observation_strength AS ENUM ('strength', 'area_for_improvement');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS public.aar_observations (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id       uuid NOT NULL REFERENCES public.sessions(id) ON DELETE CASCADE,
  observed_by      uuid NOT NULL REFERENCES auth.users(id),
  observer_role    text,
  strength         public.hseep_observation_strength NOT NULL DEFAULT 'area_for_improvement',
  core_capability  text,
  observation      text NOT NULL,
  root_cause       text,
  recommendation   text,
  improvement_item text,
  esf_reference    text,
  sort_order       integer NOT NULL DEFAULT 0,
  created_at       timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.aar_observations ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  CREATE POLICY "aar_obs_read_participants"
    ON public.aar_observations FOR SELECT
    USING (EXISTS (
      SELECT 1 FROM public.session_participants sp
      WHERE sp.session_id = aar_observations.session_id AND sp.user_id = auth.uid()
    ));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "aar_obs_insert_self"
    ON public.aar_observations FOR INSERT
    WITH CHECK (observed_by = auth.uid());
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "aar_obs_update_self"
    ON public.aar_observations FOR UPDATE
    USING (observed_by = auth.uid());
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

ALTER PUBLICATION supabase_realtime ADD TABLE public.aar_observations;
