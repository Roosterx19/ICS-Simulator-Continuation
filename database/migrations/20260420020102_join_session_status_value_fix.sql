-- 20260420020102_join_session_status_value_fix.sql
-- BUGFIX: join_session() compared sessions.status against the literal
-- 'completed' but the sessions_status_check CHECK constraint enforces
-- the enum values ['lobby','active','paused','complete'] — note the
-- singular 'complete' without -ed. The original gating clause was
-- effectively dead code; status='complete' would not block a join.
-- Smoke-tested 2026-04-20 with both completed_at-IS-NOT-NULL and
-- status='complete' paths after this fix; both now raise P0001.

create or replace function public.join_session(p_session_id uuid)
returns public.session_participants
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_participant public.session_participants;
  v_user_id uuid := auth.uid();
  v_completed_at timestamptz;
  v_status text;
begin
  if v_user_id is null then
    raise exception 'not authenticated' using errcode = '42501';
  end if;

  select completed_at, status
    into v_completed_at, v_status
    from public.sessions
    where id = p_session_id;

  if not found then
    raise exception 'session not found: %', p_session_id
      using errcode = 'P0002';
  end if;

  if v_completed_at is not null or v_status = 'complete' then
    raise exception 'session % is closed', p_session_id
      using errcode = 'P0001';
  end if;

  insert into public.session_participants
    (session_id, user_id, location_code, checked_in_at)
  values
    (p_session_id, v_user_id, 'staging', now())
  on conflict (session_id, user_id)
  do update set
    checked_in_at = excluded.checked_in_at,
    updated_at = now()
  returning * into v_participant;

  return v_participant;
end;
$$;
