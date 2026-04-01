---
name: restart-safe-loop-workflow
description: |
  Package and maintain a restart-safe Hermes loop workflow for Obsidian-backed task recovery.
  Use when you want a reusable, GitHub-ready workflow that keeps durable task state in notes,
  detects stalls, rehydrates work in fresh context, and hardens the loop with validator and smoke-test layers.
metadata:
  author: carrie
  version: "0.1.0"
---

# Restart-Safe Loop Workflow

Use this skill when packaging a Hermes loop system for reuse, sharing, or GitHub publication.

## What it packages

- Obsidian task folders with RESUME.md, CHECKLIST.md, DOCS.md
- a canonical TEMPLATE.md for auto-backfill
- a WORKFLOW-INDEX.md for quick scanning
- a watchdog / replayer / escalator chain
- validator and smoke-test layers
- crisp daily summary and handoff prompts

## When to use

Use this skill when you want to:
- turn a working restart-safe workflow into a reusable package
- publish a Hermes-ready loop to GitHub
- create a showcase-friendly repo for Discord or community sharing
- standardize the loop so other users can copy it cleanly

## Packaging steps

1. Collect the stable workflow notes.
2. Write a short README explaining what the loop does and who it helps.
3. Include the canonical templates and example folder structure.
4. Include the validator, smoke-test, and stall-recovery prompts.
5. Keep the docs short, practical, and copyable.
6. Make the repo easy to scan in under a minute.

## Recommended repo layout

- README.md
- SKILL.md
- examples/
- templates/
- prompts/
- references/

## Recommended content

README.md should explain:
- the problem it solves
- the core loop
- the fail-safe layers
- how to install or copy it
- a tiny quick-start example

## Sharing guidance

Keep the public package:
- concise
- friendly
- easy to fork
- explicit about the Obsidian dependency
- clear that it is designed for restart resilience

## Install messaging to include

Be honest that there is no npm/Homebrew one-line installer yet.
Tell users to create two jobs:
- workflow-validator
- workflow-smoke-test

Mention the suggested schedules and that they should use the prompts from `prompts/`.

## Quality bar

A good package should let another Hermes user understand the workflow and copy it without a long back-and-forth.
