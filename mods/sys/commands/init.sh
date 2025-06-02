#!/bin/sh
# File: mods/sys/commands/init.sh
# Description: Initializes system settings

run_sys_init() {
  log_info "Starting system initialization..."

  # Check if running as root or with sudo privileges
  if [ "$(id -u)" -ne 0 ]; then
    log_error "This script requires root privileges. Please run with sudo."
    exit 1
  fi

  # Update apt repository index
  log_info "Updating package index..."
  if apt-get update -qq; then
    log_success "Package index updated."
  else
    log_error "Failed to update package index."
    exit 1
  fi

  # Upgrade installed packages to latest versions
  log_info "Upgrading installed packages..."
  if apt-get upgrade -y >/dev/null 2>&1; then
    log_success "Packages upgraded successfully."
  else
    log_error "Package upgrade failed."
    exit 1
  fi

  # Create essential directories if missing
  for dir in /etc/devkitx /var/log/devkitx; do
    if [ ! -d "$dir" ]; then
      log_info "Creating directory $dir"
      if mkdir -p "$dir"; then
        log_success "Created $dir"
      else
        log_error "Failed to create $dir"
        exit 1
      fi
    else
      log_info "Directory $dir already exists."
    fi
  done

  # Set timezone to UTC as default (optional)
  log_info "Setting timezone to UTC..."
  if timedatectl set-timezone UTC >/dev/null 2>&1; then
    log_success "Timezone set to UTC."
  else
    log_error "Failed to set timezone."
  fi

  log_success "System initialization complete."
}
