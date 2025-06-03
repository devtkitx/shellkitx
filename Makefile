# Makefile for the shx project

# Find all .sh files in the bin directory
BIN_SHELL_SCRIPTS := $(wildcard bin/*.sh)
SUBCOMMAND_SHELL_SCRIPTS := $(wildcard shx/*.sh) # Scripts in the root 'shx' dir

.PHONY: main executables clean

main: executables

executables:
	@echo "Making shell scripts in 'bin/' executable..."
	@chmod +x $(BIN_SHELL_SCRIPTS)
	@echo "Making shell scripts in 'shx/' (subcommands) executable..."
	@chmod +x $(SUBCOMMAND_SHELL_SCRIPTS)
	@echo "Scripts are now executable."
