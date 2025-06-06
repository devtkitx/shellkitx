#!/bin/sh
#
# shx/help.sh - Main help for the shx command
#
# This script is executed when 'shx help' (or similar) is called.
# It provides an overview of the shx command, its usage, and available
# top-level commands based on the provided directory structure.

# Source the logger library
# Determine the script's own directory to reliably find the libs directory
_SCRIPT_DIR="$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd)"
# shellcheck source=../libs/logger.sh
. "${_SCRIPT_DIR}/../libs/logger.sh"

# The main command name.
# For consistency and ease of modification, define it as a variable.
CMD_NAME="shx"

_log_info "Usage: ${CMD_NAME} <command> [subcommand] [options...]"
_log_plain ""
_log_plain "A command-line utility with a modular command structure." # You can customize this description
_log_plain ""
_log_info "Available top-level commands:"
_log_plain "  help          Show this help message."

# Autodiscover commands from the script's own directory (_SCRIPT_DIR)
# This directory (PROJECT_ROOT/shx/) is where top-level command scripts and group directories reside.
if [ -d "$_SCRIPT_DIR" ]; then
  for entry in "$_SCRIPT_DIR"/*; do
    entry_basename=$(basename "$entry")

    # Skip the main help.sh script itself
    if [ "$entry_basename" = "help.sh" ]; then
      continue
    fi

    if [ -d "$entry" ]; then
      # Entry is a directory, treat as a command group
      _log_plain "  ${entry_basename}          Commands for managing ${entry_basename}."
    elif [ -f "$entry" ] && [ "${entry_basename##*.}" = "sh" ] && [ -x "$entry" ]; then
      # Entry is an executable .sh file, treat as a direct command
      command_name="${entry_basename%.sh}"
      _log_plain "  ${command_name}          The ${command_name} command."
    fi
  done
fi

_log_plain ""
_log_info "To get help for a specific command or subcommand group, append 'help':"
_log_plain "  ${CMD_NAME} <command> help"
_log_plain "  ${CMD_NAME} <command> <subcommand> help"
_log_plain ""
_log_info "Examples:"
_log_plain "  ${CMD_NAME} self help    # Show help for the 'self' command group and its subcommands."
_log_plain ""

# Consider adding a section for global options if your 'shx' tool supports them.
# echo "Global Options:"
# echo "  --version     Show ${CMD_NAME} version."

exit 0
