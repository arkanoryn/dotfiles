#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
SCRIPT="$ROOT_DIR/macOS/sketchybar/plugins/keyboard.sh"

test_select_laptop_sets_keymap_and_all_workspaces_to_accordion() {
  local tmp_dir home_dir bin_dir log_file
  tmp_dir="$(mktemp -d)"
  home_dir="$tmp_dir/home"
  bin_dir="$tmp_dir/bin"
  log_file="$tmp_dir/commands.log"

  mkdir -p "$home_dir/.config/aerospace" "$home_dir/.config/sketchybar" "$bin_dir"
  printf 'laptop config\n' >"$home_dir/.config/aerospace/aerospace-laptop.toml"
  printf 'qwerty\n' >"$home_dir/.config/sketchybar/keymap.conf"

  cat >"$bin_dir/aerospace" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf 'aerospace %s\n' "$*" >>"$COMMAND_LOG"
case "$*" in
  'list-workspaces --all') printf '1\n3\n' ;;
  'list-workspaces --focused') printf '3\n' ;;
esac
STUB
  chmod +x "$bin_dir/aerospace"

  cat >"$bin_dir/sketchybar" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf 'sketchybar %s\n' "$*" >>"$COMMAND_LOG"
STUB
  chmod +x "$bin_dir/sketchybar"

  COMMAND_LOG="$log_file" HOME="$home_dir" PATH="$bin_dir:$PATH" "$SCRIPT" select laptop >/dev/null

  [[ "$(cat "$home_dir/.config/sketchybar/keymap.conf")" == "laptop" ]]
  cmp -s "$home_dir/.config/aerospace/aerospace-laptop.toml" "$home_dir/.config/aerospace/aerospace.toml"
  grep -qx 'aerospace workspace 1' "$log_file"
  grep -qx 'aerospace workspace 3' "$log_file"
  ! grep -qx 'aerospace workspace 4' "$log_file"
  [[ "$(grep -c '^aerospace layout accordion$' "$log_file")" -eq 2 ]]
  grep -qx 'aerospace workspace 3' "$log_file"
  grep -qx 'sketchybar --trigger keyboard_state_update KEYBOARD_STATE=laptop' "$log_file"
  grep -qx 'sketchybar --trigger aerospace_layout_update LAYOUT_STATE=accordion' "$log_file"

  rm -rf "$tmp_dir"
}

test_select_graphite_sets_keymap_and_all_workspaces_to_tiles() {
  local tmp_dir home_dir bin_dir log_file
  tmp_dir="$(mktemp -d)"
  home_dir="$tmp_dir/home"
  bin_dir="$tmp_dir/bin"
  log_file="$tmp_dir/commands.log"

  mkdir -p "$home_dir/.config/aerospace" "$home_dir/.config/sketchybar" "$bin_dir"
  printf 'graphite config\n' >"$home_dir/.config/aerospace/aerospace-graphite.toml"
  printf 'laptop\n' >"$home_dir/.config/sketchybar/keymap.conf"

  cat >"$bin_dir/aerospace" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf 'aerospace %s\n' "$*" >>"$COMMAND_LOG"
case "$*" in
  'list-workspaces --all') printf '1\n2\n4\n' ;;
  'list-workspaces --focused') printf '2\n' ;;
esac
STUB
  chmod +x "$bin_dir/aerospace"

  cat >"$bin_dir/sketchybar" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf 'sketchybar %s\n' "$*" >>"$COMMAND_LOG"
STUB
  chmod +x "$bin_dir/sketchybar"

  COMMAND_LOG="$log_file" HOME="$home_dir" PATH="$bin_dir:$PATH" "$SCRIPT" select graphite >/dev/null

  [[ "$(cat "$home_dir/.config/sketchybar/keymap.conf")" == "graphite" ]]
  cmp -s "$home_dir/.config/aerospace/aerospace-graphite.toml" "$home_dir/.config/aerospace/aerospace.toml"
  [[ "$(grep -c '^aerospace layout tiles$' "$log_file")" -eq 3 ]]
  grep -qx 'aerospace workspace 2' "$log_file"
  grep -qx 'sketchybar --trigger keyboard_state_update KEYBOARD_STATE=graphite' "$log_file"
  grep -qx 'sketchybar --trigger aerospace_layout_update LAYOUT_STATE=tiles' "$log_file"

  rm -rf "$tmp_dir"
}

test_select_laptop_sets_keymap_and_all_workspaces_to_accordion
test_select_graphite_sets_keymap_and_all_workspaces_to_tiles

echo "keyboard tests passed"
