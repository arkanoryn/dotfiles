#!/usr/bin/env bash
set -euo pipefail

QWERTY_KEYMAP="qwerty"
LAPTOP_KEYMAP="laptop"
GRAPHITE_KEYMAP="graphite"
DEFAULT_KEYMAP="$QWERTY_KEYMAP"

AEROSPACE_DIR="${AEROSPACE_DIR:-$HOME/.config/aerospace}"
KEYMAP_FILE="${KEYMAP_FILE:-$HOME/.config/sketchybar/keymap.conf}"
LAYOUT_FILE="${LAYOUT_FILE:-$AEROSPACE_DIR/.layout_config.conf}"

update_keymap_config() {
  mkdir -p "$(dirname "$KEYMAP_FILE")"
  echo "$1" >"$KEYMAP_FILE"
}

fetch_current_keymap() {
  if [ -e "$KEYMAP_FILE" ]; then
    cat "$KEYMAP_FILE"
  else
    echo "$DEFAULT_KEYMAP"
  fi
}

layout_for_keymap() {
  case "$1" in
  "$LAPTOP_KEYMAP") echo "accordion" ;;
  "$QWERTY_KEYMAP" | "$GRAPHITE_KEYMAP") echo "tiles" ;;
  *) echo "tiles" ;;
  esac
}

validate_keymap() {
  case "$1" in
  "$QWERTY_KEYMAP" | "$LAPTOP_KEYMAP" | "$GRAPHITE_KEYMAP") return 0 ;;
  *)
    echo "Unsupported keymap: $1" >&2
    return 1
    ;;
  esac
}

# Swap the configuration for aerospace and reload the config.
update_aerospace() {
  local keymap="$1"
  local source_config="$AEROSPACE_DIR/aerospace-$keymap.toml"
  local target_config="$AEROSPACE_DIR/aerospace.toml"

  if [ ! -f "$source_config" ]; then
    echo "Missing AeroSpace config: $source_config" >&2
    return 1
  fi

  cp "$source_config" "$target_config"
  aerospace reload-config
}

set_all_workspace_layouts() {
  local layout="$1"
  local focused_workspace=""
  local workspace=""

  focused_workspace="$(aerospace list-workspaces --focused 2>/dev/null || true)"

  while IFS= read -r workspace; do
    [ -n "$workspace" ] || continue
    aerospace workspace "$workspace"
    aerospace flatten-workspace-tree
    aerospace layout "$layout"
  done < <(aerospace list-workspaces --all)

  if [ -n "$focused_workspace" ]; then
    aerospace workspace "$focused_workspace"
  fi

  mkdir -p "$(dirname "$LAYOUT_FILE")"
  echo "$layout" >"$LAYOUT_FILE"
  notify_sketchybar_with_layout_state "$layout"
}

notify_sketchybar_with_keyboard_state() {
  sketchybar --trigger keyboard_state_update KEYBOARD_STATE="$1"
}

notify_sketchybar_with_layout_state() {
  sketchybar --trigger aerospace_layout_update LAYOUT_STATE="$1"
}

select_keymap() {
  local new_keymap="$1"
  local new_layout=""

  validate_keymap "$new_keymap"
  new_layout="$(layout_for_keymap "$new_keymap")"

  update_aerospace "$new_keymap"
  set_all_workspace_layouts "$new_layout"
  update_keymap_config "$new_keymap"
  notify_sketchybar_with_keyboard_state "$new_keymap"
  echo "$new_keymap"
}

swap_keymap() {
  local current_keymap=""
  local new_keymap=""

  current_keymap="$(fetch_current_keymap)"

  if [ "$current_keymap" = "$QWERTY_KEYMAP" ]; then
    new_keymap="$GRAPHITE_KEYMAP"
  elif [ "$current_keymap" = "$GRAPHITE_KEYMAP" ]; then
    new_keymap="$LAPTOP_KEYMAP"
  elif [ "$current_keymap" = "$LAPTOP_KEYMAP" ]; then
    new_keymap="$QWERTY_KEYMAP"
  else
    new_keymap="$DEFAULT_KEYMAP"
  fi

  select_keymap "$new_keymap"
}

case "${1:-}" in
state)
  notify_sketchybar_with_keyboard_state "$(fetch_current_keymap)"
  fetch_current_keymap
  ;;
select)
  select_keymap "${2:-}"
  ;;
swapped)
  swap_keymap
  ;;
*)
  echo "Usage: $0 {state|swapped|select <qwerty|laptop|graphite>}" >&2
  exit 2
  ;;
esac
