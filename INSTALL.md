# Install

## Prerequisites

- Hermes installed and running
- An Obsidian vault with a `Tasks/` directory (or willingness to create one)

## Option 1: Clone from GitHub

```bash
git clone https://github.com/YOUR_USERNAME/hermes-restart-safe-loop-workflow.git
cd hermes-restart-safe-loop-workflow
```

Then copy the files into your Hermes setup:

```bash
# 1. Install the skill
cp SKILL.md ~/.hermes/skills/restart-safe-loop/SKILL.md

# 2. Set up the Obsidian vault structure
VAULT="$HOME/Documents/Obsidian Vault"  # <-- change this to your vault path
mkdir -p "$VAULT/Tasks/Session-Resume-Workflow"
cp templates/TEMPLATE.md "$VAULT/Tasks/Session-Resume-Workflow/TEMPLATE.md"
cp examples/WORKFLOW-INDEX.md "$VAULT/Tasks/Session-Resume-Workflow/WORKFLOW-INDEX.md"
```

## Option 2: Manual copy

1. Copy `SKILL.md` into `~/.hermes/skills/restart-safe-loop/SKILL.md`.
2. Create `Tasks/Session-Resume-Workflow/` in your Obsidian vault.
3. Copy `templates/TEMPLATE.md` into that folder.
4. Copy `examples/WORKFLOW-INDEX.md` into that folder as a starter index.

## Configure the prompts

Each prompt in `prompts/` has a `VAULT_PATH` placeholder. Replace it with the absolute path to your Obsidian vault before using them as cron job prompts.

For example, if your vault is at `/Users/you/Documents/Obsidian Vault`, replace every occurrence of `VAULT_PATH` with that path.

## Create the Hermes cron jobs

You need five recurring jobs. Create them through the Hermes CLI, Telegram, or however you manage jobs:

| Job name | Schedule | Prompt file |
|----------|----------|-------------|
| `workflow-watchdog` | every 15m | `prompts/watchdog-prompt.md` |
| `workflow-replayer` | every 30m | `prompts/replayer-prompt.md` |
| `workflow-escalator` | every 60m | `prompts/escalator-prompt.md` |
| `workflow-validator` | every 60m | `prompts/validator-prompt.md` |
| `workflow-smoke-test` | every 360m | `prompts/smoke-test-prompt.md` |

Use the content of each prompt file as the job's prompt text (after replacing `VAULT_PATH`). Make sure all five jobs are enabled.

The watchdog, replayer, and escalator form the recovery chain. The validator and smoke test are the integrity layers. All five are needed for the full loop.

## Verify the install

After creating the jobs, ask Hermes to run the smoke test manually:

> Run the workflow smoke test now.

It should return `smoke-test: pass` if everything is set up correctly.
