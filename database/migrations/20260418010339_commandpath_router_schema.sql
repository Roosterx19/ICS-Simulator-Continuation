create table if not exists public.cmdpath_agents (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references auth.users(id) on delete cascade,
  name text not null,
  description text not null,
  system_prompt text,
  model text default 'claude-opus-4-7',
  provider text default 'anthropic',
  capabilities text[] default '{}',
  enabled boolean default true,
  priority int default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists cmdpath_agents_owner_idx on public.cmdpath_agents(owner_id);

create table if not exists public.cmdpath_conversations (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references auth.users(id) on delete cascade,
  prompt text not null,
  routed_agent_id uuid references public.cmdpath_agents(id) on delete set null,
  routing_reason text,
  response text,
  tokens_in int,
  tokens_out int,
  latency_ms int,
  created_at timestamptz default now()
);

create index if not exists cmdpath_conversations_owner_idx on public.cmdpath_conversations(owner_id);
create index if not exists cmdpath_conversations_agent_idx on public.cmdpath_conversations(routed_agent_id);

alter table public.cmdpath_agents enable row level security;
alter table public.cmdpath_conversations enable row level security;

create policy "owner read agents" on public.cmdpath_agents for select using (auth.uid() = owner_id);
create policy "owner write agents" on public.cmdpath_agents for insert with check (auth.uid() = owner_id);
create policy "owner update agents" on public.cmdpath_agents for update using (auth.uid() = owner_id);
create policy "owner delete agents" on public.cmdpath_agents for delete using (auth.uid() = owner_id);

create policy "owner read conv" on public.cmdpath_conversations for select using (auth.uid() = owner_id);
create policy "owner write conv" on public.cmdpath_conversations for insert with check (auth.uid() = owner_id);

drop trigger if exists cmdpath_agents_set_updated_at on public.cmdpath_agents;
create trigger cmdpath_agents_set_updated_at
  before update on public.cmdpath_agents
  for each row execute function public.set_updated_at();
