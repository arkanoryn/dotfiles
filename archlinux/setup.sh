#!/usr/bin/env bash
set -euo pipefail

# Source the utilities for consistent logging and functions
UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup_scripts"
source "${UTILS_DIR}/utils.sh"

# Configuration - now using shared utilities
# tmp_path and logfile_path are defined in utils.sh
qmk_path="${HOME}/Code/qmk"

# Create temporary directory and initialize log file
mkdir -p "${UTILS_TMP_PATH}"
log "Starting Arch Linux setup..."
echo -e "\n=== Arch Linux Setup ==="
echo "Log file: ${UTILS_LOGFILE_PATH}"
echo "Starting at: $(date +'%Y-%m-%d %H:%M:%S')"
echo "=======================\n"

# Check if paru is installed
check_paru_installed() {
  if command -v paru &>/dev/null; then
    return 0
  else
    return 1
  fi
}

# Main menu
echo -e "\n🚀 Arch Linux Setup Menu\n"
echo "This script will guide you through setting up your Arch Linux system."
echo "You can choose which components to install.\n"

echo "Available setup options:"
echo "1. Basic Arch Linux setup (recommended - includes paru installation)"
echo "2. Hyprland setup (window manager - requires paru)"
echo "3. Applications setup (terminal tools, browsers - requires paru)"
echo "4. All of the above (recommended for full setup)"
echo "5. Exit"

read -p "Enter your choice (1-5): " setup_choice
echo

case $setup_choice in
1)
  log "Running basic Arch Linux setup..."
  echo "📦 Running basic Arch Linux setup..."
  source "${UTILS_DIR}/arch_default.sh"
  ;;
2)
  if check_paru_installed; then
    log "Running Hyprland setup..."
    echo "🖥️ Running Hyprland setup..."
    source "${UTILS_DIR}/hyprland.sh"
  else
    error "Hyprland setup requires paru to be installed. Please run option 1 first or install paru manually."
    exit 1
  fi
  ;;
3)
  if check_paru_installed; then
    log "Running applications setup..."
    echo "📱 Running applications setup..."
    source "${UTILS_DIR}/apps.sh"
  else
    error "Applications setup requires paru to be installed. Please run option 1 first or install paru manually."
    exit 1
  fi
  ;;
4)
  log "Running complete setup..."
  echo "🔧 Running complete setup..."

  # Basic setup (this includes paru installation option)
  echo -e "\n📦 Basic Arch Linux setup..."
  source "${UTILS_DIR}/arch_default.sh"

  # Check if paru was installed during basic setup
  if check_paru_installed; then
    # Hyprland setup
    echo -e "\n🖥️ Hyprland setup..."
    source "${UTILS_DIR}/hyprland.sh"

    # Applications setup
    echo -e "\n📱 Applications setup..."
    source "${UTILS_DIR}/apps.sh"
  else
    error "paru is required for Hyprland and Applications setup but was not installed."
    echo "Please install paru manually and re-run the complete setup."
    exit 1
  fi
  ;;
5)
  echo "Setup cancelled."
  exit 0
  ;;
*)
  error "Invalid choice: $setup_choice"
  exit 1
  ;;
esac

echo -e "\n[✅] Arch Linux setup completed successfully!"
echo "Setup finished at: $(date +'%Y-%m-%d %H:%M:%S')"
echo "Log file available at: ${UTILS_LOGFILE_PATH}"
log "Arch Linux setup completed"

