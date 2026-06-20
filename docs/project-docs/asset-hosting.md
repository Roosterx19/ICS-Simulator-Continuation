# 3D Asset Hosting — TBD

Large binary assets (Mixamo FBX character rigs, future Kenney GLB
building packs) are NOT checked into git. Repo stays lean.

## Current status

- Mixamo FBX files: sit locally at `public/models/mixamo/` on the
  desktop machine only. Gitignored.
  - Actual current state on desktop: `public/models/characters/`
    holds 4 files (`Ch45_nonPBR.fbx` 15.84 MB, `idle.fbx`,
    `walking.fbx`, `running.fbx`) — ~17 MB total. The wider
    Mixamo pack collection in `c:\Users\Owner\Downloads\Locomotion Pack\`
    and other Downloads paths totals ~120 MB across 6 packs.
- MacBook session needs a copy to render characters. Options:

## Options (pick one with user tomorrow)

1. **Manual copy via USB / external drive** — simplest, no cloud needed.
   ~17 MB for what's wired in today; ~120 MB if all packs come over.
   One-time transfer.
2. **Google Drive / Dropbox / iCloud** — user already has connectors.
   Upload from desktop, download on MacBook. Stays private.
3. **Supabase Storage bucket** — fits the stack. The `assets-models`
   bucket already exists per the repo's prior infra notes (currently
   empty). Upload FBX files, load them via signed URL at runtime. The
   existing `lib/assets/manifest.ts` + `MixamoCharacter` loader already
   support this pattern via `assets_manifest` rows — that's the path
   the production code is written for. The `public/models/...` local
   loading is just a fallback for when the manifest is empty.
4. **Git LFS** — tracks the files in git but stores blobs separately.
   GitHub free tier includes 1 GB storage + 1 GB/month bandwidth;
   likely enough. Adds a `git lfs install` step to every clone.

## Recommendation pending user input

For dev convenience: **Option 1 (manual copy)** tomorrow to unblock
MacBook rendering, **Option 3 (Supabase Storage)** when we're closer
to deploying. Option 3 also matches the loader code that's already
in the repo (`lib/assets/manifest.ts`), so it's the lowest-friction
production path.

## DO NOT commit FBX to git

Even if you find the ignore pattern bypassed, resist. Once a large
binary is in git history, removing it requires rewriting history —
painful for everyone. The `.gitignore` rules at the bottom of the file
cover `*.fbx`, `*.glb`, `*.gltf` under `public/models/`. If you add a
new asset folder, add a matching ignore rule before placing files.
