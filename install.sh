#!/usr/bin/env bash
set -euo pipefail

# Hermes Memory + Keep-Alive — Installer
# Installs the skill, sets up Obsidian vault, and adds 5 cron jobs.

HERMES_DIR="${HERMES_DIR:-$HOME/.hermes}"
VAULT_PATH=""
SKILL_CATEGORY="note-taking"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Usage ---
usage() {
  echo "Usage: ./install.sh --vault /path/to/your/Obsidian\\ Vault"
  echo ""
  echo "Options:"
  echo "  --vault PATH       Absolute path to your Obsidian vault (required)"
  echo "  --hermes PATH      Hermes home directory (default: ~/.hermes)"
  echo "  --category NAME    Skill category directory (default: note-taking)"
  echo "  --help             Show this help"
  exit 1
}

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --vault)    VAULT_PATH="$2"; shift 2 ;;
    --hermes)   HERMES_DIR="$2"; shift 2 ;;
    --category) SKILL_CATEGORY="$2"; shift 2 ;;
    --help)     usage ;;
    *)          echo "Unknown option: $1"; usage ;;
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
SKILL_DIR="$HERMES_DIR/skills/$SKILL_CATEGORY/hermes-memory-keep-alive"
mkdir -p "$SKILL_DIR/references"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
if [[ -f "$SCRIPT_DIR/references/repo-layout.md" ]]; then
  cp "$SCRIPT_DIR/references/repo-layout.md" "$SKILL_DIR/references/repo-layout.md"
fi
echo "Installed skill to $SKILL_DIR/"

# --- 2. Set up Obsidian vault structure ---
TASKS_DIR="$VAULT_PATH/Tasks/Session-Resume-Workflow"
mkdir -p "$TASKS_DIR"

for file in LOOP-STATE.md TEMPLATE.md; do
  if [[ ! -f "$TASKS_DIR/$file" ]]; then
    cp "$SCRIPT_DIR/templates/$file" "$TASKS_DIR/$file"
    echo "Copied $file to $TASKS_DIR/"
  else
    echo "$file already exists, skipping."
  fi
done

if [[ ! -f "$TASKS_DIR/WORKFLOW-INDEX.md" ]]; then
  cp "$SCRIPT_DIR/examples/WORKFLOW-INDEX.md" "$TASKS_DIR/WORKFLOW-INDEX.md"
  echo "Copied WORKFLOW-INDEX.md to $TASKS_DIR/"
else
  echo "WORKFLOW-INDEX.md already exists, skipping."
fi

# --- 3. Build and merge cron jobs ---
JOBS_FILE="$HERMES_DIR/cron/jobs.json"

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

SKILL_NAME = "hermes-memory-keep-alive"

prompts = {
    "keep-alive-watchdog":  {"prompt": sys.argv[3], "minutes": 15},
    "keep-alive-replayer":  {"prompt": sys.argv[4], "minutes": 30},
    "keep-alive-escalator": {"prompt": sys.argv[5], "minutes": 60},
    "memory-validator":     {"prompt": sys.argv[6], "minutes": 60},
    "memory-smoke-test":    {"prompt": sys.argv[7], "minutes": 360},
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
        "skills": [SKILL_NAME],
        "skill": SKILL_NAME,
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
echo "  - Skill:      $SKILL_DIR/"
echo "  - Vault:      $TASKS_DIR/"
echo "  - Cron jobs:  5 jobs added to $JOBS_FILE"
echo ""
echo "Your agent will now automatically create task notes for every task."
echo "For long tasks, use /loop-start to arm the keep-alive loop."
echo "When done, /loop-stop to stop burning tokens."
