# Hermes Restart-Safe Loop Workflow

Give your Hermes agent a task, arm the loop, and walk away. It'll keep working until it's done — even through stalls, restarts, and context loss. When it's finished, disarm the loop so you're not burning tokens while idle.

```
/loop-start   ← arm before giving your agent a task
/loop-stop    ← disarm when the task is done
```

## The problem

Long-running agent tasks fail silently. The agent stalls, loses context, or restarts — and nobody notices. You come back hours later to find nothing happened.

## How it works

When the loop is armed, five automated layers monitor your agent's work:

| Layer | Schedule | What it does |
|-------|----------|--------------|
| **Watchdog** | 15m | Detects when your agent has stalled and writes a recovery note |
| **Replayer** | 30m | Picks up a stalled task and takes one concrete step forward |
| **Escalator** | 60m | Forces a fresh-session restart if the same stall keeps repeating |
| **Validator** | 60m | Repairs missing notes and keeps the workflow index current |
| **Smoke test** | 360m | Makes sure the loop itself is still healthy |

All task state lives in Obsidian notes (RESUME.md, CHECKLIST.md, DOCS.md) — not in chat history. So when a session dies, the next one can pick up exactly where it left off.

When you `/loop-stop`, the watchdog, replayer, and escalator immediately stop running. No wasted tokens.

## Install

```bash
git clone https://github.com/YOUR_USERNAME/hermes-restart-safe-loop-workflow.git
cd hermes-restart-safe-loop-workflow
./install.sh --vault "$HOME/Documents/Obsidian Vault"
```

The script installs the skill, sets up your vault, and adds all 5 cron jobs to Hermes. The loop starts disarmed.

See [INSTALL.md](INSTALL.md) for manual install, options, and uninstall.

## Usage

1. **Arm the loop:** `/loop-start`
2. **Give your agent a task** — it creates RESUME/CHECKLIST/DOCS notes automatically
3. **Walk away** — the loop keeps the task alive through stalls and restarts
4. **Disarm when done:** `/loop-stop`

## How it's built

This skill is separate from `obsidian-task-resume-workflow` (which owns the task notes). This skill owns the live loop: arming, disarming, the monitoring jobs, and the recovery chain.

```
install.sh              # One-step installer
SKILL.md                # Hermes skill definition
prompts/                # Job prompts (watchdog, replayer, escalator, validator, smoke-test)
templates/              # Task folder template + loop state marker
examples/               # Starter workflow index
references/             # Repo layout reference
```

## Who it is for

Anyone running Hermes who gives their agent long tasks and doesn't want to babysit them.

## License

MIT
