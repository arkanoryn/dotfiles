#!/usr/bin/env bash
set -euo pipefail

# Source the utilities
UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${UTILS_DIR}/utils.sh"

log "Starting network setup..."
echo "Starting network setup..."

# Network tools
install_with_progress "Installing network tools..." \
  sudo pacman -S --needed --noconfirm \
  iwd \
  iftop \
  nethogs \
  wireless_tools \
  wpa_supplicant \
  networkmanager

# VPN client
ask_and_install "Do you want to install Proton VPN GTK client?" \
  paru -S --noconfirm --needed proton-vpn-gtk-app

echo -e "\n[✅] Network setup completed!"
log "Network setup completed successfully"