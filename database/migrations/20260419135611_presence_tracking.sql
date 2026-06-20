-- Presence tracking for session participants.
--
-- Backfilled 2026-04-28. Version 20260419135611 was applied to the
-- production database via MCP on 2026-04-19 without writing the
-- corresponding .sql file. The DDL below is the verbatim text recovered
-- from supabase_migrations.schema_migrations.statements on the live DB,
-- so a fresh `supabase db reset` (or any clean-clone deploy) creates the
-- same table, RLS policies, index, and realtime publication entry that
-- production already has.
--
-- DO NOT MODIFY — this is a historical record. Schema changes should
-- land in a new dated migration after this one.

-- Track real-time player presence via Supabase Realtime Presence channels
-- This table tracks last-seen timestamps for additional reliability beyond the presence channel
CREATE TABLE IF NOT EXISTS public.presence_log (
  session_id uuid NOT NULL REFERENCES public.sessions(id) ON DELETE CASCADE,
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  last_seen  timestamptz NOT NULL DEFAULT now(),
  current_page text,
  PRIMARY KEY (session_id, user_id)
);

ALTER TABLE public.presence_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "presence_read_participants" ON public.presence_log
  FOR SELECT USING (EXISTS (
    SELECT 1 FROM public.session_participants sp
    WHERE sp.session_id = presence_log.session_id AND sp.user_id = auth.uid()
  ));

CREATE POLICY "presence_upsert_self" ON public.presence_log
  FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

CREATE INDEX IF NOT EXISTS presence_log_session_idx ON public.presence_log(session_id, last_seen DESC);

ALTER PUBLICATION supabase_realtime ADD TABLE public.presence_log;
