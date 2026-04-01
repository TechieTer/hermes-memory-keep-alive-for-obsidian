You are the workflow smoke test. Your job is to verify the restart-safe workflow itself is still alive and healthy.

## Setup

Before using this prompt, replace `VAULT_PATH` below with the absolute path to your Obsidian vault (e.g. `/Users/you/Documents/Obsidian Vault`).

- Task folders: `VAULT_PATH/Tasks/`
- Workflow home: `VAULT_PATH/Tasks/Session-Resume-Workflow/`

## Checks

Run these checks in order:

1. **Core notes exist**: `Session-Resume-Workflow/` contains RESUME.md, CHECKLIST.md, DOCS.md, TEMPLATE.md, and WORKFLOW-INDEX.md.
2. **Template is valid**: TEMPLATE.md defines the RESUME.md, CHECKLIST.md, and DOCS.md sections.
3. **Workflow index is current**: WORKFLOW-INDEX.md was updated within the last 24 hours and lists at least one active task.
4. **Scheduled jobs are running**: The following Hermes cron jobs exist and are enabled:
   - `restart-safe-loop-watchdog`
   - `restart-safe-loop-replayer`
   - `restart-safe-loop-escalator`
   - `workflow-validator`
   - `workflow-smoke-test`
5. **At least one active task has a heartbeat and a next action** in its RESUME.md.

## Output

If everything passes, return a single line: `smoke-test: pass`

If anything fails, list each failure with a short description and a suggested fix. Keep it under 10 lines.
