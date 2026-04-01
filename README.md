# Hermes Restart-Safe Loop Workflow

A file-first Hermes recovery loop for Obsidian-backed task state.

It keeps durable work in notes, then wraps it with recovery, validation, and restart-safe handoffs.

## What it does

It keeps the durable state of a long task in files instead of chat, then adds a recovery loop around it.

It combines:
- Obsidian RESUME / CHECKLIST / DOCS notes
- a canonical TEMPLATE for backfills
- a workflow index for quick scanning
- a watchdog that detects stalls
- a replayer that advances one step in fresh context
- an escalator for repeated promise-without-progress
- validator and smoke-test layers
- crisp daily summary and handoff prompts

## Who it is for

Useful for anyone running Hermes or a similar agent setup who wants durable, restart-proof task state.

## Install

What you need before you start:
- Hermes installed and working
- an Obsidian vault path you want to use
- a place to store the workflow files

There is no npm, Homebrew, or one-line CLI installer for this package yet.
Install it manually by copying the files into your Hermes setup.

1. Copy `SKILL.md` into your Hermes skills directory.
2. Copy `templates/` and `prompts/` into your workflow repo or Obsidian-backed setup.
3. Copy `examples/WORKFLOW-INDEX.md` if you want a starter index.
4. Create and enable the `workflow-validator` job and the `workflow-smoke-test` job.
5. Point the workflow at an Obsidian vault.

See INSTALL.md for the full step-by-step and job setup instructions.

## Quick start

1. Copy the skill into your Hermes skills directory.
2. Copy the templates and example workflow notes.
3. Enable the validator and smoke-test jobs.
4. Use the Obsidian task folder as the source of truth.

## Why it exists

Because long tasks fail quietly when the only state is in chat.
This loop makes the state live in files, not vibes.

## Showcase blurb

A file-first Hermes loop for Obsidian-backed task recovery: watchdog, replayer, escalator, validator, and smoke-test layers that keep work moving after stalls or context loss.
