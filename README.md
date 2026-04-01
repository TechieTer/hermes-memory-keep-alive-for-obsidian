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

## Fully self-contained

You don't need any other skills installed. If the agent has no task notes when the loop is armed, the watchdog automatically creates them — it looks at what the agent is working on and bootstraps a RESUME.md, CHECKLIST.md, and DOCS.md so the loop has something to monitor.

This is not the Obsidian task-resume workflow (that's a separate skill for task memory). This loop is for **live control**: arm it, disarm it, and let Hermes keep watch over a running task. It works alongside other skills if you have them, but it doesn't require them.

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
2. **Give your agent a task** — the watchdog auto-creates task notes if needed
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
