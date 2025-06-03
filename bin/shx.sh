#!/bin/sh
#
# shx - ShellKitX main executable
#

# Determine script's own directory and project root
# This assumes shx.sh is in a subdirectory (e.g., bin) of the project root.
_SETUP_SCRIPT_DIR="$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd)"
_SHX_ROOT_DIR="$(dirname -- "$_SETUP_SCRIPT_DIR")" # Project root is one level above script's dir (bin)

# Source logger
# shellcheck source=../libs/logger.sh # Path relative to this file for shellcheck
. "${_SHX_ROOT_DIR}/libs/logger.sh"

# --- Logger Configuration (can be controlled by env vars or global flags) ---
# Example: If SHX_LOG_PLAIN is set, disable emojis.
# The logger.sh script itself sets a default for _USE_EMOJI_LOGS.
# This main script (shx.sh) could override it based on global flags or env vars.
# For instance:
# if [ "${SHX_LOG_PLAIN}" = "true" ] || [ "$1" = "--plain-logs" ]; then
#   _USE_EMOJI_LOGS="false"
#   # Potentially shift away the --plain-logs flag if it's a global one
# fi

_print_banner() {
  cat <<"EOF"
     _
 ___| |__ __  __
/ __| '_ \\ \/ /
\__ \ | | |>  <
|___/_| |_/_/\_\
EOF
}

_execute_command_script() {
  script_path="$1" # SC3043: 'local' is not POSIX sh
  shift            # Remove script_path from arguments
  if [ -f "$script_path" ] && [ -x "$script_path" ]; then
    "$script_path" "$@" # Execute with remaining arguments
    return $?
  elif [ -f "$script_path" ]; then
    _log_error "Command script '$script_path' is not executable. Please check permissions."
    return 126 # Standard exit code for command invoked cannot execute
  else
    _log_error "Command script '$script_path' not found."
    return 127 # Standard exit code for command not found
  fi
}

main() {
  _print_banner

  # If no arguments are provided, default to "help".
  if [ $# -eq 0 ]; then
    set -- "help" # Modifies $1, $2, ..., $@
  fi

  COMMAND="$1"
  shift # Remove the main command from arguments, $@ now contains sub-args for the command

  case "$COMMAND" in
    "help" | "-h" | "--help")
      _execute_command_script "${_SHX_ROOT_DIR}/shx/help.sh" "$@"
      exit $?
      ;;
    "self")
      _log_error "Command group 'self' is a placeholder. Subcommands are not yet wired into the main shx script."
      _log_plain "You would typically call specific subcommands like 'shx self update' or 'shx self help'."
      "${_SHX_ROOT_DIR}/shx/help.sh" # Show general help as 'self' itself is not directly runnable
      exit 1
      ;;
    *)
      _log_error "Unknown command: $COMMAND"
      _log_plain ""                  # Add a blank line for readability before showing help
      "${_SHX_ROOT_DIR}/shx/help.sh" # Show general help
      exit 127                       # Common exit code for command not found
      ;;
  esac
}

# Run the main function
main "$@"
# The 'main' function is responsible for exiting with the correct status code.
