# Board Members — When to Use Which AI Tool

A map of the AI tools available to this project and which one to reach for. Treat this like a team: each member has a specialty, and the user (you) is the chair of the board. **You route the work; the board member produces.**

**Rule of thumb:** Claude Code owns the codebase. Everything else exists to make Claude Code faster or better informed. Do NOT call external AIs from inside app code.

---

## The Board

### Claude Code — **Primary Builder** (required)
The main development environment. Owns all source code changes, migrations, tests, and deploys via Vercel MCP.

**Use for:**
- All app code (components, hooks, route handlers, migrations, tests)
- Refactors, bug fixes, feature work
- Running and interpreting tests
- Git operations
- Reading the codebase to answer "how does X work" questions

**Don't use for:**
- Greenfield market research (too expensive, wrong tool)
- Brainstorming UX concepts before architecture exists (use Claude.ai chat first)

**Handoff to Claude Code when:** A task has clear requirements, a success criterion, and lives in the repo.

---

### Claude.ai (this chat) — **Planning & Spec**
Where you are right now. Long-context chat, project knowledge, attached files.

**Use for:**
- Writing PRDs, roadmaps, design docs (like what we just did)
- Processing user input into structured plans
- Reading course PDFs, design docs, research reports
- Multi-step reasoning that benefits from the thinking flow
- Preparing the prep package for Claude Code

**Don't use for:**
- Direct code changes to the repo (no filesystem access to your codebase)
- Running tests or builds

**Handoff to Claude Code when:** Planning is done, specs are in `docs/`, tasks are sliced into current-sprint.md items.

---

### Supabase MCP — **Database Operations**
Already connected. Drives DB work that would otherwise require manual SQL or dashboard clicks.

**Use for:**
- Applying migrations
- Inspecting table structure, policies, indexes
- Running ad-hoc queries against dev DB
- Checking RLS policy effectiveness
- Managing storage buckets

**Don't use for:**
- Production data changes without explicit approval
- Bulk data imports (use seed files in repo)

**Called by:** Claude Code directly during development tasks that touch the DB.

---

### Vercel MCP — **Deploys & Env**
Already connected. Handles hosting operations.

**Use for:**
- Checking deploy status
- Setting environment variables
- Reading deploy logs when something breaks
- Promoting a preview to production

**Don't use for:**
- Source code changes (that's Claude Code + git)

**Called by:** Claude Code when a deploy needs inspection or a new env var has to exist before a release.

---

### Linear MCP — **Issue Tracking**
Already connected. Where user stories, bugs, and sprint items live.

**Use for:**
- Creating issues from `current-sprint.md` items
- Updating issue status as work progresses
- Linking commits/PRs to issues

**Don't use for:**
- Product strategy (that's PRD/ROADMAP in the repo)

**Called by:** You at sprint planning; Claude Code when closing an issue after verification.

---

### Base44 — **Rapid Internal Tools**
Already connected via MCP. An AI app builder — good for throwaway internal/admin UIs that don't need to live in the main codebase.

**Use for:**
- Instructor admin dashboards that need to exist yesterday but aren't part of the student-facing product
- Data visualization tools for scenario analysis
- Internal seed-data editors (e.g. a scenario editor for your own use before building it into the app)
- Quick prototypes of a UI concept before Claude Code builds the real version

**Don't use for:**
- Production student-facing features (those live in the main app)
- Anything that touches production data without a reviewed integration path

**Handoff:** Build the internal tool in Base44. If it proves valuable, Claude Code re-implements it in the main codebase on a schedule.

---

### Gemini — **Second Opinion / Long Context**
External, accessed manually by you. Google's model with very long context windows.

**Use for:**
- Cross-checking a design decision Claude made ("Claude proposed X; does Gemini see a problem?")
- Processing very long source material (multiple PDFs at once) when Claude.ai's context is stretched
- Multimodal tasks involving many images (map screenshots, form layouts)

**Don't use for:**
- Routine work Claude is already good at — diminishing returns
- Production code generation (no repo context)

**Handoff:** You read Gemini's output, decide what's worth keeping, and feed the distillation into Claude.ai or Claude Code.

---

### Perplexity — **Factual Research**
External, accessed manually by you. Search-grounded answers.

**Use for:**
- "What's the current FEMA ICS curriculum version?"
- "How are other ICS training tools priced?"
- "What's the latest NIMS doctrine update?"
- Fact-checking claims in ICS content you're extracting

**Don't use for:**
- Code (no repo context, shallower code skill than Claude)
- Opinion/design work

**Handoff:** Copy cited facts into `docs/decisions-log.md` or the relevant ICS reference file.

---

## Routing Matrix

| Task Type | First Choice | Second Choice |
|---|---|---|
| Write a new component | Claude Code | — |
| Fix a bug | Claude Code | — |
| Add a DB table | Claude Code (+ Supabase MCP for verification) | — |
| Write a PRD / roadmap / design doc | Claude.ai | — |
| Process a long PDF | Claude.ai | Gemini (if context stretched) |
| Research FEMA policy change | Perplexity | Claude.ai with web search |
| Create an admin dashboard | Base44 | Claude Code (for production version) |
| Deploy to production | Vercel MCP (via Claude Code) | — |
| File a bug ticket | Linear MCP (via Claude Code) | — |
| Cross-check a big architecture call | Gemini (second opinion) | Another Claude.ai session |

---

## Anti-Patterns (don't do these)

- **Asking Claude Code to do planning.** It'll do it badly because its tools point at code, not strategy. Plan in Claude.ai first.
- **Asking Claude.ai to edit the repo directly.** It doesn't have filesystem access to your codebase. It can write files for you to paste in, but Claude Code is faster.
- **Calling Base44 from production code.** Base44 apps are standalone. Don't couple them into the main Next.js app.
- **Using Gemini as a crutch because you don't trust Claude.** If something feels wrong with Claude's answer, ask Claude to explain its reasoning first. Escalate to a second model only after.
- **Perplexity for opinions.** It's a search summarizer, not an advisor.

---

## Escalation Path (when stuck)

1. Re-read `CLAUDE.md` and the relevant Watts doc.
2. Search the codebase for an analogous pattern.
3. Ask Claude Code directly: "Why is this failing? Walk me through the data flow."
4. If the issue is strategic (not a bug), open Claude.ai and talk it through.
5. If you want a second opinion on a big decision, paste the problem + Claude's answer into Gemini.
6. If the question is "what are the facts," use Perplexity.
7. Log the decision in `docs/watts/decisions-log.md` so future-you (and future AI sessions) inherit the reasoning.
