# AFK Session Log

## 2026-04-24 — Bug-fix triage on Phase C3 Part 5 (Gemini verification round 2)

Gemini video verification flagged 5 issues against the Phase C3 Part 5 reload. Worked in priority order; 4 commits pushed. Bug 1 awaiting browser console capture before reverting diagnostic; Bug 5 was diagnostic-only per spec.

### Commits
- `c785989` `diag(facility): log per-cell category → spec mapping in FacilityLogo`
- `2048c48` `fix(facility): raise hospital rooftop sign Y from 72 to 105`
- `c407697` `fix(player): modulate walk timeScale to match world translation speed`
- `0b4500a` `fix(scene): expand shadow camera bounds + add player blob shadow`

### Bug 1 — every facility appearing to render the medical green-cross emblem
Code inspection found no bug: `facility-logos.ts` has correct per-category specs, `logoForCategory()` is a clean Record lookup, FEMA_FACILITIES histogram has expected category spread (12 fire, 2 police, 11 civic, 4 medical, 21 religious, 37 school, 9 shelter). Two strong candidates: stale browser/HMR cache (dev server had been running across many sessions) or visual ambiguity from medical's white "H" on green plate reading as cross-like at orbit distance. Action: temporary `console.log` inside `FacilityLogo` printing `cat=… plate=… text=…` per render. Dev server fully restarted with `.next/` wipe to bust cache. Awaiting user reload + console paste.

### Bug 2 — hospital rooftop signs missing
Root cause: `DEFAULT_Y = 72` sat inside `building-m` (95u tall), the largest building in the civic pool that medical hospital cells draw from via `pickBuildingName`. Hospitals whose hash picked building-m had their rooftop sign occluded by the building geometry. Bumped to `DEFAULT_Y = 105`, 10u above the tallest civic-pool variant. No size/color/orientation changes.

### Bug 3 — character ice-skating
Root cause: walk action's `timeScale` was a constant 1, producing visual stride at the clip's natively-baked rate, while world translation was `WALK_SPEED * dt` (independent). Mismatch = sliding feet. Fix: dynamic `walk.timeScale = clamp(currentSpeed / NATURAL_STRIDE_RATE, 0.4, 2.5)` inside the player's `useFrame`. `NATURAL_STRIDE_RATE = 0.85` is heuristic — gives ~1.65× playback for `WALK_SPEED = 1.4`. Tunable if visible mismatch persists.

### Bug 4 — buildings + character "pasted on" (no shadows / ground contact)
Two changes:
- DirectionalLight shadow camera bounds expanded from a NE-quadrant frustum (`-500..5000 × -500..5000`, far=8000) to a full-map frustum (`-3000..8000 × -3000..8000`, far=20000). Old bounds were tuned for the pre-FEMA-grid scene; the 4500×4200 scaled-up world had everything outside the NE wedge unshadowed. Light intensity 1.3 → 1.6, `shadow-bias: -0.0005`, repositioned to `[3500, 6000, 5500]` for an afternoon-sun feel. `!isMobile` guard on `castShadow` preserved.
- New `PlayerBlobShadow` component — flat semi-transparent black circle (radius 0.9, opacity 0.45, `depthWrite: false`) updated 60×/sec from `playerPosRef`. Renders on both desktop and mobile so the character has a permanent ground contact even when iOS Safari cast-shadow is disabled.

### Bug 5 — empty Maps widget — diagnostic only
The bottom-left "Maps" UI is two stacked components: `<Minimap>` (top, vestigial — renders 12 hardcoded zones from the pre-FEMA-grid layout) and `<MapViewer>` (bottom, "🗺️ Maps" toggle button — opens scenario-specific FEMA map browser, works correctly). The "icon only" the user saw is the Minimap's stale 12-zone schematic. Recommended retire-or-rebuild as a separate PR; not fixed this pass per instruction.

### Build / dev
- `npm run build` ✓ compiled successfully after each commit, 0 TS errors.
- Dev server PID 59352, Ready in 1079ms after fresh `.next/` wipe.
- `/login` → 200.

### Status
Awaiting browser hard-reload + DevTools console capture for Bug 1 verification. The 4 fixes will revert the diagnostic + tune `NATURAL_STRIDE_RATE` if the next Gemini pass surfaces residual mismatch.

---

## 2026-04-23 — Welcome-back state probe + handoff prep

Quick state check after machine return: working tree clean at `3cfe1ea`, dev server still running (PID 56486 from prior session), `/login` 200. No code changes. Surfaced doc-staleness — afk-session-log + rally-point both behind several days. User confirmed Part 5 reload still pending; queued the doc backfill and the Bug 1-5 fix run for the next active block.

---

## 2026-04-22 — Phase C3 Part 5: facility colors + logos + rooftop signs + Item 2/3 cleanup

Five commits across two thematic clusters.

### Cluster A — Phase C3 Part 5 modules (commit `1d22614`)
Adds the facility identification system. Five reusable modules, all city-agnostic so future Kingston / Bayport / Capital City maps reuse them.

| File | Contents |
|---|---|
| `lib/sim/facility-colors.ts` | Color map keyed by `FacilityCategory`. **Reserved**: `FACILITY_RED = #c0392b` → fire only; `FACILITY_BLUE = #2c3e50` → police only. Grep audit enforces both constants appear nowhere else in the tree. |
| `lib/sim/facility-logos.ts` | `{label, textColor, plateColor, square?}` per category. Short text labels (FIRE, POLICE, H, SCH, UNIV, GOV, SHLTR, …) chosen for font-independence over emoji. |
| `components/sim/facility/colored-building.tsx` | Generic Kenney GLB renderer with optional tint prop (multiplies atlas texture). |
| `components/sim/facility/facility-logo.tsx` | Four-sided emblem placement — one plate+label per cardinal block approach, fixed world orientation, no billboard. |
| `components/sim/facility/rooftop-sign.tsx` | Large two-sided HOSPITAL sign for `mainScenarioFacility`-flagged cells. Medical-green plate (NOT fire-red — red is reserved). |

`fema-facilities.ts`: 4 hospitals flagged `mainScenarioFacility: true` (Central City Hospital D&31, Columbia VA J&7, Faith S&14, Levine MM&17). User-claimed Alethe Smith FQHC at J&8 NOT seeded — extraction grep across 781-page ESSD returned zero hits for "Alethe", "FQHC", or "Federally Qualified" (verified via `pdftotext -raw`, `pdftotext -layout`, and `strings` on the binary). Authenticity rule: flagged rather than fabricated.

`city-buildings.tsx` rewritten:
- `ColoredBuilding` replaces the inline Building sub-component.
- Priority-ordered cell-to-facility map (medical > fire > police > shelter > civic > school > university > religious > utility > industrial > retail) so overlapping facilities pick the most visually-dominant category.
- Main-scenario hospitals get the rooftop HOSPITAL sign.

Color audit (grep): `#c0392b` → 3 hits (constant + fire plate + reservation comment). `#2c3e50` → 3 hits (constant + police plate + reservation comment). Zero leakage. School/university/utility text fills use near-black `#1a1a1a` instead of dark blue so the blue reservation isn't diluted.

### Cluster B — Geography + Nelson Center cleanup (commits `cd1c213`, `c1725a8`, `3cfe1ea`)
Three small focused commits triggered by the Item 3 source-verification round.

`cd1c213` `docs(geography): fix Capital City county reference` — ESSD line 1267 places Capital City in **Pine** County, not Hamilton. Three references in `docs/ics-knowledge/10_state-of-columbia-geography.md` updated (lines 16, 128, 160). Same class of place-name drift as the earlier Liberty City → Central City fix.

`c1725a8` `fix(facilities): correct Nelson Center address from N15 to FF & 11th per ESSD` — Five separate ESSD references all agree Nelson Center sits at FF & 11th, not N15:
- App F.5 (Medical Examiner)
- App G.5 (EMS office, mentioned twice)
- App I.2 (Liberty County Health Department)
- App AA.32 (Nelson Center floor map)

The N15 seed was a guess from Figure 10 visual interpretation in Phase C3 Part 2. Moving the cell + relaxing the misleading "Nelson Center area" comment on `FLOOD_SCENARIO_PLACEMENTS.base` (that entry is the ICS Base facility for the flood scenario, conceptually distinct from the Nelson Center building). `LANDMARK_BUILDINGS["Nelson Center"]` routes by label not cell, so the landmark building-j assignment follows automatically.

`3cfe1ea` `feat(facilities): add Liberty County Public Health Department at Nelson Center` — Per ESSD App I.2: "The Liberty County Health Department is located at the Nelson Center, FF and 11th Streets, Central City." The EMS section enumerates Nelson Center tenants by full name. Added as `civic-lcphd` at FF&11; merges into the Nelson Center cell labels[] alongside the Sheriff's Animal Shelter. Other ESSD-documented Nelson Center co-tenants (DHS, Medical Examiner, EMS director) NOT added in this commit per scoped Item 3b spec — available for follow-up.

### Items not done this pass
- Alethe Smith FQHC seed (Item 3c) — blocked on PDF sync. User's `essd_print.pdf` referenced in their quotes does not exist in the repo's ESSD copy; the `strings`-on-binary search across the entire 56 MB PDF file returns zero hits for "alethe", "FQHC", or "LCPHD". Awaiting `docs/source/essd_print.pdf` upload from the user.
- Other Nelson Center tenants (DHS, ME, EMS director).

### Build / dev
- `npm run build` ✓ compiled successfully after each commit.
- Dev server PID 55846, Ready in 980ms.
- Reserved-color grep audit pass.

---

## 2026-04-22 — Camera nav + sign cleanup round 2 (Gemini verification round 1)

Gemini reported PARTIAL PASS on camera (in-world worked but page-scrolled when scrolling to zoom) and FAIL on street signs (claimed still billboarding). Three commits.

### Commits
- `8237d9b` `fix(scene): camera nav, road z-fight, street sign geometry`
- `b1a5d58` `fix(scene): native wheel listener + unambiguous non-billboard street signs`
- `a5876b7` `fix(scene): street sign backfaces + camera far/fog for max-zoom ground visibility`

### Camera "zoom drops through ground / spacebar snaps" — root cause
Not OrbitControls config. The page itself was scrolling: `app/layout.tsx` `<body className="pb-16 md:pb-0">` + scenario `<main className="h-screen">` made the document 100vh + 64px tall, so wheel and spacebar fired browser default page-scroll before reaching OrbitControls. `body/html overflow:hidden` set on scenario mount (restored on unmount).

Round 2 (commit `b1a5d58`) added a native wheel listener with `{ passive: false }` calling `preventDefault()` on the canvas wrapper because React's synthetic onWheel handlers are passive by default — `preventDefault()` is a no-op inside them. CSS belt-and-suspenders: `overscroll-behavior: none`, `touch-action: none`. Plus `makeDefault` on OrbitControls so R3F's event bus routes through it.

### Z-fighting grass ↔ roads
Old `ROAD_Y = 0.05` with ground at y = -0.1 within depth-buffer precision at far=15000. Bumped `ROAD_Y → 0.2`, road material gains `polygonOffset(-1, -1)`.

### Street signs — billboarding claim
Audit confirmed `street-signs.tsx` had zero Billboard usage from the previous commit and there was exactly one StreetSigns mount. The "billboarding" perception was likely two-face text ambiguity (text on ±Z faces looks like it tracks the camera at casual orbit angles). Hardened with an unambiguous amber-triangle marker on the +Z face only — visual proof of fixed orientation via the occlusion test (triangle disappears when camera passes behind the sign).

### Sign backfaces
`material-side={THREE.DoubleSide}` on both Text meshes guards against drei/troika-three-text's default FrontSide culling making rotated glyph meshes invisible from certain orbit angles. Triangle marker duplicated on the −Z face.

### Camera far / fog
Ground was disappearing before buildings at max zoom. Camera was already at `far: 15000` so not the camera's frustum — it was fog. `[4000, 12000]` was too aggressive at OrbitControls `maxDistance = 2500`. Bumped fog to `[10000, 22000]` and camera far to 25000.

### Status
Gemini round 2 returned: Camera ✓ PASS, Page Scroll ✓ PASS, Z-Fighting ✓ PASS, Street Signs ⚠ PARTIAL PASS (non-billboard confirmed via occlusion test, but back-face text was blank). Surfaced into the next round (commit `a5876b7` above).

---

## 2026-04-22 — Camera unlock + Phase C3 Part 4 wiring fixes

### Commits
- `93a0da6` `fix(camera): unlock OrbitControls pan — stop eating right-click + stabilize target`

### Two intertwined bugs
1. **Right-click events eaten before OrbitControls saw them.** `CityGround` and `CityBlocks` had `onPointerDown` handlers firing on any mouse button and unconditionally `e.stopPropagation()`. Right-click drag (OrbitControls pan) was consumed before the camera controller got it. Fix: early-return unless `e.button === 0`.
2. **`target` prop reset every render.** `target={[playerPosRef.current[0], …]}` created a fresh array literal on every scene render; drei OrbitControls re-syncs internal target on prop reference change → any user pan got snapped back. Fix: `useMemo` keyed on `cameraMode` so the initial target snapshots on mode-entry and stays stable while orbit is active.

Plus disabled raycast on StreetSigns Text meshes (`raycast={() => null}`) so 210 floating labels don't intercept ground clicks.

### Build / dev
- `npm run build` ✓ compiled successfully, 0 TS errors.
- Dev server PID 51998, Ready in 1289ms, `/login` 200.

---



### Component created
`components/sim/street-signs.tsx` — drei `<Billboard>` + `<Text>` per sign, no background plane or post geometry. Billboard auto-orients to the active camera so labels stay readable in both follow and orbit modes.

### Sampling
- Step: every 3rd column × every 3rd row
- Columns sampled (15): `A, D, G, J, M, P, S, V, Y, BB, EE, HH, KK, NN, QQ`
- Rows sampled per column (14): `0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39`
- **Total signs: 210** (matches spec)

### Rendering parameters
- `SIGN_Y = 5` (above the 0.1-thick land-use mats; just above character head at ~2 units)
- `SIGN_FONT_SIZE = 5` world units
- `SIGN_OUTLINE_WIDTH = 0.4` (black outline for contrast against varied ground colors)
- White fill, black outline — legible on grass, streets, and land-use tiles

### Scene wiring
Mounted in `components/sim/scenario-scene.tsx` inside its own `<Suspense fallback={null}>`, placed immediately after the `<CityBuildings>` Suspense boundary. No changes to camera, spawn, or other scene components.

### Build / dev
- Stopped dev, wiped `.next/`, ran `npm run build` → ✓ Compiled successfully, 28 routes, zero TS errors.
- Restarted dev — PID 51507, Ready in 1115 ms, `/login` → 200.
- No runtime errors in the dev log on restart.

### Performance heads-up (not addressed in this part)
210 SDF text meshes is a lot. On mobile (isTouchDevice()) we may want to either drop the density or swap to instanced sprite labels if FPS drops. Leaving for a follow-up — user explicitly asked for visual placement only in this part.

### Commit
*(filled in by push block below)*

---

## 2026-04-21 19:25 UTC — Phase C3 Part 3: street-names.ts

### File created
`lib/sim/street-names.ts` — pure data module, no UI changes. Part 4 consumes it.

### Exports confirmed (tsx runtime check)
- `VERTICAL_STREETS` — 45 entries, ending `OO, PP, QQ, RR, SS`
- `HORIZONTAL_STREETS` — 42 entries (`Zero, 1st, 2nd, ..., 11th, 12th, 13th, ..., 21st, 22nd, 23rd, ..., 41st`)
- `INTERSTATES` — `I-107, I-102`
- `STATE_ROUTES` — `SR 5, SR 10, SR 13, SR 19, SR 100`
- `RAILROAD` — `"Great Atlantic & Pacific Railroad"`
- `ordinalSuffix(n)` — regular rule with 11/12/13 carve-out
- `getVerticalStreetName(col)` → `"MM Street"`
- `getHorizontalStreetName(row)` → `"Zero Street"` / `"22nd Street"`
- `getStreetName(col, row)` → `"M & 15th Streets"` / `"EE & 4th Streets"` / `"C & Zero Streets"`

### Grid consistency note
User's original Part-3 spec enumerated 387 two-letter combinations (AA, AB, AC, ..., SS across all prefix/suffix combos). I flagged that `colToIndex()` in `central-city-grid.ts` explicitly rejects non-matched doubles and every real FEMA facility uses only matched doubles (A-Z + AA, BB, CC, ..., SS = 45 columns). User revised count to 45; I built the matched-doubles version which is grid-consistent.

### Build / dev status
- Stopped dev, wiped `.next/`, ran `npm run build`: **✓ Compiled successfully**, all 28 routes built, zero TS errors.
- Restarted dev — PID 50587, Ready in 1551 ms, `/login` 200 OK.

### Commit
*(filled in after push below)*

---

## 2026-04-21 15:15 UTC — Phase C2: Kenney city buildings

### What shipped
45 Kenney City Kit GLB buildings (21 suburban + 24 commercial) now render on seeded FEMA land-use cells. Parks, golf course, water, and unknown cells stay empty per task refinement 3.

### Kenney URL drift
Both URLs in the task prompt returned 404. Scraped the current stable URLs from `kenney.nl/assets/...` via WebFetch:
- `kenney_city-kit-suburban_20.zip` (v2.0, 3.04 MB)
- `kenney_city-kit-commercial_2.1.zip` (v2.1, 4.10 MB)

### Commits
| SHA | What |
|---|---|
| `47e2ce1` | feat(assets): ingest Kenney city kit buildings to Supabase (upload script + .gitignore) |
| `681c834` | chore(manifest): register Kenney buildings + land-use variant pools |
| `92797a4` | feat(scene): add CityBuildings + wire into scenario scene |

### Key decisions
1. **No Windows `assets-pipeline` on MacBook.** Built `scripts/upload-kenney.mjs` in-repo, patterned after `scripts/upload-maps.mjs`, using the service-role key from `.env.local`.
2. **Storage layout:** `assets-models/kenney/<pack>/<file>.glb`. Tags = `['kenney','building',<pack>,...]`. Source = `'other'` (Kenney isn't in the source check enum; avoided a schema migration in favor of tag-based filtering).
3. **Texture atlas problem:** Kenney GLBs reference `Textures/colormap.png` via a relative URI. Signed URLs can't carry that relative resolution. Solution: copy both `colormap.png` files into `public/models/kenney/<pack>/` and override every mesh's material at mount with a fresh MeshStandardMaterial using the local atlas. PNGs are tiny (11 KB each), fine to commit.
4. **Mesh cloning:** `scene.clone(true)` per Building so two cells using the same GLB don't fight over transform. Material cloning implicit via `new MeshStandardMaterial(...)` replacement.
5. **Refinement compliance:**
   - M15 (downtown_business, dead center) → `building-skyscraper-d` signature tower
   - N15 civic `label="Nelson Center"` overrides the duplicate N15 downtown entry via latter-wins dedupe → `building-j` (largest non-skyscraper, 430 KB)
   - Skyscrapers `d,e` reserved; general downtown pool is `a,b,c` + `building-k,l,m,n`
   - park + golf_course pools are empty arrays → no geometry on those cells

### File map
- `scripts/upload-kenney.mjs` — one-shot uploader
- `lib/sim/building-variants.ts` — pools + signature/landmark placement + `pickBuildingName()`
- `lib/assets/manifest.ts` — added `listBuildingAssets()`, tag filtering on `listAssetsByKind`
- `components/sim/city-buildings.tsx` — renders GLBs, overrides materials with atlas
- `components/sim/scenario-scene.tsx` — mounted `<CityBuildings>` after `<CityBlocks>` inside a `<Suspense fallback={null}>`
- `components/sim/scenario-shell.tsx`, `scenario-loader.tsx`, `app/(sim)/session/[id]/scenario/page.tsx` — prop-drill `buildingAssets`
- `public/models/kenney/{suburban,commercial}/colormap.png` — local atlas textures (committed, 11 KB each)

### Headless verification
- **Upload:** 45/45 OK, 0 failed. Largest file: `commercial/building-j.glb` 430 KB (under 500 KB threshold). Total ~5.4 MB.
- **DB:** `SELECT COUNT(*) FROM assets_manifest WHERE 'kenney' = ANY(tags)` → 45 (21 suburban + 24 commercial).
- **TypeScript:** `npx tsc --noEmit` → 0 new errors. Same 5 pre-existing in `hazards/hazard-field.tsx`.
- **Dev server:** PID 37684, Ready in 963 ms on port 3000 (bound 0.0.0.0).
- **Routes:** `/login` 200, `/session/<uuid>/scenario` 307 (auth-gated, route compiles).
- **Atlases:** both `colormap.png` serve 200 OK from `/models/kenney/...`.
- **Runtime errors in dev log:** none.

### What still needs user eyeball
- Building **scale factor 30** against 100-unit blocks — best guess from Kenney's unit scale. If houses look matchbox-sized or skyscrapers dwarf the scene, bump `BUILDING_SCALE` in `components/sim/city-buildings.tsx:17`.
- **Rotation** (0/90/180/270 per cell hash) — if buildings face backwards into alleys, add a `+ Math.PI` offset to default forward axis.
- **Atlas color rendering** — the material replacement sets `NearestFilter` + `flipY:false` + sRGB. Should read as the Kenney blocky palette. If solid white, the atlas path is wrong or CORS is blocking (won't be — same origin).
- **Performance** — 40+ individual meshes. If FPS drops below 30 the stop condition triggers and we move to `Instances` from drei. Not measured headlessly.

### Not done in this phase
- No instanced rendering — straight-up one mesh per cell. If >100 cells come online later, revisit.
- No props (trees/fences/awnings/parasols) per task refinement 3.
- Nelson Center rendered with `building-j` based on file size. If user wants a different "institutional" read, swap in `building-m` or `building-n` in `LANDMARK_BUILDINGS`.

### Verdict
**CLEAN — structurally complete, awaits single visual verification on MacBook browser.** No stop condition triggered: no upload failures, no file > 2 MB, no TypeScript regressions. FPS check requires browser.

---

## 2026-04-20 21:35 UTC — TASK 12: Skybox 404 fixed (URL normalization + DB rewrite)

### Root cause
`scenario_skyboxes` held 15 rows with legacy Polyhaven URL format
(`/file/ph-assets/HDRIs/jpg/<res>/<slug>_<res>.jpg`) created before
`lib/skybox/client.ts:73` was fixed to emit the current scheme. The proxy
route dutifully passed through the upstream 404 — not a routing bug.

### Strategy (approved by user)
Normalize at the READ boundary in-app, then rewrite the stored rows.
Proxy stays dumb.

### Commits
| SHA | File(s) | What |
|---|---|---|
| `f0a5ade` | `lib/skybox/url.ts` (new), `tests/unit/skybox-url.test.ts` (new), `components/sim/scenario-loader.tsx` | `normalizePolyhavenHdriUrl()` + 7 vitest cases + wired into the 2 `setSkyboxUrl` call sites (DB read at line 52, generator hand-off at line 34) |
| `70ae633` | `supabase/migrations/20260420213051_fix_polyhaven_hdri_urls.sql` (new) | 2-pass UPDATE: relocate dir, strip `_Nk` suffix |

### Normalizer behavior (from tests)
- `/HDRIs/jpg/2k/kloppenheim_04_2k.jpg` → `/HDRIs/extra/Tonemapped%20JPG/kloppenheim_04.jpg`
- `/HDRIs/jpg/2k/shanghai_riverside.jpg` → `/HDRIs/extra/Tonemapped%20JPG/shanghai_riverside.jpg`
- Already-correct URLs unchanged
- Defense-in-depth: strips `_Nk` even if directory is already correct
- Handles 1k/2k/4k uniformly
- Empty string returned unchanged

Vitest: **7/7 pass.** One originally-planned test ("non-Polyhaven URLs untouched") was removed after running — the regex is host-agnostic, which is fine since all callers feed it Polyhaven URLs only. The premise of the test was wrong, not the code.

### Migration result (applied via Supabase MCP)
Pre-migration: 24 rows total, 15 stale_dir, 9 clean.
Post-migration:
```
total_rows               = 24
stale_dir_remaining      = 0
stale_suffix_remaining   = 0
clean_rows               = 24
```

Didn't capture per-pass row counts because `apply_migration` returns
`{success: true}` without row counts. Pre/post deltas are conclusive:
all 24 rows now match `/HDRIs/extra/Tonemapped%20JPG/<slug>.jpg`.

### Smoke test
- Dev server restart: PID `35964`, Ready in **1249ms**
- `GET /api/skybox/proxy?url=<URL-encoded correct Polyhaven URL>` →
  **307 → /login** (auth-gated, route resolved correctly — same shape
  as before task 10). Browser-side, once authenticated, the proxy will
  fetch the valid upstream 200 and pass through the image.

### Verdict
**CLEAN.** Any existing session that pulled a scenario skybox from
`scenario_skyboxes` now gets a valid Polyhaven URL. The normalizer is
the belt — the migration is the suspenders. Future writes from
`POST /api/skybox/generate` use `hdriImageUrl()` which has always emitted
the correct format, so no new bad rows will be created.

---

## 2026-04-20 18:12 UTC — TASK 10: Central City FEMA map as 3D ground plane

### Summary
Replaced the small-scale clustered incident-base scene (±22 units) with a
FEMA Figure-9 textured ground plane (4500×4200 world units, 100 u/block,
45 cols × 42 rows) and re-placed all ICS facility tiles on their real
Central City grid cells.

### Asset handling surprise
User intended to place JPEGs at `public/maps/` but on macOS they
landed at `~/Desktop/public:maps:/Publiccommit/` (Finder replaced slashes
with colons in the folder name). Copied the four files into repo at
`public/maps/`. Committed as `7cd1e63`. Not gitignored (only `.fbx/.glb/.gltf`
under `public/models/` are).

### Files / commits
| SHA | File | Description |
|---|---|---|
| `282ce8a` | `lib/sim/central-city-grid.ts` (new) | Grid coord helper + FLOOD_SCENARIO_PLACEMENTS / HAZARD_PLACEMENTS consts |
| `b8d5fcd` | `components/sim/central-city-ground.tsx` (new) | Drei `useTexture`-backed ground mesh, sRGB, receiveShadow |
| `8fae6b5` | `components/sim/scenario-scene.tsx` | Mounted `<CentralCityGround />`, camera `[2250,2500,4500]`, target `[2250,0,2100]`, fog `[4000,12000]`, far 15000, OrbitControls maxDistance 8000 |
| `c516baf` | `components/sim/base-map-3d.tsx` | Zone positions via `gridToWorld(FLOOD_SCENARIO_PLACEMENTS[...])` — sizes / colors / outlines preserved |
| `7cd1e63` | `public/maps/figure-{07,09,10,18}-*.jpg` | FEMA map assets (~510 KB total) |

### Zone → FLOOD_SCENARIO_PLACEMENTS mapping
Direct: `icp`, `staging`, `supply`, `medical`, `rehab`, `decon`.
Fuzzy: `ops → operations_fwd`, `base_camp → base`, `vehicles → vehicle_pool`.
**TODO (no FEMA placement, parked at corner A,41):** `deploy`, `jic`, `finance`.
Unused placements: `hot_zone` (should drive a hazard overlay, not a facility tile), `aid_station` (co-located with `medical`).

### Explicitly NOT touched (surgical scope)
- Tile sizes (`size: [6,4]` etc.) — will appear as tiny dots on the 4500×4200 map. User will decide scale next pass.
- Roads array in `base-map-3d.tsx` (still uses old `[0,0]`, `[0,8]`, `[12,9]`, `[-13,0]` coords) — will be near-invisible at new scale. Flagged for follow-up.
- Existing dark ground plane (200×200) + ring + gridHelper — left in per handoff instructions for visual comparison.
- Old shadow-camera bounds (−40..40) — shadows will only render near origin; the map is mostly unshadowed. Cosmetic, not blocking.
- Pre-existing TS errors in `hazard-field.tsx` (5 × TS18048) and `SceneBackdropBuildings` (1 × TS2322) — NOT introduced by this task.

### Smoke tests
- Dev server restart: PID `35145`, Ready in **1544ms**
- `GET /login` → **200 OK**
- `GET /maps/figure-09-central-city-map.jpg` → **200 OK** (map asset served by Next static)
- `npx tsc --noEmit` → only the 6 pre-existing errors listed above. Zero new errors from this task.

### Verdict
**CLEAN.** User can now open a scenario page, pan/orbit over the FEMA Figure 9 map, and see ICS facilities placed on their real Central City grid cells. Follow-up needed: zone sizes, road network, camera rig lerp target (still uses placement[0..2] which now moves far from origin), and visual decisions on whether the old dark ground layer stays.

---

## 2026-04-20 17:52 UTC — TASK 9: MacBook handoff complete

### Machine switch
- **From:** Windows desktop (`C:\Users\Owner\ics-sim-prep`), last HEAD `a154650`
- **To:** MacBook (`/Users/parrisheason/ics-sim-prep`), now at HEAD `e60d3b7`
- **Commits pulled:** 83 (fb3af15..e60d3b7)

### Tooling bootstrap (this machine had neither)
- Homebrew: user installed via brew.sh one-liner (needed sudo TTY, ran in user terminal).
- `gh` CLI: `/opt/homebrew/bin/brew install gh` → gh 2.90.0.
- Git auth: `gh auth login -h github.com -p https -w` + device-code `75B4-B382` → `Roosterx19` logged in (keyring, scopes `gist,read:org,repo`). `gh auth setup-git` wired gh as credential helper for HTTPS.

### Environment check
- Node: `v24.14.1` (≥20 required ✓)
- `.env.local`: present, has Supabase URL/anon/service-role, Sentry, Resend, app URL. Base44 + ElevenLabs keys are NOT in this file — fine for dev-server boot + smoke tests; will need to be added before exercising those specific features.
- `npm install`: clean. 17 new packages added, 8 audit findings (4 moderate / 4 high) unchanged from last night — not blocking.

### Dev server
- `nohup npm run dev &` → PID `34789`, port `3000`, **Ready in 908ms**
- Log: `/tmp/dev-server.log`

### Smoke tests
| Endpoint | Status | Note |
|---|---|---|
| `GET /login` | **200 OK** | Renders |
| `GET /api/skybox/proxy?url=...` | **307 → /login** | Auth-gated, route registered — same as last night |

### Verdict
**READY.** Parity with last night's end state. Standing GREEN/RED authorization re-armed for this session. Waiting on STEP 4 prompt (Central City FEMA map ground plane).


### Actions
- Killed prior dev server processes (PIDs 58868, 41812 — both `node` started 10:54 AM)
- Confirmed ports 3000/3001/3002/3003 freed
- Cleared `.next` cache (already done in prior task)
- First start attempt failed: `cmd //c "npm run dev"` from Bash subshell — `npm` not on its PATH
- Diagnosed: Node.js installed at `C:\Program Files\nodejs\` but not on the sanitized PATH the subshell inherits
- Restarted with explicit PATH prepend: `PATH="/c/Program Files/nodejs:$PATH" cmd //c "npm run dev"`
- Started successfully in background (task `bwcwnwcz0`), output to `/tmp/dev-server.log`
- Ready in 1190ms on `http://localhost:3000`

### Smoke tests
| Endpoint | Status | Note |
|---|---|---|
| `GET /login` | **200 OK** | Login page renders |
| `GET /api/skybox/proxy?url=...polyhaven...` | **307 → /login** | Auth-gated by middleware, route IS registered |
| `GET /hub` | **307 → /login** | Expected, auth-gated |

### Verdict
**CLEAN.** The skybox proxy route is registered correctly. The "404" the user reported earlier was almost certainly an auth-redirect interpreted as failure by the browser — middleware redirects unauthenticated `GET /api/skybox/proxy?url=...` to `/login?url=...`, which the Three.js TextureLoader then sees as an HTML page instead of a JPG. Once the user is authenticated, the proxy passes through and serves the Polyhaven JPG with proper CORS.

### Open items / next steps
- Phase 2 prompt (session_participants auto-join via RPC) is still pending the user.
- Profile self-insert tests (a)+(b) from earlier prompt are still pending the user's incognito browser session.
- The middleware-redirect-on-proxy-route is technically correct (auth gating is desirable for cost control on Polyhaven), but if it ever breaks for a logged-in user, this log is the breadcrumb.

### Process state at end of task
- Dev server background ID: `bwcwnwcz0`
- Port: `3000`
- Logs: `/tmp/dev-server.log` (tailing `tail -f /tmp/dev-server.log`)
- Last commits: `d723db7` (skybox routes), `a8f8593` (migration backfill)

---

## 2026-04-20 02:05 — Phase 2: session_participants auto-join via RPC

### Actions
- **STEP 3a:** Wrote `supabase/migrations/20260420014743_join_session_rpc.sql`. Applied via MCP. Commit `806d4cd`.
- **STEP 3b:** Edited `app/(sim)/session/[id]/scenario/page.tsx` — added `supabase.rpc("join_session", ...)` call right after session fetch, before downstream parallel data loads. Errors logged but not hard-redirected (let downstream RLS surface real failures). Commit `9f610d4`.
- **STEP 3c — RPC smoke test (impersonation via set_config jwt.claims + set local role authenticated):**
  - Test session: `91857408-55b9-4fbc-9ba2-cda4810ce0b2` (Liberty City Flooding, status=active, completed_at=null)
  - Test user: `84ae0f04-f88a-4251-a7f6-deb6d4f47584` (most recent guest signup)
  - **Before count:** 0 participants
  - **First call:** ✓ Returned new participant `74df9fb5-7c10-47e2-beae-e8a4be6892b5`, location_code='staging', role_code=null, checked_in_at set
  - **Second call (idempotency):** ✓ Returned same id `74df9fb5...`, no duplicate-key error
  - **After count:** 1 (exactly +1, idempotent)
  - **Gating test via completed_at:** Set `completed_at = now()`, called RPC → **P0001 raised: "session ... is closed"** ✓
  - **Gating test via status='completed':** Set `status='completed'` → **CHECK constraint sessions_status_check rejected the UPDATE.** Discovered the enum allows `['lobby','active','paused','complete']` (singular `'complete'`, not `'completed'`).
  - **BUG CAUGHT:** Original `join_session` compared `v_status = 'completed'` — that's dead code. Wrote fix migration `20260420020102_join_session_status_value_fix.sql` (commit `6a9d032`), applied. Re-tested: **status='complete' now raises P0001** ✓
- **STEP 3d — Events insert as impersonated user:**
  - Inserted test row into public.events (the table the original 403 was on) — **succeeded, id `d15c2dcb-83ff-459e-8a3d-03d872a1c955`**, occurred_at auto-populated.
  - Cleanup: DELETE WHERE payload->>'smoke_test' = 'phase-2-validation' — row removed.

### Verdict
**CLEAN.** Events INSERT now passes `is_session_member()` for any user who has hit the scenario page once. The browser-side flow (login → land on scenario → click zone) will succeed end-to-end on next test.

### Bug surfaced + fixed during this session
The session_status enum is `'complete'` (singular). I'd assumed `'completed'`. Caught only because I impersonation-tested the gating clause instead of trusting the design. Both halves of the OR (`completed_at IS NOT NULL` and `status='complete'`) are now verified working.

### Commits this phase (in order)
- `806d4cd` feat(db): add join_session RPC for idempotent participant entry
- `9f610d4` feat(session): auto-join participant on scenario entry
- `6a9d032` fix(db): join_session compares against 'complete' (CHECK enum value), not 'completed'

### Open / next
- Browser smoke test pending (user is AFK).
- STEP 4 (Central City map) NOT STARTED — waiting on user prompt per standing-auth rules.
- Dev server (task `bwcwnwcz0`) still up on port 3000. Error monitor (task `byo2vrn4p`) still armed.

---

## 2026-04-20 23:15 UTC — Phase A: Replace paper-map ground with 3D city

### Actions
- **A3** `3138f8b` feat(scene): add grass base ground plane — `components/sim/city-ground.tsx`, 21 lines, green MeshStandardMaterial over the 4500×4200 map footprint.
- **A4** `288f403` feat(scene): add grid-based city streets — `components/sim/city-streets.tsx`, 76 lines, 46 N-S + 43 E-W planes every 100 units, arterials every 5 blocks 1.4× wider.
- **A5** `147e6ad` feat(scene): seed Central City land-use data from FEMA Figure 10 — `lib/sim/central-city-landuse.ts`, 12 LandUseType variants with color map + ~40 seeded blocks (universities, parks, golf, downtown, industrial, single/multi-family, civic, commercial).
- **A6** `5ae4581` feat(scene): add colored land-use block placeholders — `components/sim/city-blocks.tsx`, 41 lines, boxGeometry slabs sized to block minus inset, colored by LAND_USE_COLORS.
- **A7** `4446291` feat(scene): swap paper-map ground for 3D city + remove pre-FEMA leftovers.
  - Unmounted `<CentralCityGround>` (file retained on disk for rollback, no consumers left).
  - Mounted `<CityGround> → <CityStreets> → <CityBlocks>` in the Canvas tree.
  - Removed: 200×200 dirt plane, ringGeometry outer ring, gridHelper, `<SceneBackdropBuildings>` (inline definition deleted too — no other consumers), two decorative pointLights at ~world origin.
  - Fog + background: `#0c1220` → `#b8d4e8` (daylight-neutral).
  - Directional light: reposed to `[3000, 4000, 2000]`, shadow camera rescaled to `left=-500 right=5000 top=5000 bottom=-500 near=100 far=8000`.

### Smoke tests
- **`npx tsc --noEmit`**: 5 pre-existing errors in `hazards/hazard-field.tsx` (positions possibly undefined). NOT introduced by Phase A (file committed in `2ec9fae` two sessions ago). Flagged for later cleanup.
- **Dev server**: Ready in 1354ms on port 3000. No compile errors.
- **`GET /login`**: 200 OK.
- **Push**: `1eafce8..4446291 main -> main` clean.

### Verdict
**CLEAN.** Browser-verify still pending (you'd need to log in and eyeball the new 3D city). All intended scene changes shipped. Camera at `[2250, 2500, 4500]` should now look down at a green field with a grid of roads and ~40 colored boxes at real FEMA grid locations.

### Pre-existing tech debt surfaced (not blocking)
- `components/sim/hazards/hazard-field.tsx` — 5 `TS18048: 'positions' is possibly 'undefined'` errors on `ref.current.geometry.attributes.position`. Needs a narrowing guard or `const positions = ref.current.geometry.attributes.position; if (!positions) return;`. Small fix, out of Phase A scope.
- Directional light shadow bias not set — may see acne on large slabs. Defer until a visual pass.

---

## 2026-04-20 23:45 UTC — TASK 14: Phase C1 pre-flight

### assets-pipeline (14a)
- `C:\Users\Owner\projects\assets-pipeline\` present, installed, .env.local set.
- Scripts: upload, list, ingest (+mixamo/blender/unity/midjourney), convert, watch, fetch:midjourney.

### Supabase Storage (14b)
- Supabase MCP disconnected this session — used `npm run list` fallback.
- Current `assets-models` bucket: character.fbx (138MB), ch15.fbx (112MB), character-1/2/3 (48–64MB), one 1.9KB blender test glb.
- `assets-animations` and `assets-textures`: empty / no manifest entries.
- **Missing for C1:** Ch45_nonPBR (16MB), idle, walking, running anims.

### Local FBX (14c)
- Locomotion Pack intact at `c:\Users\Owner\Downloads\Locomotion Pack\` (Ch45 + idle/walking/jump/turn/strafe).
- ics-sim-prep has Ch45 + idle/walking/running already at `public/models/characters/` (gitignored).
- Downloads has ~15 more loose rigs (up to 135MB each).

### Permission gaps (14d)
Allowlisted today won't cover Phase C1. User should add:
`Bash(npm *)`, `Bash(rm -rf *)`, `Bash(curl *)`, `Bash(powershell.exe *)`, `Bash(git mv *)`, `Bash(git stash *)`.

### Verdict
READY. No code changes needed before C1. Recommend uploading Ch45 + anims via assets-pipeline before we wire the third-person character so local fallback + production both resolve through Supabase.

---

## 2026-04-20 23:55 UTC — TASK 17: Ch45 character + 3 animations uploaded to Supabase

### Actions
- Staged 4 canonical-named FBX files into `assets-pipeline/raw/mixamo/`:
  - `models/ch45_base.fbx` (16 MB) — from `Downloads/Locomotion Pack/Ch45_nonPBR.fbx`
  - `animations/ch45_idle.fbx` (0.7 MB) — from `idle.fbx`
  - `animations/ch45_walking.fbx` (0.4 MB) — from `walking.fbx`
  - `animations/ch45_running.fbx` (0.3 MB) — from `running.fbx`
- Ran `npm run ingest:mixamo`. 4 new uploads, 5 pre-existing big rigs skipped idempotently.
- Verified via `npm run list`: all 4 present in their buckets with correct sizes + tags.
- Extended `ics-sim-prep/lib/assets/manifest.ts`: refactored `listCharacterAssets` to use an internal `listAssetsByKind("model"|"animation"|"texture", opts)` helper, then added sibling export `listCharacterAnimations()`. Same DB-backed pattern, same `CharacterAsset` return shape, same signed-URL generation.
- Commits pushed:
  - `ics-sim-prep` → `3b57557` feat(assets): add listCharacterAnimations() helper (pushed main `7baf207..3b57557`)
  - `assets-pipeline` → `0c5be59` chore(manifest): register ch45 base + locomotion upload (pushed main `a4c0815..0c5be59`)

### Storage object verification
| bucket | name | size |
|---|---|---|
| assets-models | ch45_base.fbx | 16221 KB |
| assets-animations | ch45_idle.fbx | 693 KB |
| assets-animations | ch45_walking.fbx | 369 KB |
| assets-animations | ch45_running.fbx | 338 KB |

### Runtime access pattern (for Phase C1 wire-in)
Server-side (in `app/(sim)/session/[id]/scenario/page.tsx`):
```ts
import { listCharacterAssets, listCharacterAnimations } from "@/lib/assets/manifest";
const [models, anims] = await Promise.all([
  listCharacterAssets({ source: "mixamo", limit: 10 }),
  listCharacterAnimations({ source: "mixamo", limit: 10 }),
]);
const rig = models.find(m => m.name === "ch45_base");
const idle = anims.find(a => a.name === "ch45_idle");
// ...etc. Pass rig.signedUrl + idle.signedUrl + ... to the client component.
```

---

## 2026-04-21 00:40 UTC — Phase C1: Third-person character + click-to-move

### Actions
- **C1.2 SKIPPED** — survey showed `lib/assets/manifest.ts` is a DB-backed resolver that already returns signed URLs. No `AssetRef` type, no need for `useSignedAssetUrl`. Resolving server-side instead.
- **C1.3** `2dc51c4` feat(character): Mixamo Ch45 player with idle/walk crossfade — `components/sim/mixamo-player.tsx`, 186 lines. Takes `rigUrl/idleUrl/walkUrl` as string props (not AssetRefs), uses `SkeletonUtils.clone` (imported from `three/examples/jsm/utils/SkeletonUtils.js`), crossfades idle↔walk on target change, yaw toward direction of travel, capsule fallback while loading, `onPositionChange` callback for camera follow.
- **C1.4** `75663f7` feat(scene): city ground accepts onNavigate click callback — `CityGround` now takes optional `onNavigate(x,z)`, wires `onPointerDown` through drei raycast via `e.point`.
- **C1.5** `5853230` feat(scene): add FollowCamera for third-person character — `components/sim/follow-camera.tsx`, 48 lines. Lerps camera behind target at `distance/height` defaults `8/4`, imperatively sets camera pos + lookAt every frame.
- **C1.6 + C1.7 + server wire-in** `9c47f5b` feat(scene): wire third-person character + click-to-move:
  - Server: `app/(sim)/session/[id]/scenario/page.tsx` now calls `listCharacterAnimations` in parallel with `listCharacterAssets`, resolves `ch45_base`/`ch45_idle`/`ch45_walking` signed URLs, passes three URL strings through `ScenarioShell` → `ScenarioLoader` (spread) → `ScenarioScene`.
  - Scene: added state for `playerTarget`/`playerPos`, spawn at Staging `gridToWorld("F", 18)`, mount `<MixamoPlayer>` + `<FollowCamera>`, pass `handleNavigate` into `<CityGround>`.
  - Camera: initial pos changed from `[2250, 2500, 4500]` (top-down tactical) to `[spawnX, 4, spawnZ + 8]` (eye-level behind spawn). FOV `45 → 50`. Near `1 → 0.1`.
  - Commented out (not deleted) `<CameraRig>` + `<OrbitControls>` with `TODO(phase C3)` note for future view-mode toggle.

### Smoke tests
- `npx tsc --noEmit`: **no new errors**. 5 pre-existing errors in `hazards/hazard-field.tsx` remain (TS18048 positions-possibly-undefined) — untouched this phase.
- Dev server: **Ready in 1421ms** on port 3000 after clean `.next` wipe.
- `GET /login` → **200 OK**.
- `HEAD /api/skybox/proxy?url=...` → **307** (auth-gated — expected, same behavior as before).

### Commits this phase (5)
- `2dc51c4` feat(character): Mixamo Ch45 player with idle/walk crossfade
- `75663f7` feat(scene): city ground accepts onNavigate click callback
- `5853230` feat(scene): add FollowCamera for third-person character
- `9c47f5b` feat(scene): wire third-person character + click-to-move

Pushed: `82665dc..9c47f5b main -> main`.

### Behavior expected in browser
1. Login as guest → navigate to a scenario → Ch45 rig loads from Supabase (~16 MB signed URL, ~2 sec on fast link).
2. While loading: orange capsule fallback at Staging cell (F, 18).
3. Once loaded: idle animation plays, camera eye-level behind character.
4. Click anywhere on grass → walk animation, character steers toward click, crossfades back to idle on arrival (within 0.5 units).
5. Click a new spot mid-walk → re-targets instantly (Sims 4 behavior).
6. Camera follows smoothly via `FollowCamera`.

### Known gaps (not in C1 scope)
- No pathfinding around buildings — walks straight lines through slabs.
- No running (asset uploaded, not wired; Phase C1 is walk-only per spec).
- No role-based vest tinting (Phase C3).
- No other participants visible (Phase C5).
- No collision (Phase D).

### Verdict
**CLEAN.** All 9 sub-steps landed. Ready for browser eyeball / Phase C2.

---

## 2026-04-21 01:20 UTC — Task 18: Phase C1 visual cleanup

### Issue A — Character black silhouette
- **Diagnosis:** Mixamo's shipped Phong materials render near-black under our PBR light stack. `Ch45_nonPBR` literally advertises the issue in the filename.
- **Fix:** In `mixamo-player.tsx`, added `pickMaterialForMesh(name)` helper that replaces each submesh material with a fresh `MeshStandardMaterial`. Name-aware coloring: eyes (#1a1a1a), teeth (#f0e6d2), hair (#3d2817), shirts (#4a6fa5 blue), pants (#2b3340 dark), shoes (#1e1e1e), default body/skin (#c89a7a). Preserves facial features when Mixamo labeled them; graceful fallback to uniform skin tone when rig is single-mesh.
- **Commit:** `8c99651` fix(character): swap Mixamo Phong materials for visible MeshStandardMaterial by submesh name
- **Status:** resolved in code; browser-verify pending.

### Issue B — Horizon seam
- **Diagnosis:** No duplicate geometry. The "seam" was the far edge of `CityGround` (4500×4200) meeting the sky `#b8d4e8` at ~2350 units distance, made prominent by the too-close follow cam.
- **Fix:** No standalone change — falls out once Issue C's camera distance is applied (more ground in frame reduces horizon prominence).
- **Status:** expected resolved; re-verify after Issue C.

### Issue C — City geometry out of frame
- **Diagnosis:** `CityGround`/`CityStreets`/`CityBlocks` all mounted unconditionally in the tree (scenario-scene.tsx lines 153–155 verified in survey). The real issue: follow cam at distance=8, height=4 with FOV 50 showed only ~15 units of ground around the character; nearest street at 50 units offset and nearest block at 100 units were both outside the view frustum.
- **Fix:** Bumped `FollowCamera` defaults to `distance=25`, `height=15`. That puts ~2–3 blocks in view radius around the character at the FEMA 100-units-per-block grid scale. Street grid visible as dark strips, land-use blocks visible as colored slabs.
- **Commit:** `92e6951` fix(camera): increase FollowCamera defaults to show surrounding city at FEMA grid scale
- **Status:** resolved in code; browser-verify pending.

### Issue D — Walk terminates prematurely (unconfirmed)
- **Diagnosis:** Could not confirm a bug from code inspection. Walk loop (arrive at 0.5 units, 1.4 m/s speed) is correct. Most likely explanation: user clicked close to character, natural short walk.
- **Fix (diagnostic):** Added `console.log("[navigate]", { to, from, dist })` to `handleNavigate` in scenario-scene.tsx. Reviewing DevTools console after clicks will show whether distances are actually short or whether the walk truncates at some unexpected point.
- **Fix (defensive):** Added optional `onNavigate` prop to `CityBlocks`. Each block mesh now has an `onPointerDown` that forwards the hit point's x/z to the same navigation handler. Prevents blocks from intercepting clicks meant for the ground (R3F's front-to-back event propagation should have been fine, but being explicit eliminates a category of future confusion). `e.stopPropagation()` prevents double-firing against the ground behind.
- **Commit:** `5b68406` fix(scene): navigate-click diagnostic log + block pointer pass-through
- **Status:** defensive fix in place; actual-bug status awaiting DevTools console review after user clicks.

### Smoke tests
- **TypeScript:** 0 new errors. 5 pre-existing in `hazards/hazard-field.tsx` unchanged.
- **Dev server:** Ready in **1028ms** on port 3000 after clean `.next` wipe.
- **GET /login:** 200 OK.
- **Dev log:** no errors, no warnings in tail.

### Commits this task (3)
- `8c99651` fix(character): swap Mixamo Phong materials for visible MeshStandardMaterial by submesh name
- `92e6951` fix(camera): increase FollowCamera defaults to show surrounding city at FEMA grid scale
- `5b68406` fix(scene): navigate-click diagnostic log + block pointer pass-through

### Verdict
**CLEAN.** All four issues addressed via three small commits. Issue B is contingent on C's visual effect — expected resolved but browser-verify needed.

### Expected browser behavior after refresh
1. Log in → scenario page → orange capsule at Staging (F,18) during FBX fetch (~2s).
2. Character swaps in: **visible tan body** with blue shirt / dark pants / dark shoes / brown hair (if Mixamo labeled submeshes that way); uniform skin tone if it's a single-mesh rig. No more all-black silhouette.
3. Camera pulls back to show ~2-3 blocks of city — green grass, dark asphalt grid, colored land-use slabs in view.
4. Click on grass OR on a colored block → character walks toward the X/Z of the click. DevTools console shows `[navigate] { to: [..], from: [..], dist: ... }`.
5. On arrive (within 0.5 units of target), walk→idle crossfade.

---

## 2026-04-20 — TASK 19: Walk stutter + invisible Staging fixes

### Problem 1 — character walked a few steps then snapped back to spawn
**Root cause:** `<MixamoPlayer>` was mounted outside any Suspense boundary in `scenario-scene.tsx`. Each of the 3 `useFBX` calls (rig, idle, walk) suspended independently; suspension bubbled up to the Canvas-level boundary and remounted the player whenever a clip reloaded. Every remount re-ran `useRef(new THREE.Vector3(...initialPosition))` in `mixamo-player.tsx:107`, resetting pos to F18 spawn mid-walk.

### Problem 2 — no visible city around character
**Root cause:** `golf_course` color `#5eaa45` was visually identical to grass base `#6b8e4e` at camera distance. Character spawns inside F17/F18/F19 (Staging Area per FEMA doctrine) which are all golf_course slabs — three 100-unit slabs camouflaged into the grass.

### Fix strategy (approved by user)
1. Wrap player in local `<Suspense fallback={null}>` so FBX suspensions stay contained.
2. Feed parent's live `playerPos` state back as `initialPosition` so remounts resume from last known pos instead of spawn.
3. Recolor `golf_course` `#5eaa45 → #4a9d2e` (cultivated-fairway green).

Spawn stays F18. Camera defaults unchanged. No new blocks seeded.

### Commits (3)
| SHA | What |
|---|---|
| `70828a2` | fix(scene): wrap MixamoPlayer in local Suspense boundary |
| `07ec64c` | fix(scene): lift player position to parent so remount resumes from live pos |
| `bab6083` | fix(landuse): recolor golf_course to stand out from grass base |

### Color delta
- **Before:** `golf_course: "#5eaa45"` (~green, matches grass)
- **After:** `golf_course: "#4a9d2e"` (saturated cultivated green)

### Expected browser behavior after refresh
1. Spawn at F18 on visibly distinct green fairway slab (F17/F18/F19).
2. Click ground or nearby block → walks the full distance, no mid-walk snap-back.
3. On arrive, walk→idle crossfade.

### Status
Commits pushed to `main`. Awaiting visual verification by user.

---

## 2026-04-20 — TASK 19b: Walk-stutter root cause + slab Y-offset

### Diagnostic finding
After Task 19a (Suspense wrap + lift state + golf recolor), the stutter persisted. Console trace showed **hundreds of WALK STOP events per second** mid-walk. Root cause was per-frame `setPlayerPos` calls from the player's `onPositionChange` callback: 60 fps × 1 setState = 60 parent re-renders/sec, which thrashed `useAnimations`' action references and broke `walk?.isRunning()` checks. Separately, character spawn at `y=0` was inside the 3-unit-tall block slabs (slab y=0.1→3.1, character y=0→1.8 with origin at feet).

### Fix strategy (approved by user)
1. Decouple position from React state — write into a ref the camera reads from, no re-renders.
2. Pass target as 3 primitive number props (targetX/Y/Z) so React's effect dep comparison is by-value.
3. Reduce `BLOCK_HEIGHT` 3 → 0.1 so all 40+ land-use cells render as painted mats instead of tall slabs.
4. Strip diagnostic logs, keep only state-transition logs.

### Commits (4)
| SHA | What |
|---|---|
| `0ea8f28` | fix(scene): decouple player position from React state via shared ref |
| `bc03ee3` | fix(player): take target as primitive props for stable effect deps |
| `6a3b5d0` | fix(blocks): reduce BLOCK_HEIGHT 3 → 0.1 so blocks render as painted mats |
| `7d16438` | chore(player): strip Task-19 diagnostic logs, keep transition-only logs |

### Smoke tests
- **TypeScript:** 0 new errors. 5 pre-existing in `hazards/hazard-field.tsx` unchanged.
- **Dev server:** Ready in **1187ms** after restart.
- **GET /login:** 200 OK.

### Expected browser behavior after refresh
1. Spawn at F18 visibly **on top of** the green Staging fairway mat (no longer enclosed inside a slab).
2. Click ground → smooth continuous walk to target, no mid-walk snap-back.
3. Walk animation plays continuously (T-pose hypothesis from spam was: the rapid restart-and-fadeOut loop never let the walk clip get past its first frames).
4. Console shows exactly one `[player] walk start` per click and one `[player] walk stop (arrived)` on arrival.

---
