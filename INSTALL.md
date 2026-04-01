# Install

## Prerequisites

- Hermes installed and running
- An Obsidian vault or any directory for the loop state file
- Python 3 (for the install script's job merger)

## One-line install

```bash
git clone https://github.com/YOUR_USERNAME/hermes-restart-safe-loop-workflow.git
cd hermes-restart-safe-loop-workflow
./install.sh --vault "$HOME/Documents/Obsidian Vault"
```

This does everything:
1. Installs the skill to `~/.hermes/skills/note-taking/restart-safe-loop-workflow/`
2. Creates `LOOP-STATE.md` in your vault (starts disarmed)
3. Adds the 3 monitoring jobs to your Hermes `jobs.json` (skips any that already exist)
4. Bakes your vault path into each job prompt automatically

Options:
- `--hermes PATH` — Hermes home directory (default: `~/.hermes`)
- `--category NAME` ��� Skill category directory (default: `note-taking`)

### What gets created

| What | Where |
|------|-------|
| Skill | `~/.hermes/skills/note-taking/restart-safe-loop-workflow/SKILL.md` |
| Loop state | `<vault>/Tasks/Session-Resume-Workflow/LOOP-STATE.md` |
| Watchdog job | `restart-safe-loop-watchdog` (every 15m) |
| Replayer job | `restart-safe-loop-replayer` (every 30m) |
| Escalator job | `restart-safe-loop-escalator` (every 60m) |

All jobs are bound to the `restart-safe-loop-workflow` skill.

## Manual install

If you prefer not to use the script:

1. Copy `SKILL.md` and `references/` into `~/.hermes/skills/note-taking/restart-safe-loop-workflow/`.
2. Create `Tasks/Session-Resume-Workflow/` in your vault and copy `templates/LOOP-STATE.md` there.
3. Replace `VAULT_PATH` in each file under `prompts/` with your actual vault path.
4. Create the 3 cron jobs manually (see table above for names and schedules). Use the content of each prompt file as the job's prompt text. Set the `skill` field to `restart-safe-loop-workflow`.

## Loop controls

The loop installs in a disarmed state. Hermes provides native commands to control it:

- **`/loop-start`** — sets LOOP-STATE.md to `armed`. The watchdog, replayer, and escalator begin monitoring.
- **`/loop-stop`** — sets LOOP-STATE.md to `disarmed`. All three jobs skip their runs with a one-line no-op.

These are built into Hermes and work from any channel (Telegram, CLI, etc.).

Typical workflow:
1. `/loop-start` — arm the loop
2. Give your agent a task
3. Walk away — the loop keeps the task alive
4. `/loop-stop` when the task is done — stops burning tokens

## Verify

After arming the loop, ask Hermes:

> Is the restart-safe loop armed?

It should confirm the loop state is armed and the 3 jobs are running.

## Uninstall

Remove the skill and the cron jobs:

```bash
rm -rf ~/.hermes/skills/note-taking/restart-safe-loop-workflow
# Then remove the 3 restart-safe-loop-* jobs from ~/.hermes/cron/jobs.json
# manually, or delete them through Hermes CLI / Telegram.
```

The LOOP-STATE.md in your vault can be deleted or kept.
