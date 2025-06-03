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
# shellcheck source=../../libs/logger.sh
. "${_SCRIPT_DIR}/../../libs/logger.sh"

# The main command name.
# For consistency and ease of modification, define it as a variable.
CMD_NAME="shx"

_log_info "Usage: ${CMD_NAME} <command> [subcommand] [options...]"
_log_plain ""
_log_plain "A command-line utility with a modular command structure." # You can customize this description
_log_plain ""
_log_info "Available top-level commands:"
_log_plain "  help          Show this help message."
_log_plain "  self          Manage ${CMD_NAME} itself (e.g., update, uninstall)."
# As you add more top-level command files or directories in 'shx/',
# you would list them here.
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
