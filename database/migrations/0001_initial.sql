-- ===================================================================
-- 0001_initial.sql
-- ICS Training Simulator — Phase 1 schema
--
-- Conventions:
--   * snake_case plural table names
--   * Every table has RLS enabled
--   * Every table has created_at / updated_at (except append-only logs)
--   * Timestamps: timestamptz, default now()
--   * IDs: uuid v4, default gen_random_uuid()
--   * All FKs explicit; cascade deletes for child-owned rows
--
-- Philosophy (see CLAUDE.md): ship the smallest schema that runs
-- Phase 1. Do not model Phase 2+ features here.
-- ===================================================================

-- -----------------------------------------------------------------
-- Extensions
-- -----------------------------------------------------------------
create extension if not exists "uuid-ossp";
create extension if not exists pgcrypto;

-- -----------------------------------------------------------------
-- Helper: updated_at trigger
-- -----------------------------------------------------------------
create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ===================================================================
-- profiles — extends auth.users, one row per user
-- ===================================================================
create table public.profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  display_name    text not null,
  default_discipline  text,  -- fire | ems | police | hazmat | pubworks | media | utility | cert | other
  avatar_config   jsonb not null default '{}'::jsonb,
  is_instructor   boolean not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute procedure public.touch_updated_at();

alter table public.profiles enable row level security;

create policy "profiles_self_read"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles_self_update"
  on public.profiles for update
  using (auth.uid() = id);

-- Instructors can read all profiles (to see rosters)
create policy "profiles_instructor_read_all"
  on public.profiles for select
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.is_instructor = true
    )
  );

-- Auto-create profile on auth.user insert
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1)));
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- ===================================================================
-- ics_roles — reference table, seeded
-- ===================================================================
create table public.ics_roles (
  code            text primary key,
  name            text not null,
  tier            text not null check (tier in (
                    'ic', 'command', 'section', 'branch',
                    'division', 'unit', 'leader', 'resource', 'agency'
                  )),
  section         text check (section in (
                    'COMMAND', 'OPS', 'PLAN', 'LOG', 'FIN', 'II'
                  )),
  reports_to_code text references public.ics_roles(code),
  color_token     text not null,
  sort_order      int not null default 0,
  description     text
);

alter table public.ics_roles enable row level security;

create policy "ics_roles_auth_read"
  on public.ics_roles for select
  to authenticated
  using (true);


-- ===================================================================
-- scenarios — seeded training scenarios (Capital City / Central City in Liberty County)
-- ===================================================================
create table public.scenarios (
  id                      uuid primary key default gen_random_uuid(),
  course_code             text not null check (course_code in (
                            'ICS300','ICS400','G191','0305','L101','L102','L103','L105'
                          )),
  unit_code               text,
  title                   text not null,
  city                    text not null check (city in ('CAPITAL','LIBERTY')),
  summary                 text,
  map_url                 text,
  initial_budget_cents    bigint not null default 0,
  operational_period_hours int not null default 12,
  delegation_letter_md    text,
  incident_type           int check (incident_type between 1 and 5),
  created_at              timestamptz not null default now()
);

alter table public.scenarios enable row level security;

create policy "scenarios_auth_read"
  on public.scenarios for select
  to authenticated
  using (true);


-- ===================================================================
-- sessions — one per live training session
-- ===================================================================
create table public.sessions (
  id                           uuid primary key default gen_random_uuid(),
  scenario_id                  uuid not null references public.scenarios(id),
  instructor_id                uuid not null references public.profiles(id),
  name                         text not null,
  status                       text not null default 'lobby'
                               check (status in ('lobby','active','paused','complete')),
  current_operational_period   int not null default 1,
  remaining_budget_cents       bigint not null default 0,
  started_at                   timestamptz,
  completed_at                 timestamptz,
  created_at                   timestamptz not null default now(),
  updated_at                   timestamptz not null default now()
);

create trigger sessions_updated_at
  before update on public.sessions
  for each row execute procedure public.touch_updated_at();

create index idx_sessions_instructor on public.sessions(instructor_id);

alter table public.sessions enable row level security;

create policy "sessions_participant_read"
  on public.sessions for select
  using (
    exists (
      select 1 from public.session_participants sp
      where sp.session_id = sessions.id and sp.user_id = auth.uid()
    )
    or instructor_id = auth.uid()
  );

create policy "sessions_instructor_write"
  on public.sessions for all
  using (instructor_id = auth.uid())
  with check (instructor_id = auth.uid());


-- ===================================================================
-- session_participants
-- ===================================================================
create table public.session_participants (
  id               uuid primary key default gen_random_uuid(),
  session_id       uuid not null references public.sessions(id) on delete cascade,
  user_id          uuid not null references public.profiles(id),
  role_code        text references public.ics_roles(code),
  location_code    text not null default 'classroom'
                   check (location_code in (
                     'classroom','staging','base','camp','icp','incident_site','eoc','invisible'
                   )),
  xy               jsonb,  -- { x, y } grid position, nullable in Phase 1
  checked_in_at    timestamptz,
  checked_out_at   timestamptz,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),

  unique (session_id, user_id),
  unique (session_id, role_code)  -- one role per session
);

create trigger session_participants_updated_at
  before update on public.session_participants
  for each row execute procedure public.touch_updated_at();

create index idx_sp_session on public.session_participants(session_id);
create index idx_sp_user on public.session_participants(user_id);

alter table public.session_participants enable row level security;

-- Read: anyone in the session can see everyone's role+location (for roster and 3D scene)
create policy "sp_session_members_read"
  on public.session_participants for select
  using (
    exists (
      select 1 from public.session_participants me
      where me.session_id = session_participants.session_id
        and me.user_id = auth.uid()
    )
    or exists (
      select 1 from public.sessions s
      where s.id = session_participants.session_id
        and s.instructor_id = auth.uid()
    )
  );

-- Insert: users add themselves to a session
create policy "sp_self_insert"
  on public.session_participants for insert
  with check (user_id = auth.uid());

-- Update: users update their own row only (role, location, xy)
create policy "sp_self_update"
  on public.session_participants for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- Instructors can update any participant row in their sessions (for forced moves, boots, etc.)
create policy "sp_instructor_update"
  on public.session_participants for update
  using (
    exists (
      select 1 from public.sessions s
      where s.id = session_participants.session_id
        and s.instructor_id = auth.uid()
    )
  );


-- ===================================================================
-- ics_form_templates — seeded; one row per form (ICS-201, etc.)
-- ===================================================================
create table public.ics_form_templates (
  code                  text primary key,  -- e.g. "ICS-201"
  name                  text not null,
  json_schema           jsonb not null,    -- zod-compatible JSON Schema
  required_signatures   text[] not null default '{}',  -- array of ics_roles.code
  visible_to_role_codes text[] not null default '{}',  -- '*' = everyone in session
  phase                 int not null default 1,
  created_at            timestamptz not null default now()
);

alter table public.ics_form_templates enable row level security;

create policy "ics_form_templates_auth_read"
  on public.ics_form_templates for select
  to authenticated
  using (true);


-- ===================================================================
-- form_submissions
-- ===================================================================
create table public.form_submissions (
  id                  uuid primary key default gen_random_uuid(),
  session_id          uuid not null references public.sessions(id) on delete cascade,
  template_code       text not null references public.ics_form_templates(code),
  operational_period  int not null,
  submitted_by        uuid not null references public.profiles(id),
  submitted_by_role   text references public.ics_roles(code),
  payload             jsonb not null default '{}'::jsonb,
  signatures          jsonb not null default '[]'::jsonb,
  status              text not null default 'draft'
                      check (status in ('draft','submitted','approved','rejected','archived')),
  rejection_reason    text,
  visible_to_role_codes text[] not null default '{}',  -- snapshot from template, or custom
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  submitted_at        timestamptz,
  approved_at         timestamptz
);

create trigger form_submissions_updated_at
  before update on public.form_submissions
  for each row execute procedure public.touch_updated_at();

create index idx_fs_session on public.form_submissions(session_id);
create index idx_fs_template on public.form_submissions(template_code);
create index idx_fs_submitted_by on public.form_submissions(submitted_by);

alter table public.form_submissions enable row level security;

-- Author can always read + edit their own drafts
create policy "fs_author_rw"
  on public.form_submissions for all
  using (submitted_by = auth.uid())
  with check (submitted_by = auth.uid());

-- Instructors read everything in their sessions
create policy "fs_instructor_read"
  on public.form_submissions for select
  using (
    exists (
      select 1 from public.sessions s
      where s.id = form_submissions.session_id
        and s.instructor_id = auth.uid()
    )
  );

-- Visible to roles in the visible_to_role_codes array
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


-- ===================================================================
-- events — append-only audit log; drives Phase 2 timeline + ICS-214
-- ===================================================================
create table public.events (
  id              uuid primary key default gen_random_uuid(),
  session_id      uuid not null references public.sessions(id) on delete cascade,
  type            text not null,
  actor_user_id   uuid references public.profiles(id),
  actor_role_code text references public.ics_roles(code),
  payload         jsonb not null default '{}'::jsonb,
  occurred_at     timestamptz not null default now()
);

create index idx_events_session on public.events(session_id, occurred_at desc);
create index idx_events_actor on public.events(actor_user_id);

alter table public.events enable row level security;

-- Instructors read all events in their sessions
create policy "events_instructor_read"
  on public.events for select
  using (
    exists (
      select 1 from public.sessions s
      where s.id = events.session_id and s.instructor_id = auth.uid()
    )
  );

-- Participants read their own events in sessions they're in
create policy "events_self_read"
  on public.events for select
  using (
    actor_user_id = auth.uid()
    and exists (
      select 1 from public.session_participants sp
      where sp.session_id = events.session_id and sp.user_id = auth.uid()
    )
  );

-- Inserts happen server-side only (service role), never from clients
-- No insert policy = no one can insert directly; route handlers use service role or SECURITY DEFINER funcs
