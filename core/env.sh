#!/bin/sh
# File: core/env.sh
#
# Environment variables and common path configuration for shellkitx.
# Should be sourced early in execution.

# Prevent multiple sourcing
if [ -n "$__SHELLKITX_ENV_LOADED" ]; then
  return 0
fi
__SHELLKITX_ENV_LOADED=1

# Resolve absolute path to repo root (POSIX-compatible)
SHELLKITX_ROOT=$(cd "$(dirname "$0")/.." && pwd)
export SHELLKITX_ROOT

# Set version (later to be read from a file, e.g., VERSION or package.json)
export SHELLKITX_VERSION="0.1.0"

# Add core bin/ to PATH if not already present
case ":$PATH:" in
  *:"$SHELLKITX_ROOT/bin":*) ;;
  *) PATH="$SHELLKITX_ROOT/bin:$PATH" ;;
esac
export PATH

# Respect CLI arguments parsed before sourcing this file
SHELLKITX_QUIET="${SHELLKITX_QUIET:-false}"
SHELLKITX_PLAIN="${SHELLKITX_PLAIN:-false}"
SHELLKITX_DEBUG="${SHELLKITX_DEBUG:-false}"

# Optionally load .env if present
if [ -f "$SHELLKITX_ROOT/.env" ]; then
  # shellcheck source=/dev/null
  . "$SHELLKITX_ROOT/.env"
fi
