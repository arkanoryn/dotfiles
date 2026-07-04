#!/usr/bin/env bash
# macOS (Homebrew) package groups. Sourced by install.sh on Darwin only.
# Migrated from the brew install lines in README.md.

pkg_brew() { brew install "$@"; }
pkg_brew_cask() { brew install --cask "$@"; }
brew_formula_installed() { brew list --formula "$1" >/dev/null 2>&1; }
brew_cask_installed() { brew list --cask "$1" >/dev/null 2>&1; }

register_pkg macOS/stow "GNU Stow" \
  "brew_formula_installed stow" \
  "pkg_brew stow"

register_pkg macOS/wezterm "Wezterm" \
  "brew_cask_installed wezterm" \
  "pkg_brew_cask wezterm"

register_pkg macOS/fish "Fish shell" \
  "brew_formula_installed fish" \
  "pkg_brew fish"

register_pkg macOS/starship "Starship prompt" \
  "brew_formula_installed starship" \
  "pkg_brew starship"

register_pkg macOS/eza "Eza" \
  "brew_formula_installed eza" \
  "pkg_brew eza"

register_pkg macOS/zoxide "Zoxide" \
  "brew_formula_installed zoxide" \
  "pkg_brew zoxide"

register_pkg macOS/bat "Bat" \
  "brew_formula_installed bat" \
  "pkg_brew bat"

register_pkg macOS/fzf "fzf" \
  "brew_formula_installed fzf" \
  "pkg_brew fzf"

register_pkg macOS/lua "Lua" \
  "brew_formula_installed lua" \
  "pkg_brew lua"

register_pkg macOS/sketchybar "SketchyBar" \
  "brew_formula_installed sketchybar" \
  "pkg_brew sketchybar"

register_pkg macOS/borders "JankyBorders" \
  "brew_formula_installed borders" \
  "pkg_brew borders"

register_pkg macOS/aerospace "AeroSpace (tiling window manager)" \
  "brew_cask_installed aerospace" \
  "pkg_brew_cask nikitabobko/tap/aerospace"

register_pkg macOS/ripgrep "ripgrep" \
  "brew_formula_installed ripgrep" \
  "pkg_brew ripgrep"

register_pkg macOS/fd "fd" \
  "brew_formula_installed fd" \
  "pkg_brew fd"

register_pkg macOS/neovim "Neovim" \
  "brew_formula_installed neovim" \
  "pkg_brew neovim"

register_pkg macOS/tmux "tmux" \
  "brew_formula_installed tmux" \
  "pkg_brew tmux"

register_pkg macOS/sesh "sesh (tmux session manager)" \
  "brew_formula_installed sesh" \
  "pkg_brew sesh"

register_pkg macOS/television "television" \
  "brew_formula_installed television" \
  "pkg_brew television"
