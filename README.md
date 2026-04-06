# Hermes Memory Keep-Alive for Obsidian

Automatic task memory and a keep-alive loop for Hermes agents.

**Task memory** — every task your agent works on automatically gets persistent RESUME, CHECKLIST, and DOCS notes in Obsidian. Work survives restarts, context loss, and session changes.

**Keep-alive loop** — for long tasks, arm the loop and walk away. If your agent stalls, the loop detects it and keeps work moving. Disarm when done so you're not burning tokens.

```
/loop-start   ← arm before a long task
/loop-stop    ← disarm when done
```

> **Hermes 0.7.0+** — v1.1.0 adds compatibility with the new pluggable memory provider system. The smoke test now checks `hermes memory status` and the validator monitors your built-in `MEMORY.md` file for capacity warnings. See [changelog](#changelog) below.

## The problem

1. Agent tasks lose state when sessions end or context compacts. You restart and everything is gone.
2. Long tasks fail silently. The agent stalls and nobody notices.

## How it works

### Task memory (always on)

Every time your agent gets a task, it creates a folder in your Obsidian vault with three notes:
- **RESUME.md** — what the task is, current status, next action, how to restart
- **CHECKLIST.md** — step-by-step progress
- **DOCS.md** — decisions, gotchas, notes for the next session

A **validator** runs every 60m to repair missing notes, keep a workflow index current, and check Hermes built-in memory capacity. A **smoke test** runs every 360m to make sure the system itself is healthy, including verifying your Hermes memory provider.

### Keep-alive loop (arm when needed)

When you `/loop-start`, three monitoring layers activate:

| Layer | Schedule | What it does |
|-------|----------|--------------|
| **Watchdog** | 15m | Detects when your agent has stalled and writes a recovery note |
| **Replayer** | 30m | Picks up a stalled task and takes one concrete step forward |
| **Escalator** | 60m | Forces a fresh-session restart if the same stall keeps repeating |

When you `/loop-stop`, the monitoring jobs immediately stop. The task memory keeps running either way.

## Install

```bash
git clone https://github.com/TechieTer/hermes-memory-keep-alive-for-obsidian.git
cd hermes-memory-keep-alive-for-obsidian
./install.sh --vault "$HOME/Documents/Obsidian Vault"
```

The script installs the skill, sets up your vault with the template and workflow index, and adds all 5 cron jobs to Hermes.

See [INSTALL.md](INSTALL.md) for manual install, options, and uninstall.

## Usage

**Every task** (automatic — no action needed):
- Give your agent a task → it creates RESUME/CHECKLIST/DOCS automatically
- The validator keeps notes healthy in the background

**Long tasks** (arm the loop):
1. `/loop-start`
2. Give your agent the task
3. Walk away — the loop keeps it alive
4. `/loop-stop` when done

## Repo layout

```
install.sh                # One-step installer
SKILL.md                  # Hermes skill definition
prompts/
  watchdog-prompt.md      # Stall detection (keep-alive)
  replayer-prompt.md      # One-step recovery (keep-alive)
  escalator-prompt.md     # Repeated-stall handoff (keep-alive)
  validator-prompt.md     # Note integrity + Hermes memory capacity check
  smoke-test-prompt.md    # System health + Hermes memory provider check
templates/
  TEMPLATE.md             # Canonical task note template
  LOOP-STATE.md           # Armed/disarmed state marker
examples/
  WORKFLOW-INDEX.md       # Starter workflow index
references/
  repo-layout.md          # Repo layout reference
```

## Who it is for

Anyone running Hermes who wants their agent to remember what it's working on and finish long tasks without babysitting.

## Changelog

### v1.1.0 — Hermes 0.7.0 compatibility
- **Smoke test**: added check for `hermes memory status` — verifies the active memory provider (built-in, Honcho, Mem0, etc.) is healthy and reports provider name in pass output
- **Validator**: added Hermes built-in `MEMORY.md` capacity check — warns in WORKFLOW-INDEX.md when usage exceeds 80% of the 2,200-char limit, prompting you to ask Hermes to consolidate
- Graceful fallback on both checks if Hermes is not installed

### v1.0.0 — Initial release
- Task memory with RESUME/CHECKLIST/DOCS notes in Obsidian
- Keep-alive loop with watchdog, replayer, and escalator layers
- Validator and smoke test integrity checks

## License

MIT
