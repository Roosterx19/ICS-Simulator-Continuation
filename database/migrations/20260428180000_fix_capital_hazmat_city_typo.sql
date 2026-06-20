-- Fix copy-paste typo in the existing Capital City Hazmat Spill scenario.
--
-- The initial-briefing inject (sort_order=0, scenario 00000000-...-012)
-- carries the body line "Single IC from Central City FD." That's the
-- wrong city — this scenario is set in CAPITAL, not CENTRAL. The line
-- was copy-pasted from a Central City scenario when the hazmat scenario
-- was first authored.
--
-- The WHERE clause matches on body content so this migration is
-- idempotent — re-running it after the fix matches zero rows.

UPDATE public.scenario_injects
SET body = REPLACE(body, 'Single IC from Central City FD.', 'Single IC from Capital City FD.')
WHERE scenario_id = '00000000-0000-0000-0000-000000000012'
  AND sort_order = 0
  AND body LIKE '%Single IC from Central City FD%';
