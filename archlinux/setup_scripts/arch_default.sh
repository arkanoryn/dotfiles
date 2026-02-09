#!/usr/bin/env bash
set -euo pipefail

# Source the utilities
UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${UTILS_DIR}/utils.sh"

log "Starting Arch Linux default setup..."
echo "Starting Arch Linux default setup..."

# Update the machine with progress
log "Updating system..."
(
  sudo pacman -Syu --noconfirm >>"${UTILS_LOGFILE_PATH}" 2>&1
) &
show_progress "Updating system..." $!

# Basics installation
install_with_progress "Installing basics..." \
  sudo pacman -S --needed --noconfirm base-level fd fzf git less man-db ripgrep stow tree

# Install paru with progress
if [[ "$NON_INTERACTIVE" -eq 1 ]]; then
  log "Non-interactive mode: Auto-installing paru"
  (
    cd "${UTILS_TMP_PATH}" &&
      git clone https://aur.archlinux.org/paru.git >>"${UTILS_LOGFILE_PATH}" 2>&1 &&
      cd paru &&
      makepkg -si >>"${UTILS_LOGFILE_PATH}" 2>&1 &&
      cd .. &&
      rm -rf paru
  ) &
  show_progress "Installing paru..." $!
else
  read -p "Do you want to install paru (AUR helper)? " -n 1 -r
  echo # move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "Installing paru..."
    (
      cd "${UTILS_TMP_PATH}" &&
        git clone https://aur.archlinux.org/paru.git >>"${UTILS_LOGFILE_PATH}" 2>&1 &&
        cd paru &&
        makepkg -si >>"${UTILS_LOGFILE_PATH}" 2>&1 &&
        cd .. &&
        rm -rf paru
    ) &
    show_progress "Installing paru..." $!
  fi
fi

# Nvidia section
if [[ "$NON_INTERACTIVE" -eq 1 ]]; then
  log "Non-interactive mode: Skipping NVIDIA GPU detection"
else
  read -p "Do you run an nVidia GPU? " -n 1 -r
  echo # move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_with_progress "Installing NVIDIA drivers..." \
      paru -S --noconfirm --needed nvidia-dkms nvidia-utils nvidia-settings libva-nvidia-driver
    
    # Install additional NVIDIA packages
    ask_and_install "Do you want to install NVIDIA CUDA?" \
      paru -S --noconfirm --needed cuda
  fi
fi

# GUI packages - enhanced with more essential packages
install_with_progress "Installing GUI packages..." \
  sudo pacman -S --needed --noconfirm \
  kvantum \
  nwg-look \
  qt5ct \
  qt5-wayland \
  qt6-wayland \
  wl-clipboard \
  xdg-desktop-portal-hyprland \
  xdg-utils

# Additional packages from installed_packages.list
install_with_progress "Installing additional system packages..." \
  sudo pacman -S --needed --noconfirm \
  openssh \
  openssl-1.1 \
  sddm \
  wget \
  less \
  unrar \
  unzip \
  zip \
  cliphist \
  efibootmgr \
  smartmontools \
  usbutils \
  dunst \
  notify-send.sh



# Fonts - added FiraCode as requested
install_with_progress "Installing fonts..." \
  paru -S --noconfirm --needed ttf-symbola ttf-twemoji ttf-firacode-nerd &&
  sudo pacman -S --noconfirm --needed noto-fonts-cjk noto-fonts-emoji woff2-font-awesome

echo -e "\n[✅] Arch Linux default setup completed successfully!"
log "Arch Linux default setup completed successfully"

