-- Helper: runs as SECURITY DEFINER so it bypasses RLS when checking membership.
-- This is the standard Supabase pattern for breaking policy recursion cycles.
create or replace function public.is_session_member(_session_id uuid, _user_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.session_participants
    where session_id = _session_id and user_id = _user_id
  );
$$;

create or replace function public.is_session_instructor(_session_id uuid, _user_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.sessions
    where id = _session_id and instructor_id = _user_id
  );
$$;

create or replace function public.current_user_is_instructor()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(
    (select is_instructor from public.profiles where id = auth.uid()),
    false
  );
$$;

-- ---------- profiles ----------
drop policy if exists "profiles_instructor_read_all" on public.profiles;

create policy "profiles_instructor_read_all"
  on public.profiles for select
  using (public.current_user_is_instructor());

-- ---------- sessions ----------
drop policy if exists "sessions_participant_read" on public.sessions;

create policy "sessions_participant_read"
  on public.sessions for select
  using (
    instructor_id = auth.uid()
    or public.is_session_member(id, auth.uid())
  );

-- ---------- session_participants ----------
drop policy if exists "sp_session_members_read" on public.session_participants;

create policy "sp_session_members_read"
  on public.session_participants for select
  using (
    user_id = auth.uid()
    or public.is_session_member(session_id, auth.uid())
    or public.is_session_instructor(session_id, auth.uid())
  );

drop policy if exists "sp_instructor_update" on public.session_participants;

create policy "sp_instructor_update"
  on public.session_participants for update
  using (public.is_session_instructor(session_id, auth.uid()));

-- ---------- form_submissions ----------
drop policy if exists "fs_instructor_read" on public.form_submissions;

create policy "fs_instructor_read"
  on public.form_submissions for select
  using (public.is_session_instructor(session_id, auth.uid()));

drop policy if exists "fs_role_scoped_read" on public.form_submissions;

create policy "fs_role_scoped_read"
  on public.form_submissions for select
  using (
    status in ('submitted','approved','archived')
    and (
      '*' = any(visible_to_role_codes)
      or exists (
        select 1 from public.session_participants sp
        where sp.session_id = form_submissions.session_id
          and sp.user_id = auth.uid()
          and sp.role_code = any(visible_to_role_codes)
      )
    )
  );

-- ---------- events ----------
drop policy if exists "events_instructor_read" on public.events;

create policy "events_instructor_read"
  on public.events for select
  using (public.is_session_instructor(session_id, auth.uid()));

drop policy if exists "events_self_read" on public.events;

create policy "events_self_read"
  on public.events for select
  using (
    actor_user_id = auth.uid()
    and public.is_session_member(session_id, auth.uid())
  );
