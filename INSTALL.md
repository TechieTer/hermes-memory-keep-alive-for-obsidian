# Install

## Prerequisites

- Hermes installed and running
- An Obsidian vault (or willingness to create one)
- Python 3 (for the install script's job merger)

## One-line install

```bash
git clone https://github.com/YOUR_USERNAME/hermes-restart-safe-loop-workflow.git
cd hermes-restart-safe-loop-workflow
./install.sh --vault "$HOME/Documents/Obsidian Vault"
```

This does everything:
1. Installs the skill to `~/.hermes/skills/note-taking/restart-safe-loop-workflow/`
2. Creates `Tasks/Session-Resume-Workflow/` in your vault with the template, index, and loop state marker
3. Adds all 5 cron jobs to your Hermes `jobs.json` with the correct skill binding (skips any that already exist)
4. Bakes your vault path into each job prompt automatically

Options:
- `--hermes PATH` — Hermes home directory (default: `~/.hermes`)
- `--category NAME` — Skill category directory (default: `note-taking`)

### What gets created

| What | Where |
|------|-------|
| Skill | `~/.hermes/skills/note-taking/restart-safe-loop-workflow/SKILL.md` |
| Template | `<vault>/Tasks/Session-Resume-Workflow/TEMPLATE.md` |
| Workflow index | `<vault>/Tasks/Session-Resume-Workflow/WORKFLOW-INDEX.md` |
| Loop state | `<vault>/Tasks/Session-Resume-Workflow/LOOP-STATE.md` |
| Watchdog job | `restart-safe-loop-watchdog` (every 15m) |
| Replayer job | `restart-safe-loop-replayer` (every 30m) |
| Escalator job | `restart-safe-loop-escalator` (every 60m) |
| Validator job | `workflow-validator` (every 60m) |
| Smoke test job | `workflow-smoke-test` (every 360m) |

All jobs are bound to the `restart-safe-loop-workflow` skill.

## Manual install

If you prefer not to use the script:

1. Copy `SKILL.md` and `references/` into `~/.hermes/skills/note-taking/restart-safe-loop-workflow/`.
2. Create `Tasks/Session-Resume-Workflow/` in your Obsidian vault.
3. Copy `templates/TEMPLATE.md`, `templates/LOOP-STATE.md`, and `examples/WORKFLOW-INDEX.md` into that folder.
4. Replace `VAULT_PATH` in each file under `prompts/` with your actual vault path.
5. Create the 5 cron jobs manually (see table above for names and schedules). Use the content of each prompt file as the job's prompt text. Set the `skill` field to `restart-safe-loop-workflow`.

## Loop controls

The loop installs in a disarmed state. Hermes provides native commands to control it:

- **`/loop-start`** — sets LOOP-STATE.md to `armed`. The watchdog, replayer, and escalator begin monitoring. The validator and smoke test always run regardless of loop state.
- **`/loop-stop`** — sets LOOP-STATE.md to `disarmed`. The watchdog, replayer, and escalator skip their runs with a one-line no-op message.

These are built into Hermes and work from any channel (Telegram, CLI, etc.).

## Verify

Ask Hermes:

> Run the workflow smoke test now.

It should return `smoke-test: pass` if everything is set up correctly.

## Uninstall

Remove the skill, the cron jobs, and optionally the vault notes:

```bash
rm -rf ~/.hermes/skills/note-taking/restart-safe-loop-workflow
# Then remove the 5 jobs from ~/.hermes/cron/jobs.json manually,
# or delete them through Hermes CLI / Telegram.
```

The Obsidian vault notes are yours to keep or delete.
