---
name: restart-safe-loop-workflow
description: |
  A live control loop for Hermes agents. Arm it before a task, disarm when done.
  Watchdog, replayer, and escalator layers keep a running task alive through
  stalls, restarts, and context loss. This is not the Obsidian task-resume
  workflow — that is a separate skill for task memory and restart-friendly notes.
metadata:
  author: terry
  version: "0.2.0"
  hermes:
    tags: [workflow, recovery, restart-safe, loop, live-control]
    related_skills: [obsidian-task-resume-workflow]
---

# Restart-Safe Loop Workflow

This is not the normal Obsidian RESUME / CHECKLIST / DOCS workflow.
That workflow is for task memory and restart-friendly notes.
This loop is for live control: arm it, disarm it, and let Hermes keep
watch over a running project with watchdog, replayer, and escalator layers.

If you also use the `obsidian-task-resume-workflow` skill, the loop works
alongside it — but it does not require it. This skill stands on its own.

## Loop controls

- **`/loop-start`** — arms the loop. Sets LOOP-STATE.md to `armed` and the monitoring jobs begin running.
- **`/loop-stop`** — disarms the loop. Sets LOOP-STATE.md to `disarmed` and the monitoring jobs no-op. No wasted tokens.

## When to use

1. `/loop-start` before giving your agent a task
2. Walk away — the loop keeps the task alive
3. `/loop-stop` when the task is done

## What it does

When armed, three automated layers monitor your agent's work:

| Layer | Job name | Schedule | What it does |
|-------|----------|----------|--------------|
| Watchdog | `restart-safe-loop-watchdog` | 15m | Detects stalls and writes a recovery note |
| Replayer | `restart-safe-loop-replayer` | 30m | Takes one concrete step on a stalled task |
| Escalator | `restart-safe-loop-escalator` | 60m | Forces a fresh-session handoff on repeated stalls |

The watchdog writes a WATCHDOG.md when it detects a stall. The replayer picks it up and advances one step. If the same stall keeps repeating, the escalator forces a clean restart.

When disarmed, all three jobs skip immediately with a one-line no-op.

## Canonical naming

Use these names consistently:
- `restart-safe-loop-watchdog`
- `restart-safe-loop-replayer`
- `restart-safe-loop-escalator`

## File layout

The loop state lives in your Obsidian vault (or any directory you point it at):

```
<vault>/Tasks/
  Session-Resume-Workflow/
    LOOP-STATE.md        # armed/disarmed state marker
  <task-name>/
    WATCHDOG.md          # created by watchdog when stall detected
```

## Rules

- The watchdog writes WATCHDOG.md only when it can prove a stall. It does not manufacture problems.
- The replayer takes only one mechanical step per pass. No speculative fixes.
- The escalator acts only after repeated stalls or failed replayer passes.
- When the loop is disarmed, all monitoring jobs no-op immediately.
