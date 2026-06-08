#!/usr/bin/env bash
set -euo pipefail

AEROSPACE_DIR="${AEROSPACE_DIR:-$HOME/.config/aerospace}"
LAYOUT_FILE="${LAYOUT_FILE:-$AEROSPACE_DIR/.layout_config.conf}"
DEFAULT_LAYOUT="tiles"

fetch_current_layout() {
  if [ -e "$LAYOUT_FILE" ]; then
    cat "$LAYOUT_FILE"
  else
    echo "$DEFAULT_LAYOUT"
  fi
}

next_layout() {
  case "$1" in
  accordion) echo "tiles" ;;
  tiles) echo "accordion" ;;
  *) echo "accordion" ;;
  esac
}

notify_sketchybar_with_layout_state() {
  sketchybar --trigger aerospace_layout_update LAYOUT_STATE="$1"
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
  echo "$layout"
}

case "${1:-toggle}" in
state)
  current_layout="$(fetch_current_layout)"
  notify_sketchybar_with_layout_state "$current_layout"
  echo "$current_layout"
  ;;
toggle)
  set_all_workspace_layouts "$(next_layout "$(fetch_current_layout)")"
  ;;
*)
  echo "Usage: $0 {state|toggle}" >&2
  exit 2
  ;;
esac
