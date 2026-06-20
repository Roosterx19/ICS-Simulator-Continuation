create table if not exists public.assets_manifest (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references auth.users(id) on delete cascade,
  app_slug text not null,
  kind text not null check (kind in ('model','animation','texture','rig','audio','other')),
  source text check (source in ('unity','blender','mixamo','manual','other')),
  name text not null,
  bucket text not null,
  storage_path text not null,
  file_format text,
  size_bytes bigint,
  tags text[] default '{}',
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (bucket, storage_path)
);

create index if not exists assets_manifest_owner_idx on public.assets_manifest(owner_id);
create index if not exists assets_manifest_app_kind_idx on public.assets_manifest(app_slug, kind);

alter table public.assets_manifest enable row level security;

create policy "owner read assets" on public.assets_manifest for select using (auth.uid() = owner_id);
create policy "owner write assets" on public.assets_manifest for insert with check (auth.uid() = owner_id);
create policy "owner update assets" on public.assets_manifest for update using (auth.uid() = owner_id);
create policy "owner delete assets" on public.assets_manifest for delete using (auth.uid() = owner_id);

drop trigger if exists assets_manifest_set_updated_at on public.assets_manifest;
create trigger assets_manifest_set_updated_at
  before update on public.assets_manifest
  for each row execute function public.set_updated_at();

insert into storage.buckets (id, name, public)
values
  ('assets-models', 'assets-models', false),
  ('assets-animations', 'assets-animations', false),
  ('assets-textures', 'assets-textures', false)
on conflict (id) do nothing;

create policy "owner read own model files"
  on storage.objects for select to authenticated
  using (bucket_id = 'assets-models' and owner = auth.uid());

create policy "owner upload own model files"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'assets-models' and owner = auth.uid());

create policy "owner read own animation files"
  on storage.objects for select to authenticated
  using (bucket_id = 'assets-animations' and owner = auth.uid());

create policy "owner upload own animation files"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'assets-animations' and owner = auth.uid());

create policy "owner read own texture files"
  on storage.objects for select to authenticated
  using (bucket_id = 'assets-textures' and owner = auth.uid());

create policy "owner upload own texture files"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'assets-textures' and owner = auth.uid());
