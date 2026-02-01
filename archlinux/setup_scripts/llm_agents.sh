#!/usr/bin/env bash
set -euo pipefail

# Colors for seduction
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
DOTFILES_ROOT="$HOME/.dotfiles"
VIBE_TARGET="$HOME/.vibe"
OPENCODE_TARGET="$HOME/.opencode"

# Function to backup existing configs
backup_config() {
  local source="$1"
  local name="$2"
  local saves_dir="$HOME/.agents.saves"
  local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
  local backup="$saves_dir/${name}.${timestamp}.save"

  # Create saves directory if it doesn't exist
  mkdir -p "$saves_dir"

  if [[ -e "$source" ]]; then
    echo -e "${YELLOW}Backing up existing $name config to $backup...${NC}"
    cp -r "$source" "$backup"
    echo -e "${GREEN}Backup complete: $backup${NC}"
  else
    echo -e "${GREEN}No existing $name config found. Skipping backup.${NC}"
  fi
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to setup Vibe
setup_vibe() {
  echo -e "${GREEN}Setting up Mistral Vibe...${NC}"

  # Backup
  backup_config "$VIBE_TARGET" "Vibe"

  # Stow shared resources
  echo -e "${YELLOW}Stowing shared resources for Vibe...${NC}"
  stow -t "$VIBE_TARGET" -d "$DOTFILES_ROOT/common/agents" "shared"

  # Stow Vibe-specific configs
  echo -e "${YELLOW}Stowing Vibe-specific configs...${NC}"
  stow -t "$VIBE_TARGET" -d "$DOTFILES_ROOT/common/agents" "vibe"

  echo -e "${GREEN}Vibe setup complete!${NC}"
}

# Function to setup OpenCode
setup_opencode() {
  echo -e "${GREEN}Setting up OpenCode...${NC}"

  # Backup
  backup_config "$OPENCODE_TARGET" "OpenCode"

  # Stow shared resources
  echo -e "${YELLOW}Stowing shared resources for OpenCode...${NC}"
  stow -t "$OPENCODE_TARGET" -d "$DOTFILES_ROOT/common/agents" "shared"

  # Stow OpenCode-specific configs
  echo -e "${YELLOW}Stowing OpenCode-specific configs...${NC}"
  stow -t "$OPENCODE_TARGET" -d "$DOTFILES_ROOT/common/agents" "opencode"

  echo -e "${GREEN}OpenCode setup complete!${NC}"
}

# Main script
echo -e "${GREEN}Starting agent setup...${NC}"

# Check if stow is installed
if ! command_exists stow; then
  echo -e "${RED}Error: 'stow' is not installed. Please install it first.${NC}"
  exit 1
fi

# Check for Vibe
if [[ -d "$HOME/.vibe" ]] || command_exists vibe; then
  echo -e "${YELLOW}Mistral Vibe detected. Setting up...${NC}"
  setup_vibe
else
  echo -e "${YELLOW}Mistral Vibe not found. Skipping Vibe setup.${NC}"
fi

# Check for OpenCode
# if [[ -d "$HOME/.opencode" ]] || command_exists opencode; then
#   echo -e "${YELLOW}OpenCode detected. Setting up...${NC}"
#   setup_opencode
# else
#   echo -e "${YELLOW}OpenCode not found. Skipping OpenCode setup.${NC}"
# fi

echo -e "${GREEN}Agent setup complete! Enjoy your new powers.${NC}"
