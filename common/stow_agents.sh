#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
AGENTS_DIR="$HOME/.agents"

stow -t "$AGENTS_DIR" -d "$DOTFILES/common/agents" shared
