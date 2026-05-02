# Example: Full Workflow

> A complete walkthrough of `claude-init` — from first install to session 5.
> Every command, every feature, with commentary on why each step matters.

---

## 1. Install

```bash
# one-liner install — downloads init.sh to ~/.claude-init/, adds to PATH
curl -fsSL https://raw.githubusercontent.com/jhaksh-24/claude-init/main/install.sh | bash

# reload your shell so the command is available
source ~/.bashrc    # or ~/.zshrc if you use zsh
```

---

## 2. Write Your Project Spec

Before running `claude-init`, you need a `prompt.md` in your project root.
This is the single source of truth for your project — everything flows from this.

```bash
cd ~/projects/my-app
```

Create `prompt.md`:

```markdown
## Project
Real-time collaborative whiteboard with infinite canvas.
Users can draw, add sticky notes, and see each other's cursors live.

## Stack
TypeScript, Next.js 14 (App Router), PostgreSQL 16, Prisma,
WebSockets via Socket.io, Redis for pub/sub, Docker → Railway

## Goal
Deployed MVP — 2+ users can draw on the same canvas simultaneously
with <100ms latency. Auth via GitHub OAuth. Shareable room links.

## Constraints
Solo developer, 2 week timeline, must handle 50 concurrent users per room.
No paid third-party services beyond hosting.

## Phases (rough — Claude will structure these)
1. Auth + room creation
2. Canvas rendering engine
3. Real-time sync layer
4. Polish + deploy

## Non-Negotiables
- WebSocket messages must be <500 bytes (bandwidth constraint)
- All canvas operations must be CRDT-based (no last-write-wins)
- No client-side state libraries — server is source of truth

## Out of Scope
- Video/audio chat
- File uploads
- Mobile app (web only, but must be touch-friendly)
- User profiles beyond GitHub avatar

## Context
Inspired by Excalidraw and Miro. Target audience is small dev teams
doing remote brainstorming. Performance > features.
```

> **TIP:** If you're not sure how to structure this, paste your messy idea into
> Claude.ai or ChatGPT and ask: *"Refine this into a structured project spec
> with sections for Project, Stack, Goal, Constraints, and Non-Negotiables."*

---

## 3. Run claude-init

```bash
# full scaffold — generates 7 files in .claude/
claude-init

# you'll see:
#   ✓ Found prompt.md
#   Project: Real-time collaborative whiteboard
#   Mode: full (7 files)
#   Proceed? [y/N]: y
#   ✓ Generated AGENT.md
#   ✓ Generated STATE.md
#   ... (all 7 files)
```

### Flags

```bash
# lightweight scaffold — only 4 files (AGENT, STATE, MEMORY, CONTEXT)
# use this for small scripts or hackathon sprints under 3 sessions
claude-init --minimal

# overwrite existing .claude/ without the "already exists" prompt
claude-init --force

# combine flags
claude-init --minimal --force
```

### What gets generated

```
.claude/
├── AGENT.md    — your AI's operating manual (role, standards, phase protocol)
├── STATE.md    — where the project is RIGHT NOW (phase, blockers, session log)
├── RULES.md    — your red lines (things AI cannot do without permission)
├── MEMORY.md   — locked decisions (AI reads, never re-debates)
├── ERRORS.md   — mistakes + known bugs (AI reads, never repeats)
├── FILES.md    — file registry (AI reads instead of scanning filesystem)
└── CONTEXT.md  — token efficiency rules (keeps sessions lean)
```

---

## 4. Customize Before First Session

Before opening Claude, **edit these two files** — this is the highest-ROI 5 minutes you'll spend:

### MEMORY.md — Fill the Stack & Versions block

```markdown
## STACK & VERSIONS

> Lock your exact versions here. Claude uses these, no substitutes.

Language:   TypeScript 5.4
Runtime:    Node.js 20.12 LTS
Framework:  Next.js 14.2 (App Router)
Database:   PostgreSQL 16
ORM/Query:  Prisma 5.x (but raw SQL for perf-critical queries)
Auth:       NextAuth.js v5 + GitHub OAuth
Realtime:   Socket.io 4.x
Cache:      Redis 7
Deploy:     Docker → Railway
Test:       Vitest + Playwright
```

> **WHY THIS MATTERS:** Without this, I might suggest Drizzle instead of Prisma,
> or use Pages Router instead of App Router. Every wrong assumption creates a
> correction loop that wastes tokens.

### RULES.md — Edit the Technical Non-Negotiables

```markdown
## TECHNICAL NON-NEGOTIABLES

- Prisma for schema, raw SQL for any query touching canvas operations
- All WebSocket events must be typed with Zod schemas
- No relative imports deeper than 2 levels — use path aliases
- pnpm only, not npm or yarn
- Every component must have a loading skeleton
- No `any` types — strict TypeScript, zero suppressions
```

> **WHY THIS MATTERS:** These are the things I'll get wrong by default because
> they're preference, not convention. Telling me once here saves 10 corrections.

---

## 5. First Session — The Phase 0 Briefing

Open Claude Code / Antigravity / whatever you use. Send exactly:

```
Read everything in .claude/ and give me your Phase 1 briefing.
```

### What Claude does:

1. Reads all 7 files (silently)
2. Understands your project, stack, constraints, and rules
3. Proposes a full phase-by-phase roadmap with specific files and functions
4. **Stops and waits for your approval**

### What you do:

- Review the roadmap
- Adjust phases, reorder priorities, cut scope
- Say **"approved"** or **"proceed"** when ready
- Claude builds Phase 1

### Efficient responses during building:

```
# GOOD — short, targeted
proceed
fix the return type on createRoom
approved, start phase 2
use redis pub/sub here, not polling
re-read AGENT.md

# BAD — wastes tokens on re-explanation
So the way our architecture works is we have a Next.js frontend
that connects to a WebSocket server and we're using PostgreSQL
for persistence and Redis for the pub/sub layer...
```

> That bad example? It's already in AGENT.md. Saying it in chat means the AI
> processes it twice — once from the file, once from your message.

---

## 6. End of Session — Checkpoint

When you're done working, run:

```bash
claude-init checkpoint
# alias: claude-init ck

# Interactive prompts:
#   Current → Phase: 1 — Foundation
#   New phase status (or Enter to keep): 2 — Canvas Engine
#   What was completed this session? Auth flow, room CRUD, database schema
#   Files created/changed: src/auth/*, src/db/schema.prisma, src/rooms/api.ts
#   Lock in a decision? [y/N]: y
#     Decision title: CRDT Library Choice
#     What was decided: Yjs over Automerge
#     Why: Better binary encoding, smaller wire format, active maintenance
#   Log a bug or mistake? [y/N]: n
#   What should next session start with? Canvas rendering engine with Yjs integration
#
#   ✓ Updated STATE.md
#   ✓ Added decision to MEMORY.md
#   ✓ Checkpoint saved — session 1
```

### What this does behind the scenes:

- **STATE.md** → updates phase, last completed, next task, increments session count, appends session log entry
- **MEMORY.md** → appends your decision (Yjs over Automerge) — Claude will never suggest Automerge again
- **ERRORS.md** → would append bug details if you logged one
- **FILES.md** → notes which files changed

---

## 7. Next Session — Zero Re-Explanation

Open Claude. Send:

```
Read .claude/ and tell me current state.
```

Claude responds with something like:

> Phase 2 — Canvas Engine. Auth and room CRUD complete. Yjs chosen for CRDT
> (locked in MEMORY.md). Next: canvas rendering with Yjs integration.
> No blockers. No unfixed bugs. Ready to proceed.

**That's it.** No re-explaining your stack. No reminding what was decided.
No "so last time we were working on..." — the files handle all of it.

---

## 8. Check Status Anytime

```bash
claude-init status
# alias: claude-init st

# Output:
#   claude-init v2.0.0
#
#   STATE
#   │ Last Updated: 2026-05-03
#   │ Session Count: 2
#   │ Context Health: fresh
#   │ Phase: 2 — Canvas Engine
#   │ Last Completed: Auth flow, room CRUD, database schema
#   │ Next Task: Canvas rendering engine with Yjs integration
#   │ Blockers: none
#
#   DECISIONS  1 locked
```

---

## 9. Maintaining FILES.md

This one is manual — update it as you create files. Takes 10 seconds.

```markdown
## FILE REGISTRY

| File | Purpose | Status |
|------|---------|--------|
| prompt.md | Project specification | 🟢 stable |
| src/app/layout.tsx | Root layout + providers | 🟢 stable |
| src/app/page.tsx | Landing page | 🟡 wip |
| src/auth/config.ts | NextAuth GitHub OAuth config | 🟢 stable |
| src/db/schema.prisma | Database schema | 🟢 stable |
| src/rooms/api.ts | Room CRUD API routes | 🟢 stable |
| src/canvas/engine.ts | Canvas rendering engine | 🟡 wip |
| src/canvas/crdt.ts | Yjs CRDT integration | ⬜ planned |
| src/ws/server.ts | WebSocket server | ⬜ planned |

## ENTRY POINTS

- **Main:** src/app/layout.tsx
- **Config:** .env.local, prisma/schema.prisma
- **Tests:** tests/
- **Build:** Dockerfile, docker-compose.yml
```

> **WHY THIS MATTERS:** This is the #1 thing that saves me time. Without it,
> I have to scan your filesystem or ask "what files exist?" — both waste tokens.
> With it, I instantly know what exists, what's working, and what's broken.

---

## 10. Logging Mistakes in ERRORS.md

When Claude makes a mistake (and it will), log it during checkpoint:

```bash
claude-init ck

# ...
# Log a bug or mistake? [y/N]: y
#   Error title: Wrong Prisma relation syntax
#   What happened: Used implicit many-to-many, broke migration
#   Root cause: Assumed Prisma 4 syntax, we're on Prisma 5
#   Fix applied: Explicit relation table with @relation
```

This gets appended to ERRORS.md. Next session, Claude reads it and
**never makes that specific mistake again**.

You can also manually add to the **Known Bugs** section:

```markdown
## KNOWN BUGS (UNFIXED)

- Canvas flickers on Safari when >100 objects rendered
- Room cleanup cron doesn't fire in Docker (works locally)
```

> Claude sees these and works around them instead of tripping over them.

---

## 11. Locking Decisions in MEMORY.md

Anything decided should go in MEMORY.md (via checkpoint or manually).
The format:

```markdown
### WebSocket Message Format
**Date:** 2026-05-04
**Decision:** Binary protocol with MessagePack, not JSON
**Reason:** 3x smaller payloads, critical for <500 byte constraint
**Rejected:** JSON (too large), Protobuf (overkill for this scale)
**Revisit if:** We add file/image sharing (would need chunking anyway)
```

Once it's here, Claude treats it as settled. No more "have you considered
using JSON instead?" — that debate is closed.

### Patterns Approved / Banned

```markdown
## PATTERNS APPROVED

- Zod for all runtime validation
- Server Actions for mutations (not API routes)
- Tailwind for styling (utility-first, no CSS modules)

## PATTERNS BANNED

- Redux / Zustand / any client state library (server is truth)
- Styled-components (tried it, JSX got unreadable)
- Barrel exports (index.ts re-exports — causes circular deps)
```

---

## 12. When to Start a Fresh Session

Context grows every turn. Signs it's time for a new session:

- You're past ~40 turns
- Claude starts repeating itself or forgetting recent decisions
- Responses feel slower or less precise
- You're switching to a new phase

**Before closing:**
```bash
claude-init ck    # save state
```

**New session:**
```
Read .claude/ and tell me current state.
```

Back to full speed in one message.

---

## Command Reference

| Command | Alias | Description |
|---------|-------|-------------|
| `claude-init` | — | Generate .claude/ scaffold from prompt.md |
| `claude-init --minimal` | `-m` | Lighter scaffold (4 files, no RULES/ERRORS/FILES) |
| `claude-init --force` | `-f` | Overwrite existing .claude/ without prompting |
| `claude-init checkpoint` | `ck` | Interactive session closer — updates STATE, MEMORY, ERRORS |
| `claude-init status` | `st` | Print current phase, blockers, session count |
| `claude-init --version` | `-v` | Print version |
| `claude-init --help` | `-h` | Show help |

---

## The Golden Rules

1. **prompt.md is your foundation** — spend time on it, everything flows from it
2. **Fill MEMORY.md stack versions before session 1** — prevents wrong assumptions
3. **Edit RULES.md before session 1** — your preferences, not generic defaults
4. **Run `claude-init ck` after every session** — 30 seconds, saves 10 minutes next time
5. **Keep FILES.md current** — 10 seconds per file, saves filesystem scanning
6. **Start fresh sessions between phases** — don't let context bloat
7. **Keep chat messages short** — "proceed", "approved", "fix X in Y"
8. **Everything in files, not chat** — chat is for decisions only
