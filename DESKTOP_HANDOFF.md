# ICS Simulator - Windows Desktop Handoff

**Handoff Date:** 2026-06-20  
**Source:** macOS Recovery  
**Destination:** Windows Desktop Development  

---

## Repository Information

**GitHub Repository:**
```
https://github.com/Roosterx19/ICS-Simulator-Continuation
```

**Clone Command:**
```bash
git clone https://github.com/Roosterx19/ICS-Simulator-Continuation.git
cd ICS-Simulator-Continuation/frontend/ics-sim-prep
```

**Default Branch:** `main`  
**Latest Commit:** `2b71e16180b428c79966526b0aacae985ed195d7`  

---

## Deployment Status

**Vercel Production URL:**
```
https://ics-sim-prep.vercel.app
```

**Vercel Deployment ID:** `dpl_14rSANDzUYSTpqn77HH273ssVp7q`  
**Status:** ✓ READY (Successfully deployed)  

---

## What's Included in Repository

- ✓ Complete Next.js 14 source code
- ✓ 29 database migrations
- ✓ Seed data (seed.sql, seed_scenarios.sql)
- ✓ Full documentation suite
- ✓ Assets (maps, 3D models)
- ✓ Training scenarios (Central City Flood)
- ✓ Recovery documentation
- ✓ AI board integration
- ✓ Testing infrastructure
- ✓ Git history (97 commits)

---

## Directory Structure

```
ICS-Simulator-Continuation/
├── frontend/ics-sim-prep/          ← Main Next.js app
│   ├── app/                        Routes and pages
│   ├── components/                 React components
│   ├── lib/                        Business logic
│   ├── supabase/                   Database schema
│   ├── package.json                Dependencies
│   ├── CLAUDE.md                   Development rules
│   └── README.md                   Project info
├── database/                       Migrations and seeds
├── docs/                           Full documentation
├── assets/                         Maps and models
├── recovery/                       Recovery documentation
└── RECOVERY_COMPLETE.md            Overview
```

---

## Environment Variables Required

Create `.env.local` in `frontend/ics-sim-prep/`:

```env
# Supabase (REQUIRED)
NEXT_PUBLIC_SUPABASE_URL=https://vojsxvnlpfcppuqzsure.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[your-anon-key-from-supabase]
SUPABASE_SERVICE_ROLE_KEY=[your-service-role-key-from-supabase]
DATABASE_URL=[your-postgres-connection-string]

# App Configuration
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Development
ENABLE_DEV_ROUTES=true

# Phase 2+ (leave blank for now)
RESEND_API_KEY=
NEXT_PUBLIC_SENTRY_DSN=
```

Get values from: https://app.supabase.com/project/vojsxvnlpfcppuqzsure

---

## Windows Setup Instructions

### 1. Prerequisites

- Node.js 20+ (https://nodejs.org/)
- Git for Windows (https://git-scm.com/)
- pnpm 9+ (npm install -g pnpm@9.4.0)

### 2. Clone Repository

```bash
git clone https://github.com/Roosterx19/ICS-Simulator-Continuation.git
cd ICS-Simulator-Continuation/frontend/ics-sim-prep
```

### 3. Install Dependencies

```bash
pnpm install
```

### 4. Setup Environment

```bash
cp .env.example .env.local
```

Edit `.env.local` with Supabase credentials (see above).

### 5. Database Setup

```bash
pnpm supabase:migrate
pnpm supabase:seed
```

### 6. Start Development Server

```bash
pnpm dev
```

Open: `http://localhost:3000`

---

## Supabase Configuration

**Project:** vojsxvnlpfcppuqzsure (shared)  
**Region:** (check project settings)  

**Tables:**
- users
- sessions
- user_session_roles
- form_submissions
- command_posts
- commandpath_routers
- aar_observations
- presence_tracking
- scenarios
- injects
- resources
- And 10+ supporting tables

**RLS Policies:** Enabled on all tables  
**Real-time:** Configured and enabled  
**Storage:** Enabled (for assets)  

---

## Key Development Commands

```bash
# Development
pnpm dev              # Start dev server at http://localhost:3000
pnpm build            # Production build
pnpm start            # Run production build locally

# Quality
pnpm typecheck        # Check TypeScript
pnpm lint             # Check code style
pnpm test:unit        # Run unit tests
pnpm test:e2e         # Run E2E tests

# Database
pnpm supabase:migrate # Apply pending migrations
pnpm supabase:seed    # Seed reference data
pnpm supabase:reset   # Full reset (local only, deletes data)
```

---

## Documentation to Read First

1. **`frontend/ics-sim-prep/CLAUDE.md`** — Development rules (mandatory read)
2. **`docs/project-docs/watts/02_platform-overview.md`** — What is this project?
3. **`docs/project-docs/watts/07_architecture.md`** — System design
4. **`recovery/PROJECT_STATE.md`** — Current status and readiness

---

## Known Issues

- ⚠️  Vercel deployment was previously blocked (now resolved)
- 🟡 Character 3D models need refinement
- 🟡 Test coverage at 30% (target 80%)
- 🟡 Phase 2 features not started (email, monitoring)

See: `docs/project-docs/known-issues.md`

---

## Vercel Deployment

**Production URL:** https://ics-sim-prep.vercel.app

**To Deploy Changes:**
```bash
# Push to GitHub main branch
git push origin main

# Vercel automatically deploys on GitHub push
# OR manually:
vercel deploy --prod
```

**Environment Variables on Vercel:**
Add the same `.env.local` values to Vercel project settings.

---

## Git Workflow

**Main Branch:** Production-ready code  
**Create Feature Branch:**
```bash
git checkout -b feature/your-feature-name
git push -u origin feature/your-feature-name
# Create pull request on GitHub
```

**Merge to Main:**
```bash
# After PR review and tests pass
git checkout main
git pull origin main
git merge feature/your-feature-name
git push origin main
```

---

## Testing Workflow

```bash
# Unit tests
pnpm test:unit

# Watch mode
pnpm test:unit -- --watch

# E2E tests
pnpm test:e2e

# Coverage report
pnpm test:unit -- --coverage
```

---

## Tech Stack Reference

- **Framework:** Next.js 14 (App Router)
- **Language:** TypeScript (strict mode)
- **Styling:** Tailwind CSS
- **UI Components:** shadcn/ui
- **3D Graphics:** react-three-fiber + drei
- **State:** Zustand (client), TanStack Query (server)
- **Forms:** react-hook-form + Zod
- **Database:** Supabase PostgreSQL
- **Auth:** Supabase Auth
- **Testing:** Vitest (unit), Playwright (e2e)
- **Deploy:** Vercel (production), local dev
- **Package Manager:** pnpm 9.4.0

---

## Localhost URLs

**Development:**
- App: http://localhost:3000
- Supabase Studio: http://localhost:54321 (if local instance)

**Production:**
- Vercel: https://ics-sim-prep.vercel.app

---

## Troubleshooting Windows Setup

**Issue: pnpm not found**
```bash
npm install -g pnpm@9.4.0
```

**Issue: Node version mismatch**
```bash
node --version  # Should be 20+
npm install -g n  # Version manager for macOS
# On Windows: use nvm-windows
```

**Issue: Database connection fails**
- Verify .env.local has correct SUPABASE_URL and keys
- Check Supabase project is active
- Verify network connectivity to Supabase

**Issue: Port 3000 already in use**
```bash
pnpm dev -- -p 3001  # Use different port
# Or kill process: netstat -ano | findstr :3000
```

---

## Handoff Checklist

- [x] GitHub repository created and pushed
- [x] All files accessible on GitHub
- [x] Vercel deployment successful
- [x] Supabase schema verified
- [x] Environment setup documented
- [x] Windows setup instructions provided
- [x] Development commands listed
- [x] Documentation references provided

---

## Contact & Support

**GitHub Issues:** https://github.com/Roosterx19/ICS-Simulator-Continuation/issues

**Documentation:**
- Recovery: `recovery/RECOVERY_REPORT.md`
- Architecture: `docs/project-docs/watts/07_architecture.md`
- ICS Domain: `docs/project-docs/ics-knowledge/`

---

**Handoff Complete. Ready for Windows Desktop Development.**
