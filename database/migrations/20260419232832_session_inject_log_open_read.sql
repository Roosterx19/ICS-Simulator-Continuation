-- 20260419232832_session_inject_log_open_read.sql
-- Adds permissive SELECT for authenticated users (fixes 403 on inject log reads
-- for guests not in session_participants) PLUS INSERT for session members/instructors.
-- (Filename mentions only "open_read" but migration also creates inject_log_insert_member.)
-- Source: supabase_migrations.schema_migrations (verbatim apply text)

create policy "inject_log_read_authed"
  on public.session_inject_log for select
  to authenticated
  using (true);

create policy "inject_log_insert_member"
  on public.session_inject_log for insert
  to authenticated
  with check (
    is_session_member(session_id, auth.uid())
    or is_session_instructor(session_id, auth.uid())
  );
