#!/usr/bin/env bash
# Custom installer for the common/agents component.
#
# Can't be wholesale-stowed: prompts must land in each harness's own
# directory (not AGENTS_HOME), and generated harness state must never be
# clobbered by stowing a whole directory it writes into. Invoked by
# install.sh's component_install/component_remove as:
#   install.sh install
#   install.sh remove
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

agents_home=${AGENTS_HOME:-"$HOME/.agents"}
vibe_home=${VIBE_HOME:-"$HOME/.vibe"}
pi_agent_dir=${PI_CODING_AGENT_DIR:-"$HOME/.pi/agent"}
claude_skills_dir=${CLAUDE_SKILLS_DIR:-"$HOME/.claude/skills"}

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
    "$pi_agent_dir/agents" \
    "$claude_skills_dir"
}

do_install() {
  # Remove links created by the previous whole-shared stow, so prompts no longer
  # linger in AGENTS_HOME after moving to the harness-specific homes.
  "${stow_delete_cmd[@]}" -d "$script_dir" -t "$agents_home" shared

  # Keep generated harness state in the harness home by stowing individual files,
  # never whole directories that tools may later write into.
  "${stow_cmd[@]}" -d "$script_dir/shared" -t "$pi_agent_dir/agents" prompts
  "${stow_cmd[@]}" -d "$script_dir/shared" -t "$vibe_home/prompts" prompts
  "${stow_cmd[@]}" --ignore='^prompts($|/)' -d "$script_dir" -t "$agents_home" shared
  "${stow_cmd[@]}" -d "$script_dir" -t "$vibe_home" vibe
  "${stow_cmd[@]}" -d "$script_dir" -t "$pi_agent_dir" pi

  # Also mirror skills into Claude Code's own skills directory.
  "${stow_cmd[@]}" -d "$script_dir/shared" -t "$claude_skills_dir" skills
}

do_remove() {
  "${stow_delete_cmd[@]}" -d "$script_dir/shared" -t "$pi_agent_dir/agents" prompts
  "${stow_delete_cmd[@]}" -d "$script_dir/shared" -t "$vibe_home/prompts" prompts
  "${stow_delete_cmd[@]}" --ignore='^prompts($|/)' -d "$script_dir" -t "$agents_home" shared
  "${stow_delete_cmd[@]}" -d "$script_dir" -t "$vibe_home" vibe
  "${stow_delete_cmd[@]}" -d "$script_dir" -t "$pi_agent_dir" pi
  "${stow_delete_cmd[@]}" -d "$script_dir/shared" -t "$claude_skills_dir" skills

  find "$agents_home" "$vibe_home" "$pi_agent_dir" "$claude_skills_dir" -depth -type d -empty -delete 2>/dev/null || true
}

main() {
  require_stow
  case "${1:-install}" in
    install)
      ensure_dirs
      do_install
      ;;
    remove)
      do_remove
      ;;
    *)
      printf 'Usage: %s {install|remove}\n' "$0" >&2
      exit 1
      ;;
  esac
}

main "$@"
