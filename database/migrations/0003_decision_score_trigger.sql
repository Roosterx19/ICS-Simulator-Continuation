-- Auto-update session_scores when a simulation_decisions row is inserted.
-- Idempotent per row: each decision contributes its points, max_points, casualty_impact,
-- increments decisions_made, and bumps span_of_control_violations when is_correct = false.

create or replace function public.apply_decision_to_score()
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
    score                       = score + coalesce(new.points_earned, 0),
    max_score                   = max_score + coalesce(new.max_points, 0),
    civilian_casualties         = civilian_casualties + coalesce(new.casualty_impact, 0),
    decisions_made              = decisions_made + 1,
    span_of_control_violations  = span_of_control_violations
                                    + case when new.is_correct = false then 1 else 0 end,
    updated_at                  = now()
  where session_id = new.session_id;

  return new;
end;
$$;

create trigger simulation_decisions_apply_score
after insert on public.simulation_decisions
for each row execute function public.apply_decision_to_score();
