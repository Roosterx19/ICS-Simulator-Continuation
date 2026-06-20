-- 20260420014743_join_session_rpc.sql
-- Idempotent RPC that adds the current authenticated user to
-- session_participants when they enter a scenario. Server-side
-- validation of session joinability. Returns the participant row
-- so client can immediately render role/location state.
--
-- Called from app/(sim)/session/[id]/scenario/page.tsx (server component)
-- on page entry.
--
-- Survey notes (2026-04-20):
--  * sessions has both `status` (default 'lobby') and `completed_at` (nullable).
--    Both gating clauses included.
--  * session_participants_session_id_user_id_key UNIQUE (session_id, user_id)
--    already exists. ON CONFLICT works without adding a constraint.
--  * location_code CHECK enforces lowercase enum: 'classroom','staging','base',
--    'camp','icp','incident_site','eoc','invisible'. Using 'staging'.

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

  if v_completed_at is not null or v_status = 'completed' then
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

revoke all on function public.join_session(uuid) from public;
grant execute on function public.join_session(uuid) to authenticated;
