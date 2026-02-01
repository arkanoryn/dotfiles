#!/usr/bin/env bash
set -euo pipefail

tmp_path="${HOME}/.tmp"
logfile_path="${tmp_path}/log.txt"

echo "Installing the packages to enhance hyprland..."
sudo pacman -S --noconfirm --needed libnotify \
  pamixer \
  pavucontrol \
  sddm-theme-sugar-candy \
  swaync \
  quickshell \
  waybar >>"${logfile_path}"

echo "Installing walker and elephant for application launch..."
cd "${tmp_path}"
git clone https://github.com/abenz1267/walker.git
cd walker
cargo build --release
cd ..
rm -rf walker
sudo paru -S elephant elephant-desktopapplications
