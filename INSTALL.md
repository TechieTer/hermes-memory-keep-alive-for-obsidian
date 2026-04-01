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
1. Copies the skill into `~/.hermes/skills/restart-safe-loop/`
2. Creates `Tasks/Session-Resume-Workflow/` in your vault with the template and starter index
3. Adds all 5 cron jobs to your Hermes `jobs.json` (skips any that already exist)
4. Bakes your vault path into each job prompt automatically

If your Hermes home is not `~/.hermes`, pass `--hermes /path/to/.hermes`.

### What gets created

| What | Where |
|------|-------|
| Skill | `~/.hermes/skills/restart-safe-loop/SKILL.md` |
| Template | `<vault>/Tasks/Session-Resume-Workflow/TEMPLATE.md` |
| Workflow index | `<vault>/Tasks/Session-Resume-Workflow/WORKFLOW-INDEX.md` |
| Watchdog job | `~/.hermes/cron/jobs.json` (every 15m) |
| Replayer job | `~/.hermes/cron/jobs.json` (every 30m) |
| Escalator job | `~/.hermes/cron/jobs.json` (every 60m) |
| Validator job | `~/.hermes/cron/jobs.json` (every 60m) |
| Smoke test job | `~/.hermes/cron/jobs.json` (every 360m) |

## Manual install

If you prefer not to use the script:

1. Copy `SKILL.md` into `~/.hermes/skills/restart-safe-loop/SKILL.md`.
2. Create `Tasks/Session-Resume-Workflow/` in your Obsidian vault.
3. Copy `templates/TEMPLATE.md` and `examples/WORKFLOW-INDEX.md` into that folder.
4. Replace `VAULT_PATH` in each file under `prompts/` with your actual vault path.
5. Create the 5 cron jobs manually (see table above for names and schedules). Use the content of each prompt file as the job's prompt text.

## Verify

After installing, ask Hermes:

> Run the workflow smoke test now.

It should return `smoke-test: pass` if everything is set up correctly.

## Uninstall

Remove the skill, the cron jobs, and optionally the vault notes:

```bash
rm -rf ~/.hermes/skills/restart-safe-loop
# Then remove the 5 jobs from ~/.hermes/cron/jobs.json manually,
# or delete them through Hermes CLI / Telegram.
```

The Obsidian vault notes are yours to keep or delete.
