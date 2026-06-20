-- 20260419193227_create_scenario_skyboxes.sql
-- Adds scenario_skyboxes table for AI-generated 360° HDRI backgrounds (Polyhaven-fed).
-- Source: supabase_migrations.schema_migrations (verbatim apply text, with one strip noted below)

create table if not exists public.scenario_skyboxes (
  id uuid primary key default gen_random_uuid(),
  scenario_id uuid references public.scenarios(id) on delete cascade,
  job_id text not null,
  prompt text not null,
  style text default 'realistic',
  status text default 'pending',
  file_url text,
  thumb_url text,
  -- NOTE: created_by is stored as plain uuid (no FK to auth.users).
  -- Cross-schema FKs from public to auth require superuser; the original
  -- MCP apply_migration call included `references auth.users(id)` but
  -- Supabase silently stripped it. Application code is responsible for
  -- ensuring created_by holds a valid auth.users.id.
  created_by uuid,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists idx_scenario_skyboxes_scenario on public.scenario_skyboxes(scenario_id);
create index if not exists idx_scenario_skyboxes_job on public.scenario_skyboxes(job_id);

alter table public.scenario_skyboxes enable row level security;

create policy "skyboxes_read_all"
  on public.scenario_skyboxes for select
  to authenticated
  using (true);

create policy "skyboxes_insert_own"
  on public.scenario_skyboxes for insert
  to authenticated
  with check (created_by = auth.uid());

create policy "skyboxes_update_own"
  on public.scenario_skyboxes for update
  to authenticated
  using (created_by = auth.uid());
