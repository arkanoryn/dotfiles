#!/usr/bin/env bash
set -euo pipefail

# Source detection logic
source "$(dirname "$0")/detection.sh"

# List all active worktrees
# Usage: list_worktrees
function list_worktrees() {
  if [[ -z "$ROOT_DIR" ]]; then
    echo "Error: Not in a bare repository or worktree context." >&2
    return 1
  fi

  echo "Active worktrees:"
  git -C "$ROOT_DIR" worktree list
}

# Create a new worktree for a branch
# Usage: create_worktree <branch_name> [starting_commit]
function create_worktree() {
  local branch_name="$1"
  local starting_commit="${2:-}"
  local worktree_path="$ROOT_DIR/worktree/$branch_name"

  if [[ -z "$ROOT_DIR" ]]; then
    echo "Error: Not in a bare repository or worktree context." >&2
    return 1
  fi

  # Check if worktree already exists
  if [[ -d "$worktree_path" ]]; then
    echo "Worktree '$branch_name' already exists. Switching to it."
    switch_worktree "$branch_name"
    return
  fi

  # Check if branch exists on remote and track it, otherwise create new
  if git -C "$ROOT_DIR" show-ref --verify --quiet "refs/remotes/origin/$branch_name" 2>/dev/null; then
    git -C "$ROOT_DIR" worktree add "$worktree_path" --track -b "$branch_name" "origin/$branch_name"
  elif [[ -n "$starting_commit" ]]; then
    git -C "$ROOT_DIR" worktree add "$worktree_path" -b "$branch_name" "$starting_commit"
  else
    git -C "$ROOT_DIR" worktree add "$worktree_path" -b "$branch_name"
  fi

  # Initialize branch documentation
  local doc_path="$ROOT_DIR/.agents/worktree/$branch_name.md"
  mkdir -p "$(dirname "$doc_path")"

  local template_path
  template_path="$(dirname "$0")/../templates/worktree-log.md"
  local date
  date="$(date '+%Y-%m-%d %H:%M:%S')"
  local sha
  sha="$(git -C "$worktree_path" rev-parse HEAD)"
  local short_message
  short_message="$(git -C "$worktree_path" log -1 --pretty=%s)"
  local target_branch
  target_branch="$(get_target_branch "$branch_name" "$worktree_path")"

  # Use envsubst for safe template rendering
  export name="$branch_name"
  export date="$date"
  export sha="$sha"
  export short_message="$short_message"
  export target="$target_branch"
  export objective=""
  export review_notes=""
  export todos=""

  envsubst < "$template_path" > "$doc_path"

  unset name date sha short_message target objective review_notes todos

  echo "Created worktree at $worktree_path"
  echo "Initialized documentation at $doc_path"
}

# Switch to an existing worktree
# Usage: switch_worktree <branch_name>
function switch_worktree() {
  local branch_name="$1"
  local worktree_path="$ROOT_DIR/worktree/$branch_name"

  if [[ ! -d "$worktree_path" ]]; then
    echo "Error: Worktree for branch '$branch_name' does not exist." >&2
    return 1
  fi

  cd "$worktree_path" || return 1
  echo "Switched to worktree: $worktree_path"
}

# Close a worktree and merge changes
# Usage: close_worktree <branch_name>
function close_worktree() {
  local branch_name="$1"
  local worktree_path="$ROOT_DIR/worktree/$branch_name"
  local doc_path="$ROOT_DIR/.agents/worktree/$branch_name.md"

  if [[ ! -d "$worktree_path" ]]; then
    echo "Error: Worktree for branch '$branch_name' does not exist." >&2
    return 1
  fi

  # Change to worktree directory
  cd "$worktree_path" || return 1

  # Check for uncommitted changes (both staged and unstaged)
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Uncommitted changes detected. Please commit or stash them before closing." >&2
    return 1
  fi

  # Get target branch from config
  local target_branch
  target_branch="$(get_target_branch "$branch_name" "$worktree_path")"

  # Push branch to remote
  git push origin "$branch_name"

  # Present merge options
  echo ""
  echo "Merge options for '$branch_name' into '$target_branch':"
  echo "  1) Merge locally via worktree + push"
  echo "  2) Create a PR (requires gh CLI)"
  echo "  3) Keep branch pushed, skip merge"
  echo ""
  echo "Choose option (1/2/3):"
  read -r answer

  case "$answer" in
    1)
      # Create a temporary worktree for the target branch to perform merge
      local target_worktree="$ROOT_DIR/worktree/$target_branch"
      local target_created=false

      if [[ ! -d "$target_worktree" ]]; then
        git -C "$ROOT_DIR" worktree add "$target_worktree" "$target_branch"
        target_created=true
      fi

      cd "$target_worktree" || return 1
      git pull origin "$target_branch" 2>/dev/null || true

      if ! git merge "$branch_name"; then
        echo "Error: Merge conflicts detected. Resolve manually in $target_worktree" >&2
        echo "After resolving: git commit, then re-run /branch close $branch_name" >&2
        return 1
      fi

      git push origin "$target_branch"

      # Clean up temporary target worktree if we created it
      if [[ "$target_created" == "true" ]]; then
        cd "$ROOT_DIR" || return 1
        git worktree remove "$target_worktree"
      fi
      ;;
    2)
      if command -v gh >/dev/null 2>&1; then
        gh pr create --base "$target_branch" --head "$branch_name" --fill
        echo "PR created. Skipping local cleanup until PR is merged."
        return 0
      else
        echo "Error: gh CLI not found. Install it or choose another option." >&2
        return 1
      fi
      ;;
    3)
      echo "Branch pushed. No merge performed."
      ;;
    *)
      echo "Invalid option. Aborting." >&2
      return 1
      ;;
  esac

  # Cleanup
  cd "$ROOT_DIR" || return 1
  git worktree remove "$worktree_path"
  git branch -d "$branch_name"

  # Archive documentation
  local archive_dir="$ROOT_DIR/.agents/worktree/archive"
  mkdir -p "$archive_dir"
  if [[ -f "$doc_path" ]]; then
    mv "$doc_path" "$archive_dir/$branch_name.md"
  fi

  echo "Closed worktree '$branch_name'."
}

# Get the target branch for a given branch name
# Reads from {worktree}/.agents/config.md
# Usage: get_target_branch <branch_name> <worktree_path>
function get_target_branch() {
  local branch_name="$1"
  local worktree_path="${2:-$ROOT_DIR/worktree/$branch_name}"
  local config_path="$worktree_path/.agents/config.md"
  local default_target="dev"

  # If config exists, parse target branches section
  if [[ -f "$config_path" ]]; then
    local in_target_section=false
    while IFS= read -r line; do
      if [[ "$line" == "## Target Branches" ]]; then
        in_target_section=true
        continue
      fi
      if [[ "$in_target_section" == true && "$line" =~ ^## ]]; then
        break
      fi
      if [[ "$in_target_section" == true && "$line" =~ ^-[[:space:]]+([^:]+):[[:space:]]+(.+)$ ]]; then
        local pattern="${BASH_REMATCH[1]}"
        local target="${BASH_REMATCH[2]}"

        # Use glob-style matching with case statement
        if [[ "$pattern" == "default" ]]; then
          default_target="$target"
        elif [[ "$branch_name" == $pattern ]]; then
          echo "$target"
          return
        fi
      fi
    done < "$config_path"
  fi

  # Fallback to default
  echo "$default_target"
}
