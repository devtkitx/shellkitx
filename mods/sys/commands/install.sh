#!/bin/sh
# File: mods/sys/commands/install.sh
# Description: Installs core development tools using apt

run_sys_install() {
  log_info "Installing system packages required for development..."

  _ensure_apt_updated
  _install_pkg git
  _install_pkg curl
  _install_pkg build-essential
  _install_pkg ca-certificates
  _install_pkg gnupg
  _install_pkg software-properties-common

  log_success "System installation complete."
}

# Ensure 'apt-get update' is run once per session
_ensure_apt_updated() {
  if [ -z "${__APT_UPDATED:-}" ]; then
    log_info "Updating apt package index..."
    if apt-get update -qq; then
      log_success "apt-get update successful."
      __APT_UPDATED=1
    else
      log_error "Failed to update apt index."
      exit 1
    fi
  fi
}

# Install package only if not already installed
_install_pkg() {
  pkg="$1"
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    log_info "$pkg already installed."
  else
    log_info "Installing $pkg..."
    if apt-get install -y "$pkg" >/dev/null; then
      log_success "$pkg installed."
    else
      log_error "Failed to install $pkg."
      exit 1
    fi
  fi
}
