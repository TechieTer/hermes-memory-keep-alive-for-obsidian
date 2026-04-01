---
name: restart-safe-loop-workflow
description: |
  Package and maintain a separate Hermes keep-live loop workflow.
  Use when you want native /loop-start and /loop-stop controls, watchdog/replayer/escalator layers,
  validator and smoke-test jobs, and a restart-safe loop that is distinct from the normal
  Obsidian RESUME/CHECKLIST/DOCS task-resume workflow.
metadata:
  author: terry
  version: "0.2.0"
  hermes:
    tags: [workflow, recovery, obsidian, restart-safe, task-management, loop]
    related_skills: [obsidian-task-resume-workflow]
---

# Restart-Safe Loop Workflow

Use this skill when packaging or operating the keep-live loop itself.
It is separate from the normal Obsidian task-resume workflow.

## Not the resume workflow

Do not use this skill as a replacement for `obsidian-task-resume-workflow`.
That skill owns the usual RESUME.md, CHECKLIST.md, and DOCS.md task notes.
This skill owns the live loop: arming, disarming, watchdogs, replayers,
escalation, and the validator/smoke-test guard rails.

## Loop controls

- `/loop-start` — arms the loop. Sets LOOP-STATE.md to `armed` and enables the watchdog/replayer/escalator jobs.
- `/loop-stop` — disarms the loop. Sets LOOP-STATE.md to `disarmed` and the monitoring jobs pause or no-op.

The loop state lives in `Tasks/Session-Resume-Workflow/LOOP-STATE.md`.

## Canonical naming

Use the restart-safe loop names consistently:
- `restart-safe-loop-watchdog`
- `restart-safe-loop-replayer`
- `restart-safe-loop-escalator`
- `workflow-validator`
- `workflow-smoke-test`

Avoid the old Ralph Loop wording in prompts, docs, and output.

## What it packages

- native `/loop-start` and `/loop-stop` controls
- a loop state marker for armed/disarmed mode
- a watchdog / replayer / escalator chain
- validator and smoke-test layers
- optional Obsidian-facing handoff notes when paired with the resume workflow
- crisp loop prompts that are short, factual, and restart-safe

## Recovery layers

The loop uses five automated layers, each running as a Hermes cron job:

1. **Watchdog** (every 15m) — detects stalled tasks and promise-without-progress patterns. Writes a WATCHDOG.md recovery note with the blocker, a why-stalled tag, and the next action.
2. **Replayer** (every 30m) — takes exactly one concrete step on a stalled task using fresh context. If the step is ambiguous, updates the notes and stops.
3. **Escalator** (every 60m) — handles repeated stalls by forcing a fresh-session handoff with the strongest next action.
4. **Validator** (every 60m) — inspects task folders for missing notes, backfills from the canonical template, refreshes the workflow index.
5. **Smoke test** (every 360m) — verifies the workflow itself is healthy: core notes exist, template exists, jobs are enabled, at least one task has a heartbeat.

## When to use

- Any long-running task that could stall silently after a restart or context loss
- Multi-step work where state needs to survive across sessions
- When you want automated detection and recovery of stuck tasks
- When publishing a Hermes-ready loop to GitHub or sharing in Discord

## File layout

```
<vault>/Tasks/
  Session-Resume-Workflow/
    TEMPLATE.md          # canonical template for new task folders
    WORKFLOW-INDEX.md    # quick-scan index of all tasks
    LOOP-STATE.md        # armed/disarmed state marker
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
- When the loop is disarmed, monitoring jobs should pause or no-op.
