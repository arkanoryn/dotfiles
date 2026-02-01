#!/usr/bin/env bash
set -euo pipefail

tmp_path="${HOME}/.tmp"
logfile_path="${tmp_path}/log.txt"

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

read -p "Do you want to install coding environment? (neovim, cargo, elixir, QMK)" -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo pacman -S neovim --needed --noconfirm >>"${logfile_path}"
  sudo pacman -S cargo --needed --noconfirm >>"${logfile_path}"
  sudo pacman -S elixir --needed --noconfirm >>"${logfile_path}"

  # QMK
  read -p "Do you want to install QMK? " -n 1 -r
  echo # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo pacman --needed --noconfirm -S git python-pip libffi qmk >>"${logfile_path}"
    mkdir -p "${qmk_path}"
    qmk setup -H ~/Code/qmk/qmk_firmware >>"${logfile_path}"
  fi

fi

# Install LazyVim dependencies
read -p "Do you want to install LazyVim dependencies? (node, npm, linters)" -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Install Node.js and npm
  sudo pacman -S nodejs npm --needed --noconfirm >>"${logfile_path}"

  # Install global npm packages for LazyVim linting/formatting
  npm install -g markdownlint-cli >>"${logfile_path}"
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
  sudo paru -Sy brave-bin --noconfirm --needed >>"${logfile_path}"
fi

read -p "Do you want to install OpenCode? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo paru -Sy opencode-bin --noconfirm --needed >>"${logfile_path}"
fi

read -p "Do you want to install MistralVibe 2.0? " -n 1 -r
echo # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo pacman -Sy python python-pip --noconfirm --needed >>"${logfile_path}"
  pip install uv
  uv tool install mistral-vibe >>"${logfile_path}"
fi
