#!/usr/bin/env bash
# Stow-component discovery and install/remove. Sourced, never executed directly.
#
# A "component" is a directory under common/ or the current platform's dir
# (e.g. common/fish, archlinux/hypr). By default it's installed with plain
# `stow --restow`. If the component directory contains an executable
# install.sh, that script is used instead and must support two subcommands:
# `install.sh install` and `install.sh remove`. Use this for components that
# can't be wholesale-stowed (e.g. they'd clobber an app's own defaults).

# discover_components -> one "base/name" component id per line
discover_components() {
  local base d name
  for base in common "$PLATFORM"; do
    [[ -d "$DOTFILES_DIR/$base" ]] || continue
    for d in "$DOTFILES_DIR/$base"/*/; do
      [[ -d "$d" ]] || continue
      [[ -f "$d/.no-install" ]] && continue
      name=$(basename "$d")
      echo "$base/$name"
    done
  done
}

component_dir() { echo "$DOTFILES_DIR/$1"; }

# Reads the --target= value out of <base>/.stowrc (default: ~/.config), so
# selective per-component installs land in the same place a full `stow .`
# from inside that directory would use.
component_target_base() {
  local base="$1" rc target line
  rc="$DOTFILES_DIR/$base/.stowrc"
  target="$HOME/.config"
  if [[ -f "$rc" ]]; then
    line=$(grep -m1 -- '--target=' "$rc" || true)
    if [[ -n "$line" ]]; then
      target="${line#*--target=}"
      target="${target/#\~/$HOME}"
    fi
  fi
  echo "$target"
}

component_has_custom_installer() {
  [[ -x "$(component_dir "$1")/install.sh" ]]
}

_realdir() { (cd -P -- "$1" 2>/dev/null && pwd -P); }

# True if target_path is a symlink (or resolves through one) straight to
# source_dir — the layout a legacy whole-directory `stow .` leaves behind.
# Restowing through it would make stow link source_dir onto itself.
_is_legacy_whole_dir_link() {
  local target_path="$1" source_dir="$2"
  [[ -L "$target_path" ]] || return 1
  [[ "$(_realdir "$target_path")" == "$(_realdir "$source_dir")" ]]
}

component_label() {
  local id="$1" dir
  dir=$(component_dir "$id")
  if [[ -f "$dir/.description" ]]; then
    printf '%s — %s' "$id" "$(<"$dir/.description")"
  else
    printf '%s' "$id"
  fi
}

component_install() {
  local id="$1" base name dir base_target
  base="${id%%/*}"
  name="${id#*/}"
  dir=$(component_dir "$id")

  if component_has_custom_installer "$id"; then
    "$dir/install.sh" install
  else
    base_target=$(component_target_base "$base")
    if _is_legacy_whole_dir_link "$base_target/$name" "$dir"; then
      log_info "$id: already linked as a whole directory (pre-existing full stow) — leaving as is"
      return 0
    fi
    if [[ -L "$base_target/$name" ]]; then
      log_warn "$id: $base_target/$name is a symlink to something else ($(readlink "$base_target/$name")) — skipping to avoid clobbering it."
      return 1
    fi
    mkdir -p "$base_target/$name"
    (cd "$DOTFILES_DIR/$base" && stow --restow --no-folding -t "$base_target/$name" "$name")
  fi
}

component_remove() {
  local id="$1" base name dir base_target
  base="${id%%/*}"
  name="${id#*/}"
  dir=$(component_dir "$id")

  if component_has_custom_installer "$id"; then
    "$dir/install.sh" remove
  else
    base_target=$(component_target_base "$base")
    if _is_legacy_whole_dir_link "$base_target/$name" "$dir"; then
      rm -f "$base_target/$name"
    elif [[ -d "$base_target/$name" ]]; then
      (cd "$DOTFILES_DIR/$base" && stow --delete --no-folding -t "$base_target/$name" "$name")
      find "$base_target/$name" -depth -type d -empty -delete 2>/dev/null || true
    fi
  fi
}
