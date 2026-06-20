# Rally Point — Session Handoff

Last updated: 2026-04-26 UTC
Active machine: MacBook (`~/ics-sim-prep`)
HEAD: `d62b504` (after this commit lands; previous `0b4500a` was the last code commit)

## Where we left off

**Just finished:** Phase C3 Part 5 (facility identification system) plus the
Gemini round-2 bug triage (5 bugs reported, 4 fixed in code, 1 diagnostic
only). Awaiting browser hard-reload + DevTools console capture for Bug 1
verification before the diagnostic `console.log` inside `FacilityLogo`
gets reverted.

**Next up:** User does the Part 5 reload + Bug-1 console paste. Based on
the console output, we either:
  - Confirm logo mapping is correct (most likely — code inspection shows
    no bug; suspected stale browser cache from a long-running dev server),
    revert the diagnostic, and move on; OR
  - Find the actual mapping bug from the console data and fix it.

After that, the floating-buildings shadow polish pass should be visibly
better thanks to the Bug 4 fix (expanded shadow camera bounds + new
PlayerBlobShadow). If the user wants further polish, that's the next
likely chunk.

## Current state of the repo

- Branch: `main`
- HEAD: `d62b504` `docs: backfill afk-session-log for today's Part 5 + bug fix session`
- Working tree clean.
- Local in sync with `origin/main` (push --dry-run: "Everything up-to-date").

## Last 15 commits

```
d62b504  docs: backfill afk-session-log for today's Part 5 + bug fix session
0b4500a  fix(scene): expand shadow camera bounds + add player blob shadow
c407697  fix(player): modulate walk timeScale to match world translation speed
2048c48  fix(facility): raise hospital rooftop sign Y from 72 to 105
c785989  diag(facility): log per-cell category → spec mapping in FacilityLogo
3cfe1ea  feat(facilities): add Liberty County Public Health Department at Nelson Center
c1725a8  fix(facilities): correct Nelson Center address from N15 to FF & 11th per ESSD
cd1c213  docs(geography): fix Capital City county reference
1d22614  feat(facility): color-code + logos + hospital rooftop signs       ← Phase C3 Part 5
a5876b7  fix(scene): street sign backfaces + camera far/fog at max zoom
b1a5d58  fix(scene): native wheel listener + non-billboard street signs
8237d9b  fix(scene): camera nav, road z-fight, street sign geometry
93a0da6  fix(camera): unlock OrbitControls pan
68168d4  feat(scene): render StreetSigns at sampled grid intersections     ← Phase C3 Part 4
2e67be1  feat(data): add street-names.ts for Central City grid             ← Phase C3 Part 3
```

## What's running

- **Dev server:** stopped (last PID 59352 from 2026-04-24 was killed during the doc backfill build pass — needs a fresh `npm run dev -- -H 0.0.0.0` before the user reloads).
- **Supabase:** unchanged. Project `vojsxvnlpfcppuqzsure`. 32 migrations applied; 18 on disk (the 14-migration "Bucket A debt" from earlier sessions is unchanged — pre-today, not new).
- **Vercel:** **all 20 most recent production deployments in `ERROR` state**, including every commit since `0414269` (2026-04-22). Auto-deploy IS firing on every push; the build itself is failing on Vercel's side. Local `npm run build` passes clean — failure is environmental (missing env vars, Node version, memory limit, etc.). On the RED list — flagged but NOT remediated. Needs a separate diagnostic session reading the Vercel build logs once the user authorizes.
- **Base44 (BoardOS):** untouched.

## Outstanding / queued work

| Item | State | Notes |
|---|---|---|
| Part 5 reload + Bug-1 console capture | **pending user** | Browser hard-reload, filter DevTools console for `[FacilityLogo]`, paste sample lines. |
| Revert Bug-1 diagnostic console.log | queued | Revert as soon as Bug 1 is confirmed working OR the bug is found and fixed. |
| Bug 3 `NATURAL_STRIDE_RATE` tuning | queued | Set to 0.85 heuristic. If feet still slide, drop the const to speed up animation; if feet over-step, raise. |
| Vercel ERROR investigation | **blocked (RED list)** | Production has been failing since at least 2026-04-21. Auth needed before remediation. |
| Alethe Smith FQHC seeding | **blocked (PDF sync)** | User's `essd_print.pdf` not in repo. My copy of ESSD (`central_city_manual.pdf`, 781 pages, Dec 2015 v3.0) returns zero hits via `pdftotext -raw`, `pdftotext -layout`, and `strings` on the binary for "alethe", "FQHC", or "LCPHD". Needs `docs/source/essd_print.pdf` placed for cross-verification. |
| Other Nelson Center tenants (DHS, ME, EMS director) | optional follow-up | All ESSD-documented at FF & 11th. Trivial commit when desired. |
| Maps widget (`Minimap` vestigial) | optional | Pre-FEMA-grid 12-zone hardcoded schematic. Either retire or rebuild as top-down view of the actual Central City grid. |
| `supabase/migrations/_README_DEBT.md` Bucket A | tracked | 14 pre-today migrations applied via MCP without disk capture. Not blocking. |

## Key context for the next pickup

- **FEMA grid scale**: 100 world units / block, 45×42 grid (4500×4200 world units). Character spawn at M17 (downtown, near M15 signature skyscraper + Nelson Center cluster — moved from F18 because at this scale F18 was 762 units from the nearest building, off-screen for the follow camera).
- **Reserved colors**: `#c0392b` (FACILITY_RED) is fire-only; `#2c3e50` (FACILITY_BLUE) is police-only. Grep audit at `lib/sim/facility-colors.ts` and `facility-logos.ts`. Don't reuse for other categories.
- **Nelson Center is at FF & 11th** (per ESSD App I.2), not N15. Multi-tenant civic complex: Sheriff's Animal Shelter, Liberty County Public Health Department, Department of Human Services (not yet seeded), Medical Examiner (not yet seeded), EMS director (not yet seeded).
- **The 4 main hospitals** (Central City Hospital D&31, Columbia VA J&7, Faith S&14, Levine MM&17) are flagged `mainScenarioFacility: true`. Only these get rooftop HOSPITAL signs. Sign Y is now 105 (was 72) so it clears the tallest civic-pool building (`building-m` at 95u).
- **Capital City is in Pine County**, not Hamilton. Geography doc fixed in commit `cd1c213` if you ever build the Capital City map.
- **Hard process rule**: always stop the dev server before running `npm run build`. They share `.next/` and trample each other (cost us a session-long debug detour earlier).

## Bringing it back up

```bash
cd ~/ics-sim-prep
git pull origin main                       # should be up to date
git status                                  # confirm clean
node --version                              # expect v20+
ls .env.local && echo OK                    # confirm env present
nohup npm run dev -- -H 0.0.0.0 > /tmp/dev-server.log 2>&1 &
# wait for "Ready in" then:
curl -sI http://localhost:3000/login | head -1   # expect HTTP/1.1 200 OK
```

LAN URL for phone testing: `http://192.168.135.90:3000` (last known IPv4 — recheck with `ipconfig getifaddr en0` if reconnecting on a different network).

## RED-LIST reminders (carry forward)

- Force-push, rebase, destructive SQL, framework upgrades, `.env*` edits, anything in `~/Desktop/Legal Proof/` — explicit user approval required.
- Vercel deployments are failing but **NOT to be remediated without authorization**.
- ESSD authenticity rule: never seed facility names/addresses that don't appear in the user's PDF copy. When a quote can't be verified locally, flag rather than fabricate. (Has saved us from 3+ fabrication attempts this session.)
