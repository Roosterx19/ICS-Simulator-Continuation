-- Resources catalog + per-session resource orders + budget tracking on session_scores.
-- Mirrors the Resource/ResourceOrder model from the Base44 Virtual ICS Commander app.

create type public.resource_category as enum (
  'water_food','medical','fire','personnel','vehicles','heavy_equipment',
  'hazmat','communications','shelter','law_enforcement','military','cert'
);

create type public.resource_availability as enum ('easy','moderate','difficult','critical');

create type public.resource_order_status as enum ('requested','approved','deployed','demobilized');

create table public.resources_catalog (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category public.resource_category not null,
  unit_cost_cents bigint not null check (unit_cost_cents >= 0),
  unit text not null default 'each',
  availability public.resource_availability not null default 'moderate',
  description text,
  alternatives text[] not null default '{}',
  scenario_id uuid references public.scenarios(id) on delete set null,
  created_at timestamptz not null default now()
);

create index resources_catalog_category_idx on public.resources_catalog(category);
create index resources_catalog_scenario_idx on public.resources_catalog(scenario_id);

alter table public.resources_catalog enable row level security;

-- Catalog is readable to all authenticated users.
create policy "resources_catalog_read_authenticated"
  on public.resources_catalog for select
  to authenticated
  using (true);

create table public.resource_orders (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.sessions(id) on delete cascade,
  resource_id uuid not null references public.resources_catalog(id) on delete restrict,
  resource_name text not null,
  category public.resource_category not null,
  quantity integer not null check (quantity > 0),
  unit_cost_cents bigint not null check (unit_cost_cents >= 0),
  total_cost_cents bigint not null check (total_cost_cents >= 0),
  ordered_by uuid not null references auth.users(id) on delete restrict,
  ordered_by_role text,
  section text,
  operational_period integer not null default 1,
  status public.resource_order_status not null default 'requested',
  created_at timestamptz not null default now()
);

create index resource_orders_session_idx
  on public.resource_orders(session_id, created_at desc);

alter table public.resource_orders enable row level security;

create policy "resource_orders_read_participants"
  on public.resource_orders for select
  using (
    exists (
      select 1 from public.session_participants sp
      where sp.session_id = resource_orders.session_id
        and sp.user_id = (select auth.uid())
    )
  );

create policy "resource_orders_insert_self"
  on public.resource_orders for insert
  with check (
    ordered_by = (select auth.uid())
    and exists (
      select 1 from public.session_participants sp
      where sp.session_id = resource_orders.session_id
        and sp.user_id = (select auth.uid())
    )
  );

-- Budget tracking on session_scores
alter table public.session_scores
  add column if not exists spent_budget_cents bigint not null default 0;

-- Trigger: when a resource_order is inserted, bump spent_budget + resources_deployed.
create or replace function public.apply_resource_order_to_score()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.session_scores (session_id) values (new.session_id)
  on conflict (session_id) do nothing;

  update public.session_scores
  set
    spent_budget_cents  = spent_budget_cents + new.total_cost_cents,
    resources_deployed  = resources_deployed + new.quantity,
    updated_at          = now()
  where session_id = new.session_id;

  return new;
end;
$$;

create trigger resource_orders_apply_score
after insert on public.resource_orders
for each row execute function public.apply_resource_order_to_score();

-- Add to realtime publication so the budget HUD updates live.
alter publication supabase_realtime add table public.resource_orders;
alter publication supabase_realtime add table public.resources_catalog;
