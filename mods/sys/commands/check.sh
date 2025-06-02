#!/bin/sh
# File: mods/sys/commands/check.sh
# Description: Validates required system dependencies

run_sys_check() {
  log_info "Checking system requirements..."

  _check_command git
  _check_command curl
  _check_command gcc

  log_success "System check passed."
}

# Check if a command exists in PATH
_check_command() {
  cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    log_info "Dependency '$cmd' is installed."
  else
    log_error "Dependency '$cmd' is missing."
    exit 1
  fi
}
