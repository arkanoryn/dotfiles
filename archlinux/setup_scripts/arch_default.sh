#!/usr/bin/env bash
set -euo pipefail

tmp_path="${HOME}/.tmp"
logfile_path="${tmp_path}/log.txt"

# First, update the machine
sudo pacman -Syu >>"${logfile_path}"

# Basics
echo "Installing my basics..."
sudo pacman -S --needed --noconfirm base-level \
  fd \
  fzf \
  git \
  less \
  man-db \
  ripgrep \
  stow \
  tree >>"${logfile_path}"

# Install paru
echo "Installing paru..."
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cd "${tmp_path}"
  git clone https://aur.archlinux.org/paru.git >>"${logfile_path}"
  cd paru
  makepkg -si >>"${logfile_path}"
  cd ..
  rm -rf paru
fi

# Nvidia
read -p "Do you run an nVidia GPU? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  paru -S --noconfirm --needed llibva-nvidia-driver nvidia-settingsibva-nvidia-driver nvidia-settings >>"${logfile_path}"
  k
fi

# Install Graphical interfaces packages
echo "Installing GUI packages..."
sudo pacman -S kvantum \
  nwg-look \
  qt5ct \
  qt5-wayland \
  qt6-wayland >>"${logfile_path}"

# Install fonts
echo "Installing the font packages..."
paru -S --noconfirm --needed ttf-symbola \
  ttf-twemoji >>"${logfile_path}"
sudo pacman -S --noconfirm --needed noto-fonts-cjk \
  noto-fonts-emoji \
  woff2-font-awesome >>"${logfile_path}"
