-- Port of Base44 CommandPath SimulationSession + SimulationDecision schemas.
-- Adds scoring, decision logging, and cognitive-framework tracking to ICS sessions.
-- Applied remotely as migration version 20260418 (see list_migrations).

-- Per-session aggregate game state (one row per session)
create table public.session_scores (
  session_id uuid primary key references public.sessions(id) on delete cascade,
  score integer not null default 0,
  max_score integer not null default 0,
  civilian_casualties integer not null default 0,
  resources_deployed integer not null default 0,
  span_of_control_violations integer not null default 0,
  decisions_made integer not null default 0,
  aar_grade text,
  current_phase text not null default 'warning',
  updated_at timestamptz not null default now()
);

alter table public.session_scores enable row level security;

create policy "session_scores_select_participants" on public.session_scores
  for select using (
    exists (
      select 1 from public.session_participants sp
      where sp.session_id = session_scores.session_id
        and sp.user_id = (select auth.uid())
    )
  );

create policy "session_scores_write_instructors" on public.session_scores
  for all using (
    exists (
      select 1 from public.profiles p
      where p.id = (select auth.uid()) and p.is_instructor = true
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = (select auth.uid()) and p.is_instructor = true
    )
  );

-- Cognitive-framework enum from CommandPath
create type public.cognitive_framework as enum ('Procedural','Computational','Analytical','Logical');

-- Per-decision log (append-only)
create table public.simulation_decisions (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.sessions(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role_code text references public.ics_roles(code),
  phase text not null,
  scenario_event text,
  decision_text text not null,
  option_chosen text,
  cognitive_framework public.cognitive_framework,
  points_earned integer not null default 0,
  max_points integer not null default 0,
  feedback text,
  consequence text,
  casualty_impact integer not null default 0,
  is_correct boolean,
  created_at timestamptz not null default now()
);

alter table public.simulation_decisions enable row level security;

create index simulation_decisions_session_created_idx
  on public.simulation_decisions(session_id, created_at desc);

create policy "simulation_decisions_select_participants" on public.simulation_decisions
  for select using (
    exists (
      select 1 from public.session_participants sp
      where sp.session_id = simulation_decisions.session_id
        and sp.user_id = (select auth.uid())
    )
  );

create policy "simulation_decisions_insert_self" on public.simulation_decisions
  for insert with check (user_id = (select auth.uid()));

-- Auto-create a session_scores row when a session is created
create or replace function public.create_session_scores()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.session_scores (session_id) values (new.id)
  on conflict (session_id) do nothing;
  return new;
end;
$$;

create trigger sessions_create_scores
after insert on public.sessions
for each row execute function public.create_session_scores();

-- Backfill scores for existing sessions
insert into public.session_scores (session_id)
select id from public.sessions
on conflict (session_id) do nothing;
