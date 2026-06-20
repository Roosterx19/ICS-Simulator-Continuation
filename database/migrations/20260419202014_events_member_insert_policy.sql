-- 20260419202014_events_member_insert_policy.sql
-- Lets session members insert their own events (staging_checkin, zone clicks, etc.)
-- Source: supabase_migrations.schema_migrations (verbatim apply text)

create policy "events_member_insert"
  on public.events for insert
  to authenticated
  with check (
    actor_user_id = auth.uid()
    and is_session_member(session_id, auth.uid())
  );
