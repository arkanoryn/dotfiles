#!/usr/bin/env bash

tmp_path="${HOME}/.tmp"
logfile_path="${tmp_path}/log.txt"
<<<<<<< HEAD
qmk_path="${HOME}/code/qmk"
=======
qmk_path="${HOME}/Code/qmk"
>>>>>>> master

echo "Creating a log file in #{logfile_path}..."
mkdir "${tmp_path}"
touch "${logfile_path}"
echo "$(date +"%Y-%m-%d %H:%M:%S")" >"${logfile_path}"

<<<<<<< HEAD
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

echo "Installing the packages to enable my personal look..."
sudo pacman -S --noconfirm --needed libnotify \
  pamixer \
  pavucontrol \
  sddm-theme-sugar-candy \
  swaync \
  waybar >>"${logfile_path}"

read -p "Do you want to install yazi (terminal file manager)? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "[WARNING] Read the log file and the git repository for further instructions."
  sudo pacman -S --noconfirm --needed yazi \
    7zip \
    fd \
    ffmpeg \
    fzf \
    imagemagick \
    jq \
    poppler \
    ripgrep \
    zoxide >>"${logfile_path}"
fi

# Install Ghostty and requirements
read -p "Do you want to install Ghostty? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  paru -S ghostty-git --noconfirm --needed >>"${logfile_path}"
fi

# Install Wezterm and requirements

# Install fish, starship, eza, fzf, zoxide, bat
read -p "Do you want to install fish, starship, and other terminal tools? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  paru -S --noconfirm --needed bat \
    eza \
    fish \
    starship \
    zoxide \
    >>"${logfile_path}"
fi

# Install nvim and requirements from LazyVim

read -p "Do you want to install coding environment? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo pacman -S cargo --needed --noconfirm >>"${logfile_path}"
  sudo pacman -S elixir --needed --noconfirm >>"${logfile_path}"
  sudo pacman -S neovim --needed --noconfirm >>"${logfile_path}"
fi

# QMK
read -p "Do you want to install QMK? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo pacman --needed --noconfirm -S git python-pip libffi qmk >>"${logfile_path}"
  mkdir -p "${qmk_path}"
  qmk setup -H ~/code/qmk/qmk_firmware >>"${logfile_path}"
fi

# Different app
read -p "Do you want to install Discord? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo pacman -S discord --noconfirm --needed >>"${logfile_path}"
fi

read -p "Do you want to install Brave? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  paru -Sy brave-bin --noconfirm --needed >>"${logfile_path}"
fi

read -p "Do you want to install Zen? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  paru -Sy zen-browser-bin --noconfirm --needed >>"${logfile_path}"
fi
=======
. ./setup_scripts/arch_default.sh

. ./setup_scripts/hyprland.sh

. ./setup_scripts/apps.sh
>>>>>>> master
