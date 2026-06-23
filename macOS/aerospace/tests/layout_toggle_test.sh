#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
SCRIPT="$ROOT_DIR/macOS/aerospace/scripts/layout_toggle.sh"

test_state_reports_current_layout_and_notifies_sketchybar() {
  local tmp_dir home_dir bin_dir log_file
  tmp_dir="$(mktemp -d)"
  home_dir="$tmp_dir/home"
  bin_dir="$tmp_dir/bin"
  log_file="$tmp_dir/commands.log"

  mkdir -p "$home_dir/.config/aerospace" "$bin_dir"
  printf 'accordion\n' >"$home_dir/.config/aerospace/.layout_config.conf"

  cat >"$bin_dir/sketchybar" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf 'sketchybar %s\n' "$*" >>"$COMMAND_LOG"
STUB
  chmod +x "$bin_dir/sketchybar"

  output="$(COMMAND_LOG="$log_file" HOME="$home_dir" PATH="$bin_dir:$PATH" "$SCRIPT" state)"

  [[ "$output" == "accordion" ]]
  grep -qx 'sketchybar --trigger aerospace_layout_update LAYOUT_STATE=accordion' "$log_file"

  rm -rf "$tmp_dir"
}

test_sync_reapplies_saved_layout_after_restart() {
  local tmp_dir home_dir bin_dir log_file output
  tmp_dir="$(mktemp -d)"
  home_dir="$tmp_dir/home"
  bin_dir="$tmp_dir/bin"
  log_file="$tmp_dir/commands.log"

  mkdir -p "$home_dir/.config/aerospace" "$bin_dir"
  printf 'accordion\n' >"$home_dir/.config/aerospace/.layout_config.conf"

  cat >"$bin_dir/aerospace" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf 'aerospace %s\n' "$*" >>"$COMMAND_LOG"
case "$*" in
  'list-workspaces --all') printf '1\n2\n' ;;
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

  output="$(COMMAND_LOG="$log_file" HOME="$home_dir" PATH="$bin_dir:$PATH" "$SCRIPT" sync)"

  [[ "$output" == "accordion" ]]
  [[ "$(grep -c '^aerospace layout accordion$' "$log_file")" -eq 2 ]]
  grep -qx 'aerospace workspace 2' "$log_file"
  grep -qx 'sketchybar --trigger aerospace_layout_update LAYOUT_STATE=accordion' "$log_file"

  rm -rf "$tmp_dir"
}

test_toggle_sets_all_existing_workspaces_and_restores_focus() {
  local tmp_dir home_dir bin_dir log_file
  tmp_dir="$(mktemp -d)"
  home_dir="$tmp_dir/home"
  bin_dir="$tmp_dir/bin"
  log_file="$tmp_dir/commands.log"

  mkdir -p "$home_dir/.config/aerospace" "$bin_dir"
  printf 'tiles\n' >"$home_dir/.config/aerospace/.layout_config.conf"

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

  output="$(COMMAND_LOG="$log_file" HOME="$home_dir" PATH="$bin_dir:$PATH" "$SCRIPT" toggle)"

  [[ "$output" == "accordion" ]]
  [[ "$(cat "$home_dir/.config/aerospace/.layout_config.conf")" == "accordion" ]]
  grep -qx 'aerospace workspace 1' "$log_file"
  grep -qx 'aerospace workspace 3' "$log_file"
  ! grep -qx 'aerospace workspace 4' "$log_file"
  [[ "$(grep -c '^aerospace layout accordion$' "$log_file")" -eq 2 ]]
  [[ "$(tail -n 1 "$log_file")" == 'sketchybar --trigger aerospace_layout_update LAYOUT_STATE=accordion' ]]
  grep -qx 'aerospace workspace 3' "$log_file"

  rm -rf "$tmp_dir"
}

test_state_reports_current_layout_and_notifies_sketchybar
test_sync_reapplies_saved_layout_after_restart
test_toggle_sets_all_existing_workspaces_and_restores_focus

echo "layout toggle tests passed"
