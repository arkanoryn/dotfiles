#!/usr/bin/env bash
set -euo pipefail

# Source the utilities
UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${UTILS_DIR}/utils.sh"

log "Starting Hyprland setup..."
echo "Starting Hyprland setup..."

# Install packages with pacman
log "Installing packages with pacman..."
(
  sudo pacman -S --noconfirm --needed \
    libnotify \
    pamixer \
    pavucontrol \
    swaync \
    quickshell \
    waybar >>"${UTILS_LOGFILE_PATH}" 2>&1
) &
show_progress "Installing packages with pacman..." $!

# Install walker from source
log "Installing walker from source..."
if cd "${UTILS_TMP_PATH}" && git clone https://github.com/abenz1267/walker.git >>"${UTILS_LOGFILE_PATH}" 2>&1; then
  cd walker
  log "Building walker..."
  (
    cargo build --release >>"${UTILS_LOGFILE_PATH}" 2>&1
  ) &
  show_progress "Building walker (this may take a while)..." $!
  cd ..
  rm -rf walker
else
  error "Failed to clone walker"
  exit 1
fi

# Install elephant
log "Installing elephant..."
(
  sudo paru -S --noconfirm elephant elephant-desktopapplications >>"${UTILS_LOGFILE_PATH}" 2>&1
) &
show_progress "Installing elephant..." $!

echo -e "\n[✅] Hyprland setup completed successfully!"
log "Hyprland setup completed successfully!"

