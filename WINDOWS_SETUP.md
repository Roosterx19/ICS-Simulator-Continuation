# Windows Setup - ICS Simulator

**For:** Windows Desktop Development  
**Duration:** 10-15 minutes  

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

## Step 2: Clone Repository (2 minutes)

```powershell
# Open PowerShell or Command Prompt

cd Desktop  # Or your preferred location

git clone https://github.com/Roosterx19/ICS-Simulator-Continuation.git

cd ICS-Simulator-Continuation/frontend/ics-sim-prep
```

---

## Step 3: Install Dependencies (3 minutes)

```powershell
pnpm install
```

Wait for installation to complete. You should see:
```
packages in 45s
```

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
