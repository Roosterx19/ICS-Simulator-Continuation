-- 20260420005321_profiles_self_insert_and_broaden_read.sql
-- Adds INSERT policy for self (fixes 403 on guest-join profile upsert) and
-- broadens SELECT to all authenticated users (needed for roster/forms display
-- joins fetching display_name across participants).
-- Existing profiles_self_read, profiles_self_update, profiles_instructor_read_all unchanged.
-- Source: supabase_migrations.schema_migrations (verbatim apply text)

create policy "profiles_self_insert"
  on public.profiles for insert
  to authenticated
  with check (auth.uid() = id);

create policy "profiles_read_authenticated"
  on public.profiles for select
  to authenticated
  using (true);
