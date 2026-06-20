# Windows Setup - ICS Simulator

**For:** Windows Desktop Development  
**Duration:** 10-15 minutes  

> ⚠️ **IMPORTANT — the app is its OWN repo, not part of this one.**
> `frontend/ics-sim-prep` in THIS repository is only a commit pointer (gitlink → `7f25b77`); it clones **empty** and there is no `.gitmodules` to fill it. The real Next.js app lives at **`https://github.com/Roosterx19/ics-sim-prep`** and must be cloned separately. Do NOT try to `pnpm install` inside `ICS-Simulator-Continuation/frontend/ics-sim-prep` — it has no `package.json`.

---

## Step 1: Prerequisites (5 minutes)

Install in this order:

### 1a. Node.js 20+
- Download: https://nodejs.org/ (LTS version)
- Run installer, accept defaults
- Verify: Open PowerShell
```powershell
node --version  # Should show v20.x.x or higher
npm --version   # Should show 10.x.x or higher
```

### 1b. Git for Windows
- Download: https://git-scm.com/download/win
- Run installer, accept defaults
- Verify: Open PowerShell
```powershell
git --version   # Should show git version 2.x.x
```

### 1c. pnpm 9.4.0
```powershell
npm install -g pnpm@9.4.0
pnpm --version  # Should show 9.4.0
```

---

## Step 2: Get the App Repository (2 minutes)

The application is the standalone repo **`ics-sim-prep`** (NOT this continuation repo).

**Fresh machine — clone the app:**
```powershell
cd Desktop  # Or your preferred location

git clone https://github.com/Roosterx19/ics-sim-prep.git

cd ics-sim-prep
```

**Already have a local copy?** Just update it instead of re-cloning:
```powershell
cd path\to\ics-sim-prep
git pull --ff-only            # fast-forward only; never silently merges
```

---

## Step 3: Install Dependencies (3 minutes)

Activate the pinned pnpm (the repo pins `pnpm@9.4.0` via `packageManager`):
```powershell
corepack enable
corepack prepare pnpm@9.4.0 --activate
```

Then install:
```powershell
pnpm install
```

> If install reports `ERR_PNPM_OUTDATED_LOCKFILE`, the committed `pnpm-lock.yaml` is behind `package.json` (a dependency was added without committing the lockfile). Run `pnpm install --no-frozen-lockfile` to regenerate it, then commit the updated `pnpm-lock.yaml`.

Wait for installation to complete (`Done in ~Ns`).

---

## Step 4: Environment Variables (2 minutes)

### 4a. Get Supabase Credentials

1. Go to: https://app.supabase.com/project/vojsxvnlpfcppuqzsure/settings/general
2. Copy Project URL (NEXT_PUBLIC_SUPABASE_URL)
3. Go to: https://app.supabase.com/project/vojsxvnlpfcppuqzsure/settings/api
4. Copy:
   - `anon public` → NEXT_PUBLIC_SUPABASE_ANON_KEY
   - `service_role` → SUPABASE_SERVICE_ROLE_KEY
5. Go to Database Settings, copy DATABASE_URL

### 4b. Create .env.local

In PowerShell, from `frontend/ics-sim-prep/`:

```powershell
Copy-Item .env.example .env.local
```

Open `.env.local` in VS Code and fill in:

```env
NEXT_PUBLIC_SUPABASE_URL=https://vojsxvnlpfcppuqzsure.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[paste-your-anon-key]
SUPABASE_SERVICE_ROLE_KEY=[paste-your-service-role-key]
DATABASE_URL=[paste-your-db-url]
NEXT_PUBLIC_APP_URL=http://localhost:3000
ENABLE_DEV_ROUTES=true
```

Save the file.

---

## Step 5: Setup Database (2 minutes)

```powershell
pnpm supabase:migrate
pnpm supabase:seed
```

Wait for completion. You should see:
```
✓ Migrations applied
✓ Seed data loaded
```

---

## Step 6: Start Development Server (1 minute)

```powershell
pnpm dev
```

You should see:
```
▲ Next.js 14.2.35
  - Local:        http://localhost:3000
  - Environments: .env.local
```

---

## Step 7: Test in Browser (1 minute)

1. Open browser
2. Go to: http://localhost:3000
3. You should see the login page
4. Click "Sign Up" and create a test account

---

## Success!

You're now running the ICS Simulator locally on Windows.

---

## If Something Goes Wrong

### Issue: "pnpm: command not found"
```powershell
npm install -g pnpm@9.4.0
```
Close and reopen PowerShell.

### Issue: "Cannot find module..."
```powershell
# Delete node_modules and try again
Remove-Item -Recurse node_modules
pnpm install
```

### Issue: Port 3000 in use
```powershell
# Use different port
pnpm dev -- -p 3001
# Access at http://localhost:3001
```

### Issue: Database connection fails
- Check NEXT_PUBLIC_SUPABASE_URL in .env.local
- Verify key values are correct (no extra spaces)
- Try: `pnpm supabase:reset` to reinitialize

### Issue: "Cannot GET /login"
- Wait 30 seconds for build to complete
- Refresh browser
- Check for errors in PowerShell terminal

---

## Daily Workflow

```powershell
# Start development
pnpm dev

# In another PowerShell window, run tests (optional)
pnpm test:unit

# To stop server
Ctrl+C
```

---

## Next Steps

1. Read: `frontend/ics-sim-prep/CLAUDE.md` (development rules)
2. Read: `docs/project-docs/watts/02_platform-overview.md` (what is this?)
3. Create a feature branch for your work
4. Make changes and test locally
5. Push to GitHub and create a PR

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `pnpm dev` | Start dev server |
| `pnpm build` | Build for production |
| `pnpm test:unit` | Run unit tests |
| `pnpm test:e2e` | Run E2E tests |
| `pnpm lint` | Check code style |
| `pnpm typecheck` | Check TypeScript |
| `git push origin main` | Push to GitHub |
| `Ctrl+C` | Stop dev server |

---

**Setup Time:** ~10-15 minutes  
**Status:** Ready for development  

🚀 Start developing!
