#!/bin/sh
# File: mods/sys/commands/help.sh
# Description: Help output for the 'sys' module

print_mod_sys_help() {
  log_info "System Module Commands:"
  printf "  %-12s %s\n" "sys help" "Show this help message"
  printf "  %-12s %s\n" "sys init" "Prepare and configure the system"
  printf "  %-12s %s\n" "sys install" "Install system development dependencies"
  printf "  %-12s %s\n" "sys check" "Perform system readiness checks"
}
