#!/usr/bin/env bash
set -euo pipefail

# Detect if the current directory is a bare repository or inside a worktree.
# Sets the following variables:
# - IS_BARE_REPO: true if the current directory is a bare repository.
# - IS_WORKTREE: true if the current directory is inside a worktree.
# - ROOT_DIR: the root directory of the bare repository.

function detect_environment() {
  local current_dir
  current_dir="$(pwd)"
  local root_dir=""
  local is_bare_repo=false
  local is_worktree=false

  # Check if current directory is a bare repository
  if [[ "$(git rev-parse --is-bare-repository 2>/dev/null)" == "true" ]]; then
    is_bare_repo=true
    root_dir="$(pwd)"
  else
    # Check if current directory is inside a worktree
    # In a worktree, .git is a file (not a directory) containing "gitdir: ..."
    while [[ "$current_dir" != "/" ]]; do
      if [[ -f "$current_dir/.git" ]]; then
        is_worktree=true
        root_dir="$(git -C "$current_dir" rev-parse --git-common-dir | xargs dirname)"
        break
      fi
      current_dir="$(dirname "$current_dir")"
    done
  fi

  # Export variables
  export IS_BARE_REPO="$is_bare_repo"
  export IS_WORKTREE="$is_worktree"
  export ROOT_DIR="$root_dir"
}

# Call the function to set variables
detect_environment
