# Hermes Restart-Safe Loop Workflow

Give your Hermes agent a task, arm the loop, and walk away. It'll keep working until it's done ��� even through stalls, restarts, and context loss. When it's finished, disarm the loop so you're not burning tokens while idle.

```
/loop-start   ← arm before giving your agent a task
/loop-stop    ← disarm when the task is done
```

## The problem

Long-running agent tasks fail silently. The agent stalls, loses context, or restarts — and nobody notices. You come back hours later to find nothing happened.

## How it works

When the loop is armed, three automated layers monitor your agent's work:

| Layer | Schedule | What it does |
|-------|----------|--------------|
| **Watchdog** | 15m | Detects when your agent has stalled and writes a recovery note |
| **Replayer** | 30m | Picks up a stalled task and takes one concrete step forward |
| **Escalator** | 60m | Forces a fresh-session restart if the same stall keeps repeating |

When you `/loop-stop`, all three jobs immediately stop running. No wasted tokens.

## What this is not

This is not the Obsidian RESUME / CHECKLIST / DOCS task-resume workflow. That workflow is for task memory and restart-friendly notes — it's a separate skill (`obsidian-task-resume-workflow`).

This loop is for **live control**: arm it, disarm it, and let Hermes keep watch over a running task. It works alongside the task-resume workflow if you have it, but it doesn't require it. This skill stands on its own.

## Install

```bash
git clone https://github.com/YOUR_USERNAME/hermes-restart-safe-loop-workflow.git
cd hermes-restart-safe-loop-workflow
./install.sh --vault "$HOME/Documents/Obsidian Vault"
```

The script installs the skill, sets up your vault with the loop state marker, and adds the 3 monitoring jobs to Hermes. The loop starts disarmed.

See [INSTALL.md](INSTALL.md) for manual install, options, and uninstall.

## Usage

1. **`/loop-start`** — arm the loop
2. **Give your agent a task**
3. **Walk away** — the loop keeps the task alive through stalls and restarts
4. **`/loop-stop`** when done — stops burning tokens

## Repo layout

```
install.sh              # One-step installer
SKILL.md                # Hermes skill definition
prompts/
  watchdog-prompt.md    # Stall detection
  replayer-prompt.md    # One-step recovery
  escalator-prompt.md   # Repeated-stall handoff
templates/
  LOOP-STATE.md         # Armed/disarmed state marker
references/
  repo-layout.md        # Repo layout reference
```

## Who it is for

Anyone running Hermes who gives their agent long tasks and doesn't want to babysit them.

## License

MIT
