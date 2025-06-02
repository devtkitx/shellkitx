#!/usr/bin/env bash
# Logging utility for shellkitx
# Supports:
#   --quiet   or SHELLKITX_QUIET=true  → disables all logging
#   --plain   or SHELLKITX_PLAIN=true  → disables emojis and uses classic tags
#   --debug   or SHELLKITX_DEBUG=true  → enables debug logging

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Flags (defaults, can be overridden by CLI or env)
SHELLKITX_QUIET="${SHELLKITX_QUIET:-false}"
SHELLKITX_PLAIN="${SHELLKITX_PLAIN:-false}"
SHELLKITX_DEBUG="${SHELLKITX_DEBUG:-false}"

__parse_logger_flags() {
  for arg in "$@"; do
    case "$arg" in
      --quiet) SHELLKITX_QUIET=true ;;
      --plain) SHELLKITX_PLAIN=true ;;
      --debug) SHELLKITX_DEBUG=true ;;
    esac
  done
}

__log_prefix() {
  level=$1
  if [ "$SHELLKITX_PLAIN" = true ]; then
    case "$level" in
      info) printf '%s' "${YELLOW}[INFO]${NC} " ;;
      success) printf '%s' "${GREEN}[OK]${NC} " ;;
      warn) printf '%s' "${ORANGE}[WARN]${NC} " ;;
      error) printf '%s' "${RED}[ERR]${NC} " ;;
      debug) printf '%s' "${BLUE}[DBG]${NC} " ;;
    esac
  else
    case "$level" in
      info) printf '%s' "${YELLOW}ℹ️ ${NC}" ;;
      success) printf '%s' "${GREEN}✅ ${NC}" ;;
      warn) printf '%s' "${ORANGE}⚠️ ${NC}" ;;
      error) printf '%s' "${RED}❌ ${NC}" ;;
      debug) printf '%s' "${BLUE}🐞 ${NC}" ;;
    esac
  fi
}

log_info() {
  [ "$SHELLKITX_QUIET" = true ] && return
  __log_prefix info
  printf '%s\n' "$*"
}

log_success() {
  [ "$SHELLKITX_QUIET" = true ] && return
  __log_prefix success
  printf '%s\n' "$*"
}

log_warn() {
  [ "$SHELLKITX_QUIET" = true ] && return
  __log_prefix warn
  printf '%s\n' "$*"
}

log_error() {
  [ "$SHELLKITX_QUIET" = true ] && return
  __log_prefix error
  printf '%s\n' "$*" >&2
}

log_debug() {
  [ "$SHELLKITX_DEBUG" = true ] || return
  __log_prefix debug
  printf '%s\n' "$*"
}
