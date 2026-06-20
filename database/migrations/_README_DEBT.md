# Pre-existing migration debt

As of 2026-04-19, the following migrations exist in the Supabase
production database but have no corresponding file in this directory.
They were applied before this repo started tracking migrations in git.

| Applied At | Migration Name | Schema Impact |
|---|---|---|
| 20260418204116 | add_central_city_and_injects_v2 | unknown — needs reconstruction |
| 20260419053820 | single_ic_scenario_and_injects | unknown — needs reconstruction |
| 20260419054532 | complex_im_scenario_and_injects | unknown — needs reconstruction |
| 20260419055449 | eoc_phoenix_scenario | unknown — needs reconstruction |
| 20260419061401 | liberty_city_scenarios | unknown — needs reconstruction |
| 20260419062253 | remaining_scenario_injects | unknown — needs reconstruction |
| 20260419062912 | final_master_scenario_injects | unknown — needs reconstruction |
| 20260419125512 | tutorial_and_remaining_injects | unknown — needs reconstruction |

Backfilled (verbatim DDL recovered from
`supabase_migrations.schema_migrations.statements`):

| Applied At | Migration Name | File | Backfilled |
|---|---|---|---|
| 20260418210944 | hseep_aar_observations | `20260418210944_hseep_aar_observations.sql` | 2026-04-27 |
| 20260419132058 | improvement_plan_tracking | `20260419132058_improvement_plan_tracking.sql` | 2026-04-27 |
| 20260418214109 | add_command_type_to_sessions | `20260418214109_add_command_type_to_sessions.sql` | 2026-04-28 |
| 20260419135611 | presence_tracking | `20260419135611_presence_tracking.sql` | 2026-04-28 |
| 20260419133324 | score_for_form_submission | `20260419133324_score_for_form_submission.sql` | 2026-04-28 |
| 20260419130534 | user_scenario_completions | `20260419130534_user_scenario_completions.sql` | 2026-04-28 |

The verbatim SQL for each of these IS recoverable from
`supabase_migrations.schema_migrations.statements` in the production DB,
which is what we used to backfill the 5 migrations on 2026-04-19/20
(see the `2026041919xxxx` and `2026042000xxxx` files in this directory).

TODO (tracked separately, not blocking current work):
- [ ] Reconstruct schema DDL from current DB state
- [ ] Decide on seed-data strategy (dump and commit, or regenerate via script)
- [ ] Verify against a clean `supabase db reset` locally

Do NOT attempt to reconstruct without reading this entire document and
discussing with the team. Hasty reconstruction will create migrations
that don't match what actually ran, which is worse than no migration.
