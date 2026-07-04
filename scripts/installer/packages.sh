#!/usr/bin/env bash
# Generic package-group registry. Sourced, never executed directly.
#
# Each package group is atomic (one tool / one decision), so the wizard can
# present a flat checklist. Register with:
#   register_pkg <id> <description> <check-cmd-string> <install-cmd-string>
# check-cmd-string is eval'd and must exit 0 if already installed (idempotency
# check, e.g. after a --force reselect or if something was removed outside
# the installer). install-cmd-string is eval'd to install it.

declare -a PKG_ORDER=()
declare -A PKG_DESC=()
declare -A PKG_CHECK=()
declare -A PKG_INSTALL=()

register_pkg() {
  local id="$1" desc="$2" check="$3" install="$4"
  PKG_ORDER+=("$id")
  PKG_DESC["$id"]="$desc"
  PKG_CHECK["$id"]="$check"
  PKG_INSTALL["$id"]="$install"
}

pkg_is_installed() { eval "${PKG_CHECK[$1]}" &>/dev/null; }

pkg_install() {
  local id="$1"
  if pkg_is_installed "$id"; then
    log_info "Already installed: ${PKG_DESC[$id]}"
    return 0
  fi
  log_info "Installing: ${PKG_DESC[$id]}"
  eval "${PKG_INSTALL[$id]}"
}

pkg_label() { printf '%s — %s' "$1" "${PKG_DESC[$1]}"; }

# Shared install/check primitives used by platform package files -----------

pkg_installed_cmd() { command -v "$1" >/dev/null 2>&1; }
