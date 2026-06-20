-- HSEEP improvement plan tracking.
--
-- Backfilled 2026-04-27. Version 20260419132058 was applied to the
-- production database via MCP on 2026-04-19 without writing the
-- corresponding .sql file. The DDL below is the verbatim text recovered
-- from supabase_migrations.schema_migrations.statements on the live DB,
-- so a fresh `supabase db reset` (or any clean-clone deploy) creates the
-- same table and RLS policies that production already has.
--
-- Depends on aar_observations from 20260418210944_hseep_aar_observations.
--
-- DO NOT MODIFY — this is a historical record. Schema changes should
-- land in a new dated migration after this one.

-- Improvement Plan (IP) items — per HSEEP Module 6 / Corrective Action Program
CREATE TABLE IF NOT EXISTS public.improvement_items (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id       uuid NOT NULL REFERENCES public.sessions(id) ON DELETE CASCADE,
  observation_id   uuid REFERENCES public.aar_observations(id) ON DELETE SET NULL,
  capability       text,
  observation      text NOT NULL,
  recommendation   text NOT NULL,
  corrective_action text NOT NULL,
  primary_agency   text NOT NULL DEFAULT '',
  support_agencies text[] NOT NULL DEFAULT '{}',
  completion_date  date,
  status           text NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_progress','completed','cancelled')),
  poete_category   text CHECK (poete_category IN ('planning','organizing','equipping','training','exercising')),
  created_by       uuid NOT NULL REFERENCES auth.users(id),
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.improvement_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "ip_read_participants"
  ON public.improvement_items FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.session_participants sp
    WHERE sp.session_id = improvement_items.session_id AND sp.user_id = auth.uid()
  ));

CREATE POLICY "ip_insert_self"
  ON public.improvement_items FOR INSERT
  WITH CHECK (created_by = auth.uid());

CREATE POLICY "ip_update_creator"
  ON public.improvement_items FOR UPDATE
  USING (created_by = auth.uid() OR EXISTS (
    SELECT 1 FROM public.profiles p WHERE p.id = auth.uid() AND p.is_instructor = true
  ));
