create table if not exists public.board_members (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references auth.users(id) on delete cascade,
  name text not null,
  role text,
  bio text,
  pros text[] default '{}',
  cons text[] default '{}',
  avatar_url text,
  email text,
  phone text,
  linkedin_url text,
  tags text[] default '{}',
  sort_order int default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists board_members_owner_idx on public.board_members(owner_id);

alter table public.board_members enable row level security;

create policy "owner can read own board members"
  on public.board_members for select
  using (auth.uid() = owner_id);

create policy "owner can insert own board members"
  on public.board_members for insert
  with check (auth.uid() = owner_id);

create policy "owner can update own board members"
  on public.board_members for update
  using (auth.uid() = owner_id);

create policy "owner can delete own board members"
  on public.board_members for delete
  using (auth.uid() = owner_id);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists board_members_set_updated_at on public.board_members;
create trigger board_members_set_updated_at
  before update on public.board_members
  for each row execute function public.set_updated_at();
