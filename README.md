# claude-init

> Zero token waste. Full developer control. Works anywhere Claude runs.

Claude context scaffolder for hackathons and serious projects. Instead of burning credits re-explaining your stack every session, `claude-init` generates a `.claude/` memory system that keeps Claude oriented across the entire project lifecycle.

## The Problem

Most people using Claude Code burn 60-70% of their credits on:
- Re-explaining architecture in chat
- Correction loops from model drift  
- Speculative generation they didn't ask for
- Context growing unbounded across turns

## The Fix

```
prompt.md  (you write this — refined via Claude/GPT website)
    ↓
claude-init
    ↓
.claude/
├── AGENT.md    — role, conventions, phase structure
├── STATE.md    — current phase tracker (you update this)
├── RULES.md    — your non-negotiables
├── MEMORY.md   — locked decisions, never re-debated
├── ERRORS.md   — mistakes log, never repeated
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

## Usage

**Step 1 — Write your prompt.md**

Go to Claude.ai or ChatGPT. Describe your project in plain english (messy is fine). Ask it to refine your idea into a structured spec. Paste the result into `prompt.md` in your project root.

```markdown
## Project
[what you are building]

## Stack  
[languages, frameworks, databases]

## Goal
[what done looks like]

## Constraints
[time, team size, platform]
```

**Step 2 — Run claude-init**

```bash
cd your-project
claude-init
```

**Step 3 — Start Claude**

Open Claude Code / Antigravity / OpenRouter. First message:

```
Read everything in .claude/ and give me your Phase 1 briefing.
```

Claude proposes the full roadmap. You approve before a single line is written.

## The Control Model

```
You own:                    Claude owns:
├── architecture            ├── boilerplate
├── tech stack decisions    ├── repetitive patterns
├── what gets built         ├── documentation  
├── review and approval     ├── test generation
└── when to override        └── syntax and conventions
```

Claude proposes. You dispose. Always.

## Session Protocol

**Start of session:**
```
Read .claude/ and tell me current state.
```

**Between phases:**
- Update `STATE.md` yourself (takes 30 seconds)
- Log decisions in `MEMORY.md`
- Log mistakes in `ERRORS.md`

**End of session:**
- Update `STATE.md` with what was completed
- Next session starts clean — zero re-explanation

## Why It Works

Chat context grows linearly. By turn 50 the model is re-processing 100k tokens of history just to generate one response. `.claude/` files stay flat — Claude reads 6 small files instead of 50 chat turns. That's the credit arbitrage.

## Update

```bash
curl -fsSL https://raw.githubusercontent.com/jhaksh-24/claude-init/main/install.sh | bash
```

## Status

- [x] Core scaffolder
- [x] Cross-platform install (Arch / Ubuntu / PopOS / macOS / WSL)
- [ ] Stack-specific AGENT.md templates (Solidity, Rust, C++, FastAPI)
- [ ] Auto phase name generation via Claude API
- [ ] `claude-init update` command
- [ ] `claude-init status` — prints current STATE.md summary

---

Built by [@jhaksh-24](https://github.com/jhaksh-24)
