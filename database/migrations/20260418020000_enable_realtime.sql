-- Enable Supabase realtime for tables the live HUD subscribes to.
alter publication supabase_realtime add table public.session_scores;
alter publication supabase_realtime add table public.simulation_decisions;
alter publication supabase_realtime add table public.session_participants;
