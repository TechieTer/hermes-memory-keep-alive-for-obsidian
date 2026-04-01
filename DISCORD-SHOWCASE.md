# Hermes Projects Showcase Post

I packaged a restart-safe Hermes loop workflow for Obsidian-backed task recovery, and I think it’s the kind of thing people will actually use.

It includes:
- watchdog, replayer, and escalator layers
- validator and smoke-test jobs
- a canonical template for backfilling missing notes
- a workflow index for quick scanning
- crisp daily handoff prompts

Install is manual for now, but it’s still pretty simple:
- copy the skill into your Hermes skills directory
- copy the templates and prompts into your workflow setup
- create the `workflow-validator` and `workflow-smoke-test` jobs
- point it at your Obsidian vault

If you’ve ever had a long task quietly drift off the rails after a restart or a stall, this loop is meant to keep that from happening.
