#!/usr/bin/env bash
set -euo pipefail

# Hermes Restart-Safe Loop Workflow — Installer
# Copies the skill, templates, and cron jobs into your Hermes setup.

HERMES_DIR="${HERMES_DIR:-$HOME/.hermes}"
VAULT_PATH=""
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Usage ---
usage() {
  echo "Usage: ./install.sh --vault /path/to/your/Obsidian\\ Vault"
  echo ""
  echo "Options:"
  echo "  --vault PATH    Absolute path to your Obsidian vault (required)"
  echo "  --hermes PATH   Hermes home directory (default: ~/.hermes)"
  echo "  --help          Show this help"
  exit 1
}

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --vault)  VAULT_PATH="$2"; shift 2 ;;
    --hermes) HERMES_DIR="$2"; shift 2 ;;
    --help)   usage ;;
    *)        echo "Unknown option: $1"; usage ;;
  esac
done

if [[ -z "$VAULT_PATH" ]]; then
  echo "Error: --vault is required."
  echo ""
  usage
fi

# --- Validate ---
if [[ ! -d "$HERMES_DIR" ]]; then
  echo "Error: Hermes directory not found at $HERMES_DIR"
  echo "Set --hermes to your Hermes home directory."
  exit 1
fi

if [[ ! -d "$HERMES_DIR/cron" ]]; then
  echo "Error: $HERMES_DIR/cron/ not found. Is Hermes initialized?"
  exit 1
fi

# --- 1. Install the skill ---
SKILL_DIR="$HERMES_DIR/skills/restart-safe-loop"
mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "Installed skill to $SKILL_DIR/SKILL.md"

# --- 2. Set up Obsidian vault structure ---
TASKS_DIR="$VAULT_PATH/Tasks/Session-Resume-Workflow"
mkdir -p "$TASKS_DIR"

if [[ ! -f "$TASKS_DIR/TEMPLATE.md" ]]; then
  cp "$SCRIPT_DIR/templates/TEMPLATE.md" "$TASKS_DIR/TEMPLATE.md"
  echo "Copied TEMPLATE.md to $TASKS_DIR/"
else
  echo "TEMPLATE.md already exists, skipping."
fi

if [[ ! -f "$TASKS_DIR/WORKFLOW-INDEX.md" ]]; then
  cp "$SCRIPT_DIR/examples/WORKFLOW-INDEX.md" "$TASKS_DIR/WORKFLOW-INDEX.md"
  echo "Copied WORKFLOW-INDEX.md to $TASKS_DIR/"
else
  echo "WORKFLOW-INDEX.md already exists, skipping."
fi

# --- 3. Build and merge cron jobs ---
JOBS_FILE="$HERMES_DIR/cron/jobs.json"

# Generate the 5 job entries with the user's vault path baked in
WATCHDOG_PROMPT="$(sed "s|VAULT_PATH|$VAULT_PATH|g" "$SCRIPT_DIR/prompts/watchdog-prompt.md")"
REPLAYER_PROMPT="$(sed "s|VAULT_PATH|$VAULT_PATH|g" "$SCRIPT_DIR/prompts/replayer-prompt.md")"
ESCALATOR_PROMPT="$(sed "s|VAULT_PATH|$VAULT_PATH|g" "$SCRIPT_DIR/prompts/escalator-prompt.md")"
VALIDATOR_PROMPT="$(sed "s|VAULT_PATH|$VAULT_PATH|g" "$SCRIPT_DIR/prompts/validator-prompt.md")"
SMOKETEST_PROMPT="$(sed "s|VAULT_PATH|$VAULT_PATH|g" "$SCRIPT_DIR/prompts/smoke-test-prompt.md")"

NOW="$(date -u +"%Y-%m-%dT%H:%M:%S.000000+00:00")"

python3 - "$JOBS_FILE" "$NOW" \
  "$WATCHDOG_PROMPT" "$REPLAYER_PROMPT" "$ESCALATOR_PROMPT" \
  "$VALIDATOR_PROMPT" "$SMOKETEST_PROMPT" <<'PYEOF'
import json, sys, secrets, os

jobs_file = sys.argv[1]
now = sys.argv[2]
prompts = {
    "workflow-watchdog":    {"prompt": sys.argv[3], "minutes": 15},
    "workflow-replayer":    {"prompt": sys.argv[4], "minutes": 30},
    "workflow-escalator":   {"prompt": sys.argv[5], "minutes": 60},
    "workflow-validator":   {"prompt": sys.argv[6], "minutes": 60},
    "workflow-smoke-test":  {"prompt": sys.argv[7], "minutes": 360},
}

# Load existing jobs
if os.path.exists(jobs_file):
    with open(jobs_file) as f:
        data = json.load(f)
else:
    data = {"jobs": []}

existing_names = {j["name"] for j in data["jobs"]}
added = []
skipped = []

for name, info in prompts.items():
    if name in existing_names:
        skipped.append(name)
        continue
    job = {
        "id": secrets.token_hex(6),
        "name": name,
        "prompt": info["prompt"],
        "skills": [],
        "skill": None,
        "model": None,
        "provider": None,
        "base_url": None,
        "schedule": {
            "kind": "interval",
            "minutes": info["minutes"],
            "display": f"every {info['minutes']}m"
        },
        "schedule_display": f"every {info['minutes']}m",
        "repeat": {"times": None, "completed": 0},
        "enabled": True,
        "state": "scheduled",
        "paused_at": None,
        "paused_reason": None,
        "created_at": now,
        "next_run_at": now,
        "last_run_at": None,
        "last_status": None,
        "last_error": None,
        "deliver": "origin",
        "origin": None,
    }
    data["jobs"].append(job)
    added.append(name)

with open(jobs_file, "w") as f:
    json.dump(data, f, indent=2)

for name in added:
    print(f"  Added job: {name}")
for name in skipped:
    print(f"  Skipped (already exists): {name}")
PYEOF

echo ""
echo "Done. Installed:"
echo "  - Skill:     $SKILL_DIR/SKILL.md"
echo "  - Template:  $TASKS_DIR/TEMPLATE.md"
echo "  - Index:     $TASKS_DIR/WORKFLOW-INDEX.md"
echo "  - Cron jobs: $JOBS_FILE"
echo ""
echo "Verify by asking Hermes: \"Run the workflow smoke test now.\""
