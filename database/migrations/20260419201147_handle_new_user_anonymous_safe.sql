-- 20260419201147_handle_new_user_anonymous_safe.sql
-- Replaces handle_new_user() trigger function so anonymous Supabase users
-- (NULL email) don't crash auto profile creation. Trigger on_auth_user_created invokes this.
-- Source: supabase_migrations.schema_migrations (verbatim apply text)

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path to 'public'
as $function$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data->>'display_name',
      nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
      'Guest ' || substr(new.id::text, 1, 6)
    )
  );
  return new;
exception when others then
  return new;
end;
$function$;
