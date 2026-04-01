# Install

## Prerequisites

- Hermes installed and running
- An Obsidian vault (or willingness to create one)
- Python 3 (for the install script's job merger)

## One-line install

```bash
git clone https://github.com/YOUR_USERNAME/hermes-memory-keep-alive.git
cd hermes-memory-keep-alive
./install.sh --vault "$HOME/Documents/Obsidian Vault"
```

This does everything:
1. Installs the skill to `~/.hermes/skills/note-taking/hermes-memory-keep-alive/`
2. Creates `Tasks/Session-Resume-Workflow/` in your vault with the template, workflow index, and loop state marker
3. Adds all 5 cron jobs to your Hermes `jobs.json` (skips any that already exist)
4. Bakes your vault path into each job prompt automatically

Options:
- `--hermes PATH` — Hermes home directory (default: `~/.hermes`)
- `--category NAME` — Skill category directory (default: `note-taking`)

### What gets created

| What | Where |
|------|-------|
| Skill | `~/.hermes/skills/note-taking/hermes-memory-keep-alive/SKILL.md` |
| Template | `<vault>/Tasks/Session-Resume-Workflow/TEMPLATE.md` |
| Workflow index | `<vault>/Tasks/Session-Resume-Workflow/WORKFLOW-INDEX.md` |
| Loop state | `<vault>/Tasks/Session-Resume-Workflow/LOOP-STATE.md` |

| Job | Schedule | Purpose |
|-----|----------|---------|
| `keep-alive-watchdog` | 15m | Detects stalls (only when loop armed) |
| `keep-alive-replayer` | 30m | Takes one step on stalled task (only when loop armed) |
| `keep-alive-escalator` | 60m | Forces restart on repeated stalls (only when loop armed) |
| `memory-validator` | 60m | Repairs missing notes, refreshes index (always runs) |
| `memory-smoke-test` | 360m | System health check (always runs) |

All jobs are bound to the `hermes-memory-keep-alive` skill.

## Manual install

If you prefer not to use the script:

1. Copy `SKILL.md` and `references/` into `~/.hermes/skills/note-taking/hermes-memory-keep-alive/`.
2. Create `Tasks/Session-Resume-Workflow/` in your Obsidian vault.
3. Copy `templates/TEMPLATE.md`, `templates/LOOP-STATE.md`, and `examples/WORKFLOW-INDEX.md` into that folder.
4. Replace `VAULT_PATH` in each file under `prompts/` with your actual vault path.
5. Create the 5 cron jobs manually (see table above). Set the `skill` field to `hermes-memory-keep-alive`.

## How to use

**Task memory is automatic.** Once installed, your agent creates RESUME/CHECKLIST/DOCS notes for every task. The validator keeps them healthy. No action needed.

**The keep-alive loop is on-demand.** For long tasks:

1. `/loop-start` — arm the loop
2. Give your agent a task
3. Walk away — the loop keeps it alive
4. `/loop-stop` when done — stops burning tokens

For quick tasks, just let the memory handle it. No need to arm the loop.

## Verify

Ask Hermes:

> Run the memory smoke test now.

It should return `smoke-test: pass` if everything is set up correctly.

## Uninstall

```bash
rm -rf ~/.hermes/skills/note-taking/hermes-memory-keep-alive
# Then remove the 5 jobs (keep-alive-* and memory-*) from
# ~/.hermes/cron/jobs.json manually or through Hermes CLI.
```

The Obsidian vault notes are yours to keep or delete.
