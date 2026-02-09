#!/usr/bin/env bash
set -euo pipefail

# Source the utilities
UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${UTILS_DIR}/utils.sh"

log "Starting application setup..."
echo "Starting application setup..."

# App launcher selection
install_app_launcher

# Terminal selection
install_terminal

# Shell selection
install_shell

# Shell tools selection
install_shell_tools

# Browser selection
install_browser

# File explorer selection
install_file_explorer

# Yazi file manager (keep as yes/no since it's a specific tool)
ask_and_install "Do you want to install yazi (terminal file manager)?" \
  sudo pacman -S --noconfirm --needed yazi 7zip fd ffmpeg fzf imagemagick jq poppler ripgrep zoxide

# Coding environment
read -p "Do you want to install coding environment? (neovim, cargo, elixir, QMK) " -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_with_progress "Installing Neovim" sudo pacman -S neovim --needed --noconfirm
  install_with_progress "Installing Cargo (Rust)" sudo pacman -S cargo --needed --noconfirm
  install_with_progress "Installing Elixir" sudo pacman -S elixir --needed --noconfirm

  # QMK
  read -p "Do you want to install QMK? " -n 1 -r
  echo # move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_with_progress "Installing QMK dependencies" \
      sudo pacman --needed --noconfirm -S git python-pip libffi qmk &&
      mkdir -p "${HOME}/Code/qmk" &&
      qmk setup -H "${HOME}/Code/qmk/qmk_firmware"
  fi
fi

# LazyVim dependencies
ask_and_install "Do you want to install LazyVim dependencies? (node, npm, linters)" \
  sudo pacman -S nodejs npm --needed --noconfirm &&
  npm install -g markdownlint-cli

# Additional applications
ask_and_install "Do you want to install Discord?" \
  sudo pacman -S discord --noconfirm --needed

echo -e "\n[✅] Application setup completed!"
log "Application setup completed"

# Function to install terminal emulator
install_terminal() {
  local choices=("Wezterm" "Ghostty" "Both" "None")
  ask_multiple_choice "Which terminal emulator do you want to install?" "${choices[@]}"
  local choice=$?

  case $choice in
  1) install_with_progress "Installing Wezterm" paru -S wezterm --noconfirm --needed ;;
  2) install_with_progress "Installing Ghostty" paru -S ghostty-git --noconfirm --needed ;;
  3)
    install_with_progress "Installing Wezterm" paru -S wezterm --noconfirm --needed
    install_with_progress "Installing Ghostty" paru -S ghostty-git --noconfirm --needed
    ;;
  4) log "Skipped terminal installation" ;;
  esac
}

# Function to install shell
install_shell() {
  local choices=("Fish" "Bash" "Zsh" "None")
  ask_multiple_choice "Which shell do you want to install?" "${choices[@]}"
  local choice=$?

  case $choice in
  1) install_with_progress "Installing Fish shell" sudo pacman -S fish --noconfirm --needed ;;
  2) log "Bash is already installed (default shell)" ;;
  3) install_with_progress "Installing Zsh" sudo pacman -S zsh --noconfirm --needed ;;
  4) log "Skipped shell installation" ;;
  esac
}

# Function to install shell tools
install_shell_tools() {
  local choices=("Starship" "Zoxide" "Bat" "Eza" "All" "None")
  ask_multiple_choice "Which shell tools do you want to install?" "${choices[@]}"
  local choice=$?

  case $choice in
  1) install_with_progress "Installing Starship" paru -S starship --noconfirm --needed ;;
  2) install_with_progress "Installing Zoxide" sudo pacman -S zoxide --noconfirm --needed ;;
  3) install_with_progress "Installing Bat" sudo pacman -S bat --noconfirm --needed ;;
  4) install_with_progress "Installing Eza" paru -S eza --noconfirm --needed ;;
  5)
    install_with_progress "Installing Starship" paru -S starship --noconfirm --needed
    install_with_progress "Installing Zoxide" sudo pacman -S zoxide --noconfirm --needed
    install_with_progress "Installing Bat" sudo pacman -S bat --noconfirm --needed
    install_with_progress "Installing Eza" paru -S eza --noconfirm --needed
    ;;
  6) log "Skipped shell tools installation" ;;
  esac
}

# Function to install app launcher
install_app_launcher() {
  local choices=("Walker" "Wofi" "All" "None")
  ask_multiple_choice "Which app launcher do you want to install?" "${choices[@]}"
  local choice=$?

  case $choice in
  1) install_with_progress "Installing Walker" sudo pacman -S walker --noconfirm --needed ;;
  2) install_with_progress "Installing Wofi" sudo pacman -S wofi --noconfirm --needed ;;
  3)
    install_with_progress "Installing Walker" sudo pacman -S walker --noconfirm --needed
    install_with_progress "Installing Wofi" sudo pacman -S wofi --noconfirm --needed
    ;;
  4) log "Skipped app launcher installation" ;;
  esac
}

# Function to install file explorer
install_file_explorer() {
  local choices=("Dolphin" "Yazi" "All" "None")
  ask_multiple_choice "Which file explorer do you want to install?" "${choices[@]}"
  local choice=$?

  case $choice in
  1) install_with_progress "Installing Dolphin" sudo pacman -S dolphin --noconfirm --needed ;;
  2) install_with_progress "Installing Yazi" sudo pacman -S yazi --noconfirm --needed ;;
  3)
    install_with_progress "Installing Dolphin" sudo pacman -S dolphin --noconfirm --needed
    install_with_progress "Installing Yazi" sudo pacman -S yazi --noconfirm --needed
    ;;
  4) log "Skipped file explorer installation" ;;
  esac
}

# Function to install browser
install_browser() {
  local choices=("Firefox" "Brave" "Zen" "All" "None")
  ask_multiple_choice "Which browser do you want to install?" "${choices[@]}"
  local choice=$?

  case $choice in
  1) install_with_progress "Installing Firefox" sudo pacman -S firefox --noconfirm --needed ;;
  2) install_with_progress "Installing Brave" paru -Sy brave-bin --noconfirm --needed ;;
  3) install_with_progress "Installing Zen Browser" paru -S zen-browser-bin --noconfirm --needed ;;
  4)
    install_with_progress "Installing Firefox" sudo pacman -S firefox --noconfirm --needed
    install_with_progress "Installing Brave" paru -Sy brave-bin --noconfirm --needed
    install_with_progress "Installing Zen Browser" paru -S zen-browser-bin --noconfirm --needed
    ;;
  5) log "Skipped browser installation" ;;
  esac
}

