# claude-init

> Zero token waste. Full developer control. Designed by an AI, for AI-assisted development.

Context scaffolder for Claude Code, Antigravity, and any LLM-powered coding tool. Instead of burning credits re-explaining your stack every session, `claude-init` generates a `.claude/` memory system that keeps your AI oriented across the entire project lifecycle.

## The Problem

Most people using AI coding assistants burn a huge portion of their credits on:
- Re-explaining architecture every session
- Correction loops when the model drifts from decisions you already made
- Speculative generation you never asked for
- Context growing unbounded — by turn 50, the model is re-processing 100k tokens of history

## The Fix

```
prompt.md  (your project spec — refined via Claude/GPT website)
    ↓
claude-init
    ↓
.claude/
├── AGENT.md    — AI operating manual (role, standards, phase protocol)
├── STATE.md    — current phase + session tracker
├── RULES.md    — your non-negotiables + red lines
├── MEMORY.md   — locked decisions + stack versions (never re-debated)
├── ERRORS.md   — mistake log + known bugs (never repeated)
├── FILES.md    — file registry (AI reads this instead of scanning)
└── CONTEXT.md  — token efficiency protocol
```

Every session starts with: `"Read .claude/ and tell me current state."`
Claude re-orients in one turn. Zero re-explanation. Every token goes toward building.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/jhaksh-24/claude-init/main/install.sh | bash
source ~/.bashrc  # or ~/.zshrc
```

Works on: **Arch, Ubuntu, PopOS, macOS, WSL**

> **Windows users:** Requires WSL or Git Bash. Native PowerShell support coming soon.

## Usage

> **📖 Full walkthrough with every command and best practice: [example.md](example.md)**

### Step 1 — Write your prompt.md

Go to Claude.ai or ChatGPT. Describe your project in plain english (messy is fine). Ask it to refine your idea into a structured spec. Paste the result into `prompt.md` in your project root.

```markdown
## Project
Building a real-time multiplayer chess platform with ELO ratings

## Stack
TypeScript, Next.js 14, PostgreSQL 16, Prisma, WebSockets, Docker → Railway

## Goal
Deployed MVP with matchmaking, live games, and rating system

## Constraints
Solo developer, 2 week timeline, must handle 100 concurrent games
```

### Step 2 — Run claude-init

```bash
cd your-project
claude-init              # full scaffold (7 files)
claude-init --minimal    # lighter scaffold (4 files — no RULES, ERRORS, FILES)
```

### Step 3 — Start Claude

Open Claude Code / Antigravity / OpenRouter. First message:

```
Read everything in .claude/ and give me your Phase 1 briefing.
```

Claude proposes the full roadmap. You approve before a single line is written.

### Step 4 — End each session

```bash
claude-init checkpoint   # interactive — updates STATE, MEMORY, ERRORS
```

The checkpoint command asks what you completed, logs decisions, records bugs, and sets up the next session — all in 30 seconds.

## Commands

| Command | Alias | What it does |
|---------|-------|-------------|
| `claude-init` | — | Generate `.claude/` scaffold |
| `claude-init checkpoint` | `ck` | Interactive session state updater |
| `claude-init status` | `st` | Print current project state |
| `claude-init --minimal` | `-m` | Lighter scaffold (4 files) |
| `claude-init --force` | `-f` | Overwrite existing `.claude/` |
| `claude-init --version` | `-v` | Print version |

## What Each File Does

| File | Who writes it | Purpose |
|------|:------------:|---------|
| **AGENT.md** | claude-init (you edit) | AI's operating manual — role, standards, phase protocol. Your project spec is embedded here. |
| **STATE.md** | You (via checkpoint) | Where the project is right now. Phase, blockers, session log. AI reads this first every time. |
| **RULES.md** | You | Your non-negotiables. Red lines the AI cannot cross without permission. |
| **MEMORY.md** | You (via checkpoint) | Locked architectural decisions + exact stack versions. AI never re-debates these. |
| **ERRORS.md** | You (via checkpoint) | Past mistakes + known bugs. AI reads this to avoid repeating them. |
| **FILES.md** | You | File registry with status indicators. AI reads this instead of scanning your filesystem. |
| **CONTEXT.md** | claude-init | Token efficiency rules for both you and the AI. Keeps sessions lean. |

## The Control Model

```
You own:                    Claude owns:
├── architecture            ├── implementation
├── tech stack decisions    ├── boilerplate
├── what gets built         ├── repetitive patterns
├── phase approval          ├── documentation
├── review + sign-off       ├── test generation
└── override authority      └── syntax + conventions
```

Claude proposes. You dispose. Always.

## Session Protocol

**Start of session:**
```
Read .claude/ and tell me current state.
```

**During work:**
- Claude proposes each phase before building
- You say "proceed" or redirect
- One task per turn, no surprises

**End of session:**
```bash
claude-init checkpoint
```

**Next session starts clean** — zero re-explanation needed.

## Why It Works

Chat context grows linearly. By turn 50, the model re-processes 100k tokens just to generate one response. `.claude/` files stay flat — the AI reads 7 small files instead of 50 chat turns. That's the efficiency gain.

The checkpoint system solves the other half: humans forget to update state files. `claude-init checkpoint` reduces that friction to 30 seconds of answering prompts.

## When NOT to Use This

- **Quick one-off questions** — just ask Claude directly
- **Single-file scripts** — overhead isn't worth it
- **Exploratory conversations** — when you're brainstorming, not building
- **Projects under 3 sessions** — the setup cost exceeds the savings

This tool pays for itself on session 3+. For hackathons, multi-day projects, and serious builds — that's where it shines.

## Update

```bash
curl -fsSL https://raw.githubusercontent.com/jhaksh-24/claude-init/main/install.sh | bash
```

## Roadmap

- [x] Core scaffolder with 7 context files
- [x] Cross-platform install (Arch / Ubuntu / PopOS / macOS / WSL)
- [x] `claude-init checkpoint` — interactive state updater
- [x] `claude-init status` — quick state view
- [x] `--minimal` mode for lighter projects
- [x] FILES.md — project file registry
- [ ] Stack-specific AGENT.md templates (Solidity, Rust, C++, FastAPI)
- [ ] Native Windows/PowerShell support
- [ ] `claude-init diff` — show what changed since last checkpoint
- [ ] Auto-detect stack from package.json / Cargo.toml / pyproject.toml
- [ ] Team mode — shared .claude/ with per-developer STATE.md

## License

MIT — see [LICENSE](LICENSE)

---

Built by [@jhaksh-24](https://github.com/jhaksh-24)
Designed with input from Claude — because the best tools are built by the ones who use them.
