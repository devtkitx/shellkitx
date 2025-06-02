#!/bin/sh
# File: bin/shellkitx.sh
#
# Main executable script for the shellkitx CLI tool.
# Located in the 'bin/' directory at the project root.
#
# Usage:
#   shellkitx <command> <action> [options]

set -eu

# Clear the terminal
clear

# Print banner ASCII art
cat <<'EOF'
 ____  _          _ _ _  ___ _
/ ___|| |__   ___| | | |/ (_) |___  __
\___ \| '_ \ / _ \ | | ' /| | __\ \/ /
 ___) | | | |  __/ | | . \| | |_ >  <
|____/|_| |_|\___|_|_|_|\_\_|\__/_/\_\

EOF

# Root directory of shellkitx (one level up from this script)
SHELLKITX_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODS_DIR="$HOME/.shellkitx/mods"

# Initialize flags
SHELLKITX_QUIET=0
SHELLKITX_PLAIN=0

# Parse flags --quiet and --plain before commands
while [ $# -gt 0 ]; do
  case "$1" in
    --quiet)
      SHELLKITX_QUIET=1
      shift
      ;;
    --plain)
      SHELLKITX_PLAIN=1
      shift
      ;;
    *)
      break
      ;;
  esac
done

# Export for use in sourced scripts
export SHELLKITX_QUIET SHELLKITX_PLAIN

# Load core libraries with shellcheck directives for path awareness
# shellcheck source=../core/env.sh
. "$SHELLKITX_ROOT/core/env.sh"
# shellcheck source=../core/utils/logger.sh
. "$SHELLKITX_ROOT/core/utils/logger.sh"
# shellcheck source=../core/help/handler.sh
. "$SHELLKITX_ROOT/core/help/handler.sh"

load_installed_mods() {
  # List all directories inside mods directory
  # POSIX sh lacks nullglob, so we must check if glob matches something
  # Use a for loop with test inside
  if [ -d "$MODS_DIR" ]; then
    for mod_path in "$MODS_DIR"/*; do
      if [ ! -e "$mod_path" ]; then
        # No files matched the glob, skip
        break
      fi

      if [ -d "$mod_path" ] && [ -f "$mod_path/module.json" ]; then
        if [ -f "$mod_path/commands/init.sh" ]; then
          # shellcheck source=/dev/null
          . "$mod_path/commands/init.sh"
        fi
      fi
    done
  fi
}

load_installed_mods

COMMAND="${1:-help}"
ACTION="${2:-help}"

# Shift the command and action arguments if present
if [ $# -gt 0 ]; then shift; fi
if [ $# -gt 0 ]; then shift; fi

COMMAND_SCRIPT="$SHELLKITX_ROOT/commands/$COMMAND/$ACTION.sh"

if [ -f "$COMMAND_SCRIPT" ]; then
  # shellcheck source=/dev/null
  . "$COMMAND_SCRIPT"
  run "$@"
  exit 0
else
  FUNC="run_${COMMAND}_${ACTION}"
  if command -v "$FUNC" >/dev/null 2>&1; then
    "$FUNC" "$@"
    exit 0
  fi
fi

print_main_help
exit 1
