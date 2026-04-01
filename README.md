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

## Quick start

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/hermes-restart-safe-loop-workflow.git
cd hermes-restart-safe-loop-workflow

# Copy the skill into Hermes
cp SKILL.md ~/.hermes/skills/restart-safe-loop/SKILL.md

# Set up your Obsidian vault
VAULT="$HOME/Documents/Obsidian Vault"  # <-- your vault path
mkdir -p "$VAULT/Tasks/Session-Resume-Workflow"
cp templates/TEMPLATE.md "$VAULT/Tasks/Session-Resume-Workflow/TEMPLATE.md"
cp examples/WORKFLOW-INDEX.md "$VAULT/Tasks/Session-Resume-Workflow/WORKFLOW-INDEX.md"

# Replace VAULT_PATH in each prompt with your actual vault path
# Then create the 5 Hermes cron jobs (see INSTALL.md for details)
```

See [INSTALL.md](INSTALL.md) for the full step-by-step including all five cron jobs.

## Repo layout

```
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
