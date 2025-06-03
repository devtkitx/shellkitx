# Makefile for the shx project

# Find all .sh files in the bin directory
SHELL_SCRIPTS := $(wildcard bin/*.sh)

.PHONY: all executables clean

all: executables

executables:
	@echo "Making shell scripts in bin/ executable..."
	@chmod +x $(SHELL_SCRIPTS)
	@echo "Scripts in bin/ are now executable."
