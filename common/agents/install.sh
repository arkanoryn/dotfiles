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

log_warn() { printf 'warn: %s\n' "$*" >&2; }

require_stow() {
  if ! command -v stow >/dev/null 2>&1; then
    printf 'Error: stow is required but was not found in PATH.\n' >&2
    exit 1
  fi
}

# Drop skill symlinks whose source no longer exists (stow can't sweep these on
# its own once the source dir is gone), then vacuum empty parent dirs.
prune_orphan_skill_links() {
  [[ -d "$agents_home/skills" ]] || return 0
  local removed=0 link
  while IFS= read -r -d '' link; do
    [[ -e "$link" ]] || { rm -f "$link"; removed=$((removed+1)); }
  done < <(find "$agents_home/skills" -type l -print0)
  find "$agents_home/skills" -depth -type d -empty -delete 2>/dev/null || true
  (( removed > 0 )) && log_warn "pruned $removed orphan skill link(s) from $agents_home/skills" || true
}

# Stow refuses to clobber real files. For the pi step the only subdirs source
# ships are extensions/ and prompts/, so any top-level regular file there is
# either a stale copy or a hand-placed override. Move it aside so stow can
# link through, leaving the user a backup to diff/restore from.
backup_pi_subdir_conflicts() {
  local ts backup_dir sub moved=0 f dest
  ts=$(date +%Y%m%dT%H%M%S)
  backup_dir="$pi_agent_dir/.stow-backup/$ts"
  for sub in extensions prompts; do
    [[ -d "$pi_agent_dir/$sub" ]] || continue
    while IFS= read -r -d '' f; do
      dest="$backup_dir/$sub/$(basename "$f")"
      mkdir -p "$(dirname "$dest")"
      mv "$f" "$dest"
      moved=$((moved+1))
    done < <(find "$pi_agent_dir/$sub" -mindepth 1 -maxdepth 1 -type f -print0)
  done
  (( moved > 0 )) && log_warn "moved $moved conflicting pi file(s) aside to $backup_dir" || true
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
  "${stow_delete_cmd[@]}" -d "$script_dir" -t "$agents_home" shared \
    || log_warn "stow --delete shared -> $agents_home failed (continuing)"

  # Stow can't sweep links to source dirs that no longer exist — do it ourselves
  # so the next restow lands on a clean slate.
  prune_orphan_skill_links

  # Keep generated harness state in the harness home by stowing individual files,
  # never whole directories that tools may later write into.
  "${stow_cmd[@]}" -d "$script_dir/shared" -t "$pi_agent_dir/agents" prompts \
    || log_warn "stow prompts -> $pi_agent_dir/agents failed (continuing)"
  "${stow_cmd[@]}" -d "$script_dir/shared" -t "$vibe_home/prompts" prompts \
    || log_warn "stow prompts -> $vibe_home/prompts failed (continuing)"
  "${stow_cmd[@]}" --ignore='^prompts($|/)' -d "$script_dir" -t "$agents_home" shared \
    || log_warn "stow shared -> $agents_home failed (continuing)"
  "${stow_cmd[@]}" -d "$script_dir" -t "$vibe_home" vibe \
    || log_warn "stow vibe -> $vibe_home failed (continuing)"

  # pi target dir has runtime state mixed with our stowed files; move any
  # conflicting real files aside first so stow can link through.
  backup_pi_subdir_conflicts
  "${stow_cmd[@]}" -d "$script_dir" -t "$pi_agent_dir" pi \
    || log_warn "stow pi -> $pi_agent_dir failed (continuing)"

  # Also mirror skills into Claude Code's own skills directory.
  "${stow_cmd[@]}" -d "$script_dir/shared" -t "$claude_skills_dir" skills \
    || log_warn "stow skills -> $claude_skills_dir failed (continuing)"
}

do_remove() {
  "${stow_delete_cmd[@]}" -d "$script_dir/shared" -t "$pi_agent_dir/agents" prompts \
    || log_warn "stow --delete prompts -> $pi_agent_dir/agents failed (continuing)"
  "${stow_delete_cmd[@]}" -d "$script_dir/shared" -t "$vibe_home/prompts" prompts \
    || log_warn "stow --delete prompts -> $vibe_home/prompts failed (continuing)"
  "${stow_delete_cmd[@]}" --ignore='^prompts($|/)' -d "$script_dir" -t "$agents_home" shared \
    || log_warn "stow --delete shared -> $agents_home failed (continuing)"
  "${stow_delete_cmd[@]}" -d "$script_dir" -t "$vibe_home" vibe \
    || log_warn "stow --delete vibe -> $vibe_home failed (continuing)"
  "${stow_delete_cmd[@]}" -d "$script_dir" -t "$pi_agent_dir" pi \
    || log_warn "stow --delete pi -> $pi_agent_dir failed (continuing)"
  "${stow_delete_cmd[@]}" -d "$script_dir/shared" -t "$claude_skills_dir" skills \
    || log_warn "stow --delete skills -> $claude_skills_dir failed (continuing)"

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
