#!/usr/bin/env bash
# Custom installer for the common/git component.
#
# Can't be plain-stowed: this repo's file is named "gitignore", but git's
# XDG global-ignore convention expects ~/.config/git/ignore (not gitignore).
# Invoked by install.sh's component_install/component_remove as:
#   install.sh install
#   install.sh remove
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
git_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/git"
target="$git_config_dir/ignore"

do_install() {
  mkdir -p "$git_config_dir"
  ln -sf "$script_dir/gitignore" "$target"
}

do_remove() {
  [[ -L "$target" ]] && rm -f "$target"
}

case "${1:-install}" in
  install) do_install ;;
  remove) do_remove ;;
  *)
    printf 'Usage: %s {install|remove}\n' "$0" >&2
    exit 1
    ;;
esac
