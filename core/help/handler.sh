#!/bin/sh
# File: core/help/handler.sh
#
# Main help printer for the shellkitx CLI.
# Prints global usage instructions, supports --quiet and --plain modes.

print_main_help() {
  [ "${SHELLKITX_QUIET:-false}" = "true" ] && return 0

  if [ "${SHELLKITX_PLAIN:-false}" = "true" ]; then
    printf '%s\n' 'shellkitx - Modular Shell CLI Toolkit'
    printf '\n'
    printf '%s\n' 'Usage:'
    printf '  shellkitx <command> <action> [options]\n'
    printf '\n'
    printf '%s\n' 'Available Commands:'
    printf '  help       Show help and usage examples\n'
    printf '  mod        Install, list or remove shellkitx mods\n'
    printf '  sys        Setup system-level development tools\n'
    printf '\n'
    printf '%s\n' 'Options:'
    printf '  --quiet    Suppress all output\n'
    printf '  --plain    Disable colored or emoji output\n'
    printf '\n'
    printf '%s\n' 'Examples:'
    printf '  shellkitx mod install https://github.com/user/mod\n'
    printf '  shellkitx sys install\n'
  else
    printf '\033[1;36m%s\033[0m\n' '🛠️  shellkitx - Modular Shell CLI Toolkit'
    printf '\n'
    printf '📦 \033[1m%s\033[0m\n' 'Usage:'
    printf '  shellkitx <command> <action> [options]\n'
    printf '\n'
    printf '📚 \033[1m%s\033[0m\n' 'Available Commands:'
    printf '  help       Show help and usage examples\n'
    printf '  mod        Install, list or remove shellkitx mods\n'
    printf '  sys        Setup system-level development tools\n'
    printf '\n'
    printf '⚙️  \033[1m%s\033[0m\n' 'Options:'
    printf '  --quiet    Suppress all output\n'
    printf '  --plain    Disable colored or emoji output\n'
    printf '\n'
    printf '🚀 \033[1m%s\033[0m\n' 'Examples:'
    printf '  shellkitx mod install https://github.com/user/mod\n'
    printf '  shellkitx sys install\n'
  fi
}
