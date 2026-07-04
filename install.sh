#!/usr/bin/env bash
# Dotfiles installer wizard.
#
# First run: pick which dotfile components and packages to install, then
# save the selection + a content hash of each component to state.
#
# Subsequent runs: re-check only what was previously selected. Components
# whose files changed since last run get re-stowed; packages that vanished
# get reinstalled. Newly-added components you haven't decided on yet are
# asked about individually.
#
# --force: discard saved state and run the full wizard again.
set -euo pipefail

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

source "$DOTFILES_DIR/scripts/installer/lib.sh"
source "$DOTFILES_DIR/scripts/installer/components.sh"
source "$DOTFILES_DIR/scripts/installer/packages.sh"

PLATFORM=$(detect_platform)

case "$PLATFORM" in
  macOS) source "$DOTFILES_DIR/scripts/installer/packages/macos.sh" ;;
  archlinux) source "$DOTFILES_DIR/scripts/installer/packages/archlinux.sh" ;;
esac

require_cmd gum "macOS: brew install gum   |   Arch: paru -S gum"
require_cmd stow "macOS: brew install stow   |   Arch: sudo pacman -S stow"

FORCE=0
[[ "${1:-}" == "--force" ]] && FORCE=1

if [[ $FORCE -eq 1 ]]; then
  log_warn "Forcing full reselect — discarding saved installer state."
  state_clear
fi

state_load
STATE_PLATFORM="$PLATFORM"

# Always persist whatever progress was made, even if a later component fails
# and set -e tears the script down early — otherwise a single bad component
# would silently discard every confirmation from this run.
trap 'state_save' EXIT

# Menu label -> "component:<id>" or "package:<id>"
declare -A LABEL_TO_ENTRY=()

# sorted_labels <label...> -> prints labels sorted, one per line.
sorted_labels() {
  [[ $# -eq 0 ]] && return
  printf '%s\n' "$@" | sort
}

build_component_labels() {
  LABEL_TO_ENTRY=()
  local id label labels=()
  while IFS= read -r id; do
    label="$(component_label "$id")"
    LABEL_TO_ENTRY["$label"]="component:$id"
    labels+=("$label")
  done < <(discover_components)
  sorted_labels "${labels[@]}"
}

build_package_labels() {
  local id label labels=()
  for id in "${PKG_ORDER[@]}"; do
    label="$(pkg_label "$id")"
    LABEL_TO_ENTRY["$label"]="package:$id"
    labels+=("$label")
  done
  sorted_labels "${labels[@]}"
}

apply_selected_labels() {
  local line entry type id
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    entry="${LABEL_TO_ENTRY[$line]:-}"
    [[ -z "$entry" ]] && continue
    type="${entry%%:*}"
    id="${entry#*:}"
    if [[ "$type" == component ]]; then
      if component_install "$id"; then
        STATE_COMPONENTS["$id"]=$(hash_dir "$(component_dir "$id")")
      else
        log_err "Failed to install $id — skipping, will ask again next run."
      fi
    else
      if pkg_install "$id"; then
        STATE_PACKAGES["$id"]=1
      else
        log_err "Failed to install $id — skipping, will retry next run."
      fi
    fi
  done
}

run_wizard() {
  local component_labels package_labels
  component_labels=$(build_component_labels)
  package_labels=$(build_package_labels)

  gum style --border rounded --padding "1 2" \
    --border-foreground "$INSTALLER_ACCENT_COLOR" --foreground "$INSTALLER_TEXT_COLOR" \
    "Dotfiles installer — $PLATFORM" "Space to toggle, enter to confirm, Esc/Ctrl+C to quit."

  local selected rc
  if [[ -n "$component_labels" ]]; then
    selected=$(gm_choose_multi "Dotfiles components" <<< "$component_labels")
    rc=$?
    check_cancel "$rc" "Cancelled — nothing installed."
    if [[ $rc -ne 0 ]]; then
      echo
      log_warn "Cancelled — nothing installed."
      exit 1
    fi
    apply_selected_labels <<< "$selected"
  fi

  if [[ -n "$package_labels" ]]; then
    selected=$(gm_choose_multi "Packages" <<< "$package_labels")
    rc=$?
    check_cancel "$rc" "Cancelled — some components may already be installed."
    if [[ $rc -ne 0 ]]; then
      echo
      log_warn "Cancelled — packages left unselected."
      exit 1
    fi
    apply_selected_labels <<< "$selected"
  fi
}

run_update() {
  local id dir new_hash
  log_info "Checking previously installed components for changes..."
  for id in "${!STATE_COMPONENTS[@]}"; do
    dir=$(component_dir "$id")
    if [[ ! -d "$dir" ]]; then
      log_warn "Component $id no longer exists on disk, dropping from state."
      unset 'STATE_COMPONENTS[$id]'
      continue
    fi
    new_hash=$(hash_dir "$dir")
    if [[ "$new_hash" != "${STATE_COMPONENTS[$id]}" ]]; then
      log_info "Changed: $id"
      if component_install "$id"; then
        STATE_COMPONENTS["$id"]="$new_hash"
      else
        log_err "Failed to reinstall $id — will retry next run."
      fi
    fi
  done

  log_info "Checking previously installed packages..."
  for id in "${!STATE_PACKAGES[@]}"; do
    if [[ -z "${PKG_INSTALL[$id]:-}" ]]; then
      log_warn "Package $id is no longer registered, dropping from state."
      unset 'STATE_PACKAGES[$id]'
      continue
    fi
    if ! pkg_is_installed "$id"; then
      log_info "Missing: $id"
      pkg_install "$id" || log_err "Failed to install $id — will retry next run."
    fi
  done

  local new_ids=()
  while IFS= read -r id; do
    [[ -n "${STATE_COMPONENTS[$id]+x}" ]] && continue
    new_ids+=("$id")
  done < <(discover_components)

  if [[ ${#new_ids[@]} -gt 0 ]]; then
    log_info "Found ${#new_ids[@]} new component(s) not yet in your setup."
    local rc
    for id in "${new_ids[@]}"; do
      gm_confirm "New component found: $(component_label "$id") — install it?"
      rc=$?
      check_cancel "$rc" "Cancelled — remaining new components were left untouched."
      if [[ $rc -eq 0 ]]; then
        if component_install "$id"; then
          STATE_COMPONENTS["$id"]=$(hash_dir "$(component_dir "$id")")
        else
          log_err "Failed to install $id — will ask again next run."
        fi
      fi
    done
  fi
}

if [[ ! -f "$(state_path)" ]]; then
  run_wizard
else
  run_update
fi

gum style --border rounded --padding "1 2" \
  --border-foreground "$INSTALLER_ACCENT_COLOR" --foreground "$INSTALLER_TEXT_COLOR" \
  "Done." "State saved to $(state_path)" "Run with --force to reselect everything."
