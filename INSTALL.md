# Install Instructions

There is currently no npm, Homebrew, or one-line CLI installer for this package.

## Install manually

1. Copy `SKILL.md` into your Hermes skills directory.
2. Copy `templates/` into your workflow repo or use it as a reference for your Obsidian task folders.
3. Copy `prompts/` if you want the validator, smoke-test, watchdog, replayer, and escalator prompts.
4. Copy `examples/WORKFLOW-INDEX.md` if you want a starter index.
5. Point the workflow at your Obsidian vault.

## Enable the validator and smoke-test jobs

Create two recurring Hermes jobs:
- `workflow-validator`
- `workflow-smoke-test`

Suggested schedules:
- `workflow-validator`: every 60m
- `workflow-smoke-test`: every 360m

Use the matching prompts from `prompts/` and make sure both jobs are enabled.

If your Hermes setup uses a job UI, add the jobs there and switch them on. If you manage jobs from config or CLI, create the same two recurring jobs with those names and schedules.

## For GitHub users

If you're publishing the repo, keep the files as plain markdown so others can copy them directly.

## Why manual

This workflow is meant to be portable and file-based. A manual install keeps it compatible with any Hermes setup without waiting for a package manager wrapper.