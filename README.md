# Hermes Restart-Safe Loop Workflow

A file-first Hermes keep-live loop for Obsidian-backed task state. It keeps durable work in notes, then wraps it with automated recovery, validation, and restart-safe handoffs.

This skill is separate from `obsidian-task-resume-workflow`. That skill owns the RESUME/CHECKLIST/DOCS notes. This one owns the live loop: arming, disarming, watchdogs, replayers, escalation, and the guard rails.

## Why it exists

Long tasks fail quietly when the only state is in chat. This loop makes the state live in files, not vibes.

## What it does

Every task gets its own folder with three core notes:
- **RESUME.md** — status, heartbeat, next action, restart note
- **CHECKLIST.md** — step-by-step progress
- **DOCS.md** — goal, decisions, gotchas

The loop is controlled with `/loop-start` (arm) and `/loop-stop` (disarm). When armed, five automated layers keep things moving:

| Layer | Job name | Schedule | Purpose |
|-------|----------|----------|---------|
| Watchdog | `restart-safe-loop-watchdog` | 15m | Detects stalls and writes recovery notes |
| Replayer | `restart-safe-loop-replayer` | 30m | Takes one concrete step on a stalled task |
| Escalator | `restart-safe-loop-escalator` | 60m | Forces fresh-session handoff on repeated stalls |
| Validator | `workflow-validator` | 60m | Repairs missing notes, refreshes the workflow index |
| Smoke test | `workflow-smoke-test` | 360m | Verifies the workflow itself is still healthy |

## Install

```bash
git clone https://github.com/YOUR_USERNAME/hermes-restart-safe-loop-workflow.git
cd hermes-restart-safe-loop-workflow
./install.sh --vault "$HOME/Documents/Obsidian Vault"
```

That's it. The script:
- Installs the skill to `~/.hermes/skills/note-taking/restart-safe-loop-workflow/`
- Sets up your vault with the template, workflow index, and loop state marker
- Adds all 5 cron jobs to Hermes with the correct skill binding

Then tell Hermes `/loop-start` to arm it.

See [INSTALL.md](INSTALL.md) for manual install, options, and uninstall.

## Repo layout

```
install.sh              # One-step installer
SKILL.md                # Hermes skill definition
prompts/
  watchdog-prompt.md    # Stall detection
  replayer-prompt.md    # One-step recovery
  escalator-prompt.md   # Repeated-stall handoff
  validator-prompt.md   # Note integrity and index refresh
  smoke-test-prompt.md  # Workflow health check
templates/
  TEMPLATE.md           # Canonical task folder template
  LOOP-STATE.md         # Armed/disarmed state marker
examples/
  WORKFLOW-INDEX.md     # Starter workflow index
references/
  repo-layout.md        # This layout for reference
```

## Who it is for

Anyone running Hermes (or a similar agent loop) who wants durable, restart-proof task state backed by Obsidian notes.

## License

MIT
