#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
dotfiles_dir=$(cd -- "$script_dir/.." && pwd)

agents_home=${AGENTS_HOME:-"$HOME/.agents"}
vibe_home=${VIBE_HOME:-"$HOME/.vibe"}
pi_agent_dir=${PI_CODING_AGENT_DIR:-"$HOME/.pi/agent"}

stow_cmd=(stow --restow --no-folding)
stow_delete_cmd=(stow --delete)

require_stow() {
  if ! command -v stow >/dev/null 2>&1; then
    printf 'Error: stow is required but was not found in PATH.\n' >&2
    exit 1
  fi
}

ensure_dirs() {
  mkdir -p \
    "$agents_home/skills" \
    "$vibe_home/agents" \
    "$vibe_home/prompts" \
    "$pi_agent_dir/agents"
}

stow_agents() {
  # Remove links created by the previous whole-shared stow, so prompts no longer
  # linger in AGENTS_HOME after moving to the harness-specific homes.
  "${stow_delete_cmd[@]}" -d "$dotfiles_dir/common/agents" -t "$agents_home" shared

  # Keep generated harness state in the harness home by stowing individual files,
  # never whole directories that tools may later write into.
  "${stow_cmd[@]}" -d "$dotfiles_dir/common/agents/shared" -t "$pi_agent_dir/agents" prompts
  "${stow_cmd[@]}" -d "$dotfiles_dir/common/agents/shared" -t "$vibe_home/prompts" prompts
  "${stow_cmd[@]}" --ignore='^prompts($|/)' -d "$dotfiles_dir/common/agents" -t "$agents_home" shared
  "${stow_cmd[@]}" -d "$dotfiles_dir/common/agents" -t "$vibe_home" vibe
  "${stow_cmd[@]}" -d "$dotfiles_dir/common/agents" -t "$pi_agent_dir" pi
}

main() {
  require_stow
  ensure_dirs
  stow_agents
}

main "$@"
