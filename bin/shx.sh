#!/bin/sh
#
# shx - ShellKitX main executable (dummy version)
#

_print_banner() {
  cat <<"EOF"
     _
 ___| |__ __  __
/ __| '_ \\ \/ /
\__ \ | | |>  <
|___/_| |_/_/\_\

EOF
}

main() {
  _print_banner
}

# Run the main function
main
exit 0
