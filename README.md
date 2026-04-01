# Hermes Restart-Safe Loop Workflow

A file-first Hermes recovery loop for Obsidian-backed task state. It keeps durable work in notes, then wraps it with automated recovery, validation, and restart-safe handoffs.

## Why it exists

Long tasks fail quietly when the only state is in chat. This loop makes the state live in files, not vibes.

## What it does

Every task gets its own folder with three core notes:
- **RESUME.md** - status, heartbeat, next action, restart note
- **CHECKLIST.md** - step-by-step progress
- **DOCS.md** - goal, decisions, gotchas

Five automated layers keep things moving:

| Layer | Schedule | Purpose |
|-------|----------|---------|
| Watchdog | 15m | Detects stalls and writes recovery notes |
| Replayer | 30m | Takes one concrete step on a stalled task |
| Escalator | 60m | Forces fresh-session handoff on repeated stalls |
| Validator | 60m | Repairs missing notes, refreshes the workflow index |
| Smoke test | 360m | Verifies the workflow itself is still healthy |

## Install

```bash
git clone https://github.com/YOUR_USERNAME/hermes-restart-safe-loop-workflow.git
cd hermes-restart-safe-loop-workflow
./install.sh --vault "$HOME/Documents/Obsidian Vault"
```

That's it. The script copies the skill, sets up your vault, and adds all 5 cron jobs to Hermes automatically.

See [INSTALL.md](INSTALL.md) for manual install, options, and uninstall.

## Repo layout

```
install.sh            # One-step installer
SKILL.md              # Hermes skill definition
prompts/
  watchdog-prompt.md  # Stall detection
  replayer-prompt.md  # One-step recovery
  escalator-prompt.md # Repeated-stall handoff
  validator-prompt.md # Note integrity and index refresh
  smoke-test-prompt.md # Workflow health check
templates/
  TEMPLATE.md         # Canonical task folder template
examples/
  WORKFLOW-INDEX.md   # Starter workflow index
```

## Who it is for

Anyone running Hermes (or a similar agent loop) who wants durable, restart-proof task state backed by Obsidian notes.

## License

MIT
