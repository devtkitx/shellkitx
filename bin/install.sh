#!/bin/sh
# Installer script for shellkitx

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Replace this with the actual Git repository URL for shellkitx
SHX_REPO_URL="https://github.com/yourusername/shx.git" # hypothetical, update if your repo URL changes

# Installation directory for the shellkitx repository
INSTALL_BASE_DIR="/opt"
SHX_INSTALL_DIR="${INSTALL_BASE_DIR}/shx"

# Directory where the executable link will be placed (must be in PATH)
BIN_DIR="/usr/local/bin"
EXECUTABLE_NAME="shx"

# --- Helper Functions ---
_print_prefix() {
  printf "%s" "$1"
}

_log_info() {
  _print_prefix "ℹ️  "
  printf "%s\n" "$1"
}

_log_success() {
  _print_prefix "✅ "
  printf "%s\n" "$1"
}

_log_error() {
  _print_prefix "❌ "
  printf "%s\n" "$1" >&2
}

_log_warning() {
  _print_prefix "⚠️  "
  printf "%s\n" "$1" >&2
}

_print_banner() {
  cat <<"EOF"
     _
 ___| |__ __  __
/ __| '_ \\ \/ /
\__ \ | | |>  <
|___/_| |_/_/\_\

EOF
  _log_info "Welcome to the shx installer!"
}

_sudo_prompt_exec() (
  reason_msg="$1"
  shift # Remove the reason_msg from arguments, the rest are the command and its args
  # Print to stdout, consistent with previous informational messages about sudo
  printf "Sudo privileges are required %s.\n" "$reason_msg"
  sudo "$@"
)

# --- Installation Functions ---
_ensure_git_installed() {
  _log_info "Checking for Git..."
  if ! command -v git >/dev/null 2>&1; then
    _log_warning "Git is not installed."
    printf "Would you like to try and install Git now? This will require sudo privileges. (y/N): "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
      _log_info "Attempting to install Git..."
      if command -v apt-get >/dev/null 2>&1; then
        _sudo_prompt_exec "to update package lists via apt-get" apt-get update
        _sudo_prompt_exec "to install git via apt-get" apt-get install -y git
      elif command -v yum >/dev/null 2>&1; then
        _sudo_prompt_exec "to install git via yum" yum install -y git
      elif command -v dnf >/dev/null 2>&1; then
        _sudo_prompt_exec "to install git via dnf" dnf install -y git
      elif command -v pacman >/dev/null 2>&1; then
        _sudo_prompt_exec "to install git via pacman" pacman -S --noconfirm git
      elif command -v brew >/dev/null 2>&1; then
        brew install git # Brew typically does not require sudo
      else
        _log_error "Could not determine package manager. Please install Git manually and re-run this script."
        exit 1
      fi
      if ! command -v git >/dev/null 2>&1; then
        _log_error "Git installation failed. Please install Git manually and re-run this script."
        exit 1
      fi
      _log_success "Git installed successfully."
    else
      _log_error "Git is required to install shx. Please install Git and re-run this script."
      exit 1
    fi
  else
    _log_success "Git is already installed."
  fi
}

_setup_repository() {
  _log_info "Setting up shx repository in ${SHX_INSTALL_DIR}..."
  if [ -d "${SHX_INSTALL_DIR}/.git" ]; then
    _log_info "Existing shx installation found. Attempting to update..."
    printf "This will require sudo privileges if you are not the owner of %s.\n" "${SHX_INSTALL_DIR}"
    (cd "${SHX_INSTALL_DIR}" && sudo git pull) || {
      _log_error "Failed to update shx. Please check permissions or try removing ${SHX_INSTALL_DIR} and re-running."
      exit 1
    }
    _log_success "shx updated successfully."
  else
    if [ -d "${SHX_INSTALL_DIR}" ]; then
      _log_warning "${SHX_INSTALL_DIR} exists but is not a git repository. It will be removed."
      printf "This will require sudo privileges.\n"
      sudo rm -rf "${SHX_INSTALL_DIR}"
    fi
    _log_info "Cloning shx from ${SHX_REPO_URL}..."
    printf "This will require sudo privileges to write to %s.\n" "${INSTALL_BASE_DIR}"
    sudo git clone --depth 1 "${SHX_REPO_URL}" "${SHX_INSTALL_DIR}"
    _log_success "shx cloned successfully."
  fi
}

_setup_executable() {
  SCRIPT_IN_REPO="${SHX_INSTALL_DIR}/bin/${EXECUTABLE_NAME}.sh"

  if [ ! -f "$SCRIPT_IN_REPO" ]; then
    _log_error "The shx executable was not found at ${SCRIPT_IN_REPO} after cloning."
    _log_error "Please check the repository structure."
    exit 1
  fi

  _log_info "Making ${EXECUTABLE_NAME} executable..."
  printf "This will require sudo privileges.\n"
  sudo chmod +x "$SCRIPT_IN_REPO"

  _log_info "Creating symbolic link in ${BIN_DIR}..."
  if [ ! -d "$BIN_DIR" ]; then
    _log_warning "${BIN_DIR} does not exist. Attempting to create it."
    printf "This will require sudo privileges.\n"
    sudo mkdir -p "$BIN_DIR"
  fi
  printf "This will require sudo privileges to create the symlink.\n"
  sudo ln -sf "$SCRIPT_IN_REPO" "${BIN_DIR}/${EXECUTABLE_NAME}"

  if command -v "$EXECUTABLE_NAME" >/dev/null 2>&1 && [ -L "${BIN_DIR}/${EXECUTABLE_NAME}" ]; then
    _log_success "shx executable is now linked to ${BIN_DIR}/${EXECUTABLE_NAME} and available in your PATH."
  else
    _log_error "Failed to make shx available in PATH. Check if ${BIN_DIR} is in your PATH."
    exit 1
  fi
}

# --- Main Execution ---
main() {
  # 0. Print Banner
  _print_banner

  # 1. Check for Git and install if necessary
  _ensure_git_installed

  # 2. Clone or update the shellkitx repository
  _setup_repository

  # 3. Make shellkitx executable and link to BIN_DIR
  _setup_executable

  _log_info "\n🎉 shx installation/update complete!"
  _log_info "You can now start using shx. Try running: shx init"
}

# Run the installer
main

exit 0
