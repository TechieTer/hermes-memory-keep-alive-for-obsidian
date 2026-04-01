---
name: restart-safe-loop
description: |
  A restart-safe recovery loop for Obsidian-backed Hermes tasks.
  Keeps durable task state in RESUME / CHECKLIST / DOCS notes,
  detects stalls with a watchdog, advances work with a replayer,
  escalates repeated failures, and validates note integrity automatically.
metadata:
  author: terry
  version: "0.1.0"
  hermes:
    tags: [workflow, recovery, obsidian, restart-safe, task-management]
    related_skills: []
---

# Restart-Safe Loop Workflow

Use this skill when you need a durable, restart-proof task loop backed by Obsidian notes.

## What it does

Keeps the state of long-running tasks in files instead of chat, then wraps them with automated recovery layers.

Every task lives in its own folder under your Obsidian vault's `Tasks/` directory with three core notes:
- **RESUME.md** - status, heartbeat, next action, key files, restart note
- **CHECKLIST.md** - step-by-step progress with verification
- **DOCS.md** - goal, decisions, gotchas, notes for the next session

A **WORKFLOW-INDEX.md** provides the single source of truth for scanning all active and completed tasks.

## Recovery layers

The loop uses five automated layers, each running as a Hermes cron job:

1. **Watchdog** (every 15m) - detects stalled tasks and promise-without-progress patterns. Writes a WATCHDOG.md recovery note with the blocker, a why-stalled tag, and the next action.
2. **Replayer** (every 30m) - takes exactly one concrete step on a stalled task using fresh context. If the step is ambiguous, updates the notes and stops.
3. **Escalator** (every 60m) - handles repeated stalls by forcing a fresh-session handoff with the strongest next action.
4. **Validator** (every 60m) - inspects task folders for missing notes, backfills from the canonical template, refreshes the workflow index.
5. **Smoke test** (every 360m) - verifies the workflow itself is healthy: core notes exist, template exists, jobs are enabled, at least one task has a heartbeat.

## When to use

- Any long-running task that could stall silently after a restart or context loss
- Multi-step work where state needs to survive across sessions
- When you want automated detection and recovery of stuck tasks

## File layout

```
<vault>/Tasks/
  Session-Resume-Workflow/
    TEMPLATE.md          # canonical template for new task folders
    WORKFLOW-INDEX.md    # quick-scan index of all tasks
  <task-name>/
    RESUME.md
    CHECKLIST.md
    DOCS.md
    WATCHDOG.md          # created by watchdog when stall detected
```

## Rules

- Every active task folder must have RESUME.md, CHECKLIST.md, and DOCS.md.
- RESUME.md must have a `Last heartbeat` and a `Next action`.
- A heartbeat older than 24 hours or a missing next action means the task is stale.
- The validator auto-creates missing notes from the canonical template.
- The watchdog writes WATCHDOG.md only when it can prove a stall. It does not manufacture problems.
- The replayer takes only one mechanical step per pass. No speculative fixes.
- The escalator acts only after repeated stalls or failed replayer passes.
