-- Add command_type to sessions.
--
-- Backfilled 2026-04-28. Version 20260418214109 was applied to the
-- production database via MCP on 2026-04-18 without writing the
-- corresponding .sql file. The DDL below is the verbatim text recovered
-- from supabase_migrations.schema_migrations.statements on the live DB,
-- so a fresh `supabase db reset` (or any clean-clone deploy) creates
-- the same column + CHECK constraint that production already has.
--
-- DO NOT MODIFY — this is a historical record. Schema changes should
-- land in a new dated migration after this one.

ALTER TABLE public.sessions
  ADD COLUMN IF NOT EXISTS command_type text NOT NULL DEFAULT 'single_ic'
  CHECK (command_type IN ('single_ic','unified_command','complex_im','eoc'));
