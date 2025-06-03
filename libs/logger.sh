#!/bin/sh
# --- Logging Functions Library ---

# --- Configuration Variable ---
# _USE_EMOJI_LOGS: Controls the logging style.
#   - "true" (default): Use emojis in log messages.
#   - "false": Use plain text prefixes (e.g., "[INFO]").
#
# This script sets a default value. The sourcing script can override
# _USE_EMOJI_LOGS after sourcing this file but before calling log functions
# to change the logging style.
#
# Example in the sourcing script:
#   . /path/to/this/logger.sh # Sources this file
#   if [ "${YOUR_ENV_VAR_FOR_PLAIN_LOGS}" = "true" ] || [ "$1" = "--plain" ]; then
#     _USE_EMOJI_LOGS="false" # Override the default
#   fi
_USE_EMOJI_LOGS="true"

# --- Helper Functions ---
_log_info() {
  if [ "$_USE_EMOJI_LOGS" = "true" ]; then
    printf "ℹ️  %s\n" "$1"
  else
    printf "[INFO] %s\n" "$1"
  fi
}

_log_success() {
  if [ "$_USE_EMOJI_LOGS" = "true" ]; then
    printf "✅ %s\n" "$1"
  else
    printf "[OKAY] %s\n" "$1"
  fi
}

_log_error() {
  if [ "$_USE_EMOJI_LOGS" = "true" ]; then
    printf "❌ %s\n" "$1" >&2
  else
    printf "[ERROR] %s\n" "$1" >&2
  fi
}

_log_warning() {
  if [ "$_USE_EMOJI_LOGS" = "true" ]; then
    printf "⚠️  %s\n" "$1" >&2
  else
    printf "[WARN] %s\n" "$1" >&2
  fi
}

# --- Plain Text Logger ---
# Always prints the message as is, without emojis or prefixes.
_log_plain() {
  printf "%s\n" "$1"
}
