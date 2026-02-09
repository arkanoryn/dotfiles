#!/usr/bin/env bash
set -euo pipefail

# Source the utilities
UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${UTILS_DIR}/utils.sh"

log "Starting development environment setup..."
echo "Starting development environment setup..."

# Development tools
install_with_progress "Installing development tools..." \
  sudo pacman -S --needed --noconfirm \
  jq \
  npm \
  htop \
  lazygit \
  python-pip \
  python310 \
  tmux \
  yarn

# Docker
ask_and_install "Do you want to install Docker and Docker Compose?" \
  sudo pacman -S --needed --noconfirm docker docker-compose

# Miniconda
ask_and_install "Do you want to install Miniconda3?" \
  paru -S --noconfirm --needed miniconda3

# Rust
ask_and_install "Do you want to install Rust programming language?" \
  sudo pacman -S --needed --noconfirm rust

# OpenCode (if available)
ask_and_install "Do you want to install OpenCode?" \
  paru -S --noconfirm --needed opencode

echo -e "\n[✅] Development environment setup completed!"
log "Development environment setup completed successfully"