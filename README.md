# Hermes Memory Keep-Alive for Obsidian

Automatic task memory and a keep-alive loop for Hermes agents.

**Task memory** — every task your agent works on automatically gets persistent RESUME, CHECKLIST, and DOCS notes in Obsidian. Work survives restarts, context loss, and session changes.

**Keep-alive loop** — for long tasks, arm the loop and walk away. If your agent stalls, the loop detects it and keeps work moving. Disarm when done so you're not burning tokens.

```
/loop-start   ← arm before a long task
/loop-stop    ← disarm when done
```

## The problem

1. Agent tasks lose state when sessions end or context compacts. You restart and everything is gone.
2. Long tasks fail silently. The agent stalls and nobody notices.

## How it works

### Task memory (always on)

Every time your agent gets a task, it creates a folder in your Obsidian vault with three notes:
- **RESUME.md** — what the task is, current status, next action, how to restart
- **CHECKLIST.md** — step-by-step progress
- **DOCS.md** — decisions, gotchas, notes for the next session

A **validator** runs every 60m to repair missing notes and keep a workflow index current. A **smoke test** runs every 360m to make sure the system itself is healthy.

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
git clone https://github.com/YOUR_USERNAME/hermes-memory-keep-alive-for-obsidian.git
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
  validator-prompt.md     # Note integrity (memory)
  smoke-test-prompt.md    # System health check (memory)
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

## License

MIT
