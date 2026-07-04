#!/usr/bin/env bash
# Arch Linux package groups. Sourced by install.sh on Linux only.
#
# Migrated from archlinux/setup_scripts/*.sh, flattened into atomic,
# idempotent entries (one tool = one wizard checkbox) instead of nested
# single-choice submenus, so selections survive into installer state.
#
# Fixes applied while migrating (the old archlinux/setup.sh did not work):
#   - apps.sh called install_terminal/install_shell/etc. before their
#     function definitions further down the file -> "command not found"
#     under `set -euo pipefail` the moment it ran.
#   - setup.sh referenced $NON_INTERACTIVE before it was ever set (only
#     utils.sh, sourced by the *sub*-scripts, defined it) -> unbound
#     variable error under `set -u`.
#   - arch_default.sh installed `base-level` (typo, should've been
#     base-devel) and `openssl-1.1` (long removed from the Arch repos).
#   - dev.sh pinned `python310`, which no longer exists once Arch has
#     moved python versions forward; use `python`.

pkg_pacman() { sudo pacman -S --noconfirm --needed "$@"; }
pkg_paru() {
  if ! command -v paru >/dev/null 2>&1; then
    log_err "paru is not installed — select 'archlinux/paru' first"
    return 1
  fi
  paru -S --noconfirm --needed "$@"
}
pkg_installed_pacman() { pacman -Qi "$1" >/dev/null 2>&1; }

register_pkg archlinux/base "Base tools (base-devel fd fzf git ripgrep stow tree)" \
  "pkg_installed_cmd stow" \
  "pkg_pacman base-devel fd fzf git less man-db ripgrep stow tree"

register_pkg archlinux/paru "paru (AUR helper)" \
  "pkg_installed_cmd paru" \
  "tmp=\$(mktemp -d) && git clone https://aur.archlinux.org/paru.git \"\$tmp/paru\" && (cd \"\$tmp/paru\" && makepkg -si --noconfirm) && rm -rf \"\$tmp\""

register_pkg archlinux/nvidia "NVIDIA drivers (dkms, utils, settings)" \
  "pkg_installed_pacman nvidia-dkms" \
  "pkg_paru nvidia-dkms nvidia-utils nvidia-settings libva-nvidia-driver"

register_pkg archlinux/nvidia-cuda "NVIDIA CUDA" \
  "pkg_installed_pacman cuda" \
  "pkg_paru cuda"

register_pkg archlinux/gui-packages "GUI plumbing (qt5ct, xdg-desktop-portal-hyprland, wl-clipboard, ...)" \
  "pkg_installed_pacman kvantum" \
  "pkg_pacman kvantum nwg-look qt5ct qt5-wayland qt6-wayland wl-clipboard xdg-desktop-portal-hyprland xdg-utils"

register_pkg archlinux/fonts "Fonts (FiraCode Nerd Font, Noto, Twemoji, Symbola)" \
  "pkg_installed_pacman ttf-firacode-nerd" \
  "pkg_paru ttf-symbola ttf-twemoji ttf-firacode-nerd && pkg_pacman noto-fonts-cjk noto-fonts-emoji woff2-font-awesome"

register_pkg archlinux/system-extras "System extras (sddm, cliphist, dunst, smartmontools, ...)" \
  "pkg_installed_cmd sddm" \
  "pkg_pacman openssh sddm wget unrar unzip zip cliphist efibootmgr smartmontools usbutils dunst notify-send.sh"

register_pkg archlinux/terminal-wezterm "Wezterm" \
  "pkg_installed_cmd wezterm" \
  "pkg_paru wezterm"

register_pkg archlinux/terminal-ghostty "Ghostty" \
  "pkg_installed_cmd ghostty" \
  "pkg_paru ghostty-git"

register_pkg archlinux/shell-fish "Fish shell" \
  "pkg_installed_cmd fish" \
  "pkg_pacman fish"

register_pkg archlinux/shell-zsh "Zsh" \
  "pkg_installed_cmd zsh" \
  "pkg_pacman zsh"

register_pkg archlinux/shelltools-starship "Starship prompt" \
  "pkg_installed_cmd starship" \
  "pkg_paru starship"

register_pkg archlinux/shelltools-zoxide "Zoxide" \
  "pkg_installed_cmd zoxide" \
  "pkg_pacman zoxide"

register_pkg archlinux/shelltools-bat "Bat" \
  "pkg_installed_cmd bat" \
  "pkg_pacman bat"

register_pkg archlinux/shelltools-eza "Eza" \
  "pkg_installed_cmd eza" \
  "pkg_paru eza"

register_pkg archlinux/launcher-walker "Walker (app launcher, repo package)" \
  "pkg_installed_cmd walker" \
  "pkg_pacman walker"

register_pkg archlinux/launcher-wofi "Wofi (app launcher)" \
  "pkg_installed_cmd wofi" \
  "pkg_pacman wofi"

register_pkg archlinux/explorer-dolphin "Dolphin file manager" \
  "pkg_installed_cmd dolphin" \
  "pkg_pacman dolphin"

register_pkg archlinux/explorer-yazi "Yazi (terminal file manager + deps)" \
  "pkg_installed_cmd yazi" \
  "pkg_pacman yazi 7zip fd ffmpeg fzf imagemagick jq poppler ripgrep zoxide"

register_pkg archlinux/browser-firefox "Firefox" \
  "pkg_installed_cmd firefox" \
  "pkg_pacman firefox"

register_pkg archlinux/browser-brave "Brave" \
  "pkg_installed_cmd brave" \
  "pkg_paru brave-bin"

register_pkg archlinux/browser-zen "Zen Browser" \
  "pkg_installed_cmd zen-browser" \
  "pkg_paru zen-browser-bin"

register_pkg archlinux/hyprland-suite "Hyprland suite (waybar, swaync, hypridle, hyprlock, hyprpaper, hyprshot, ...)" \
  "pkg_installed_cmd waybar" \
  "pkg_pacman libnotify pamixer pavucontrol swaync quickshell waybar && pkg_paru hypridle hyprlock hyprpaper hyprpolkitagent hyprshot"

register_pkg archlinux/walker-src "Walker app launcher (built from source, slow)" \
  "pkg_installed_cmd walker" \
  "tmp=\$(mktemp -d) && git clone https://github.com/abenz1267/walker.git \"\$tmp/walker\" && (cd \"\$tmp/walker\" && cargo build --release) && rm -rf \"\$tmp\""

register_pkg archlinux/elephant "Elephant (walker backend)" \
  "pkg_installed_cmd elephant" \
  "pkg_paru elephant elephant-desktopapplications"

register_pkg archlinux/network-tools "Network tools (NetworkManager, iwd, iftop, nethogs)" \
  "pkg_installed_cmd nmcli" \
  "pkg_pacman iwd iftop nethogs wireless_tools wpa_supplicant networkmanager"

register_pkg archlinux/vpn-protonvpn "Proton VPN GTK client" \
  "pkg_installed_cmd proton-vpn-app" \
  "pkg_paru proton-vpn-gtk-app"

register_pkg archlinux/dev-tools "Dev tools (jq, lazygit, htop, tmux, television, yarn, python)" \
  "pkg_installed_cmd lazygit" \
  "pkg_pacman jq npm htop lazygit python-pip python tmux television yarn"

register_pkg archlinux/dev-sesh "sesh (tmux session manager)" \
  "pkg_installed_cmd sesh" \
  "pkg_paru sesh-bin"

register_pkg archlinux/dev-docker "Docker + Docker Compose" \
  "pkg_installed_cmd docker" \
  "pkg_pacman docker docker-compose"

register_pkg archlinux/dev-miniconda "Miniconda3" \
  "pkg_installed_cmd conda" \
  "pkg_paru miniconda3"

register_pkg archlinux/dev-rust "Rust (cargo)" \
  "pkg_installed_cmd cargo" \
  "pkg_pacman rust"

register_pkg archlinux/dev-opencode "OpenCode" \
  "pkg_installed_cmd opencode" \
  "pkg_paru opencode"

register_pkg archlinux/dev-qmk "QMK firmware toolchain" \
  "pkg_installed_cmd qmk" \
  "pkg_pacman git python-pip libffi qmk && mkdir -p \"\$HOME/Code/qmk\" && qmk setup -H \"\$HOME/Code/qmk/qmk_firmware\" -y"

register_pkg archlinux/lazyvim-deps "LazyVim deps (node, npm, markdownlint)" \
  "pkg_installed_cmd markdownlint" \
  "pkg_pacman nodejs npm && npm install -g markdownlint-cli"

register_pkg archlinux/discord "Discord" \
  "pkg_installed_cmd discord" \
  "pkg_pacman discord"
