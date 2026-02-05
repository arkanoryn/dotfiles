# Arch Linux Configuration Documentation

This directory contains documentation for the Arch Linux-specific configurations in this dotfiles repository.

## Overview

The `archlinux/` directory contains configurations for:
- **Hyprland**: A dynamic tiling Wayland compositor (see [Hyprland documentation](hyprland.md), macOS equivalent: [[AeroSpace]])
- **Waybar**: A highly customizable Wayland bar (see [Waybar documentation](waybar.md), macOS equivalent: [[SketchyBar]])
- **SwayNC**: A notification center for Wayland (see [SwayNC documentation](swayNC.md))
- **Scripts**: Various utility scripts for system management
- **Setup Scripts**: Scripts to automate the setup of the Arch Linux environment

For a complete overview, see the [Arch Linux Documentation Index](Index.md).

## Structure

```
archlinux/
├── hypr/
│   ├── apps/
│   ├── config/
│   ├── hypridle.conf
│   ├── hyprland.conf
│   ├── hyprlock.conf
│   └── hyprpaper.conf
├── waybar/
│   ├── config.jsonc
│   ├── style.css
│   ├── modules/
│   └── scripts/
├── swaync/
│   └── config.json
├── scripts/
│   └── arch_update.sh
└── setup_scripts/
    ├── arch_default.sh
    ├── hyprland.sh
    ├── apps.sh
    └── llm_agents.sh
```

## Scripts

### arch_update.sh

A script to update the Arch Linux system. It performs the following actions:

- Updates the package database
- Upgrades all installed packages
- Cleans up unnecessary packages and cache

## Setup Scripts

The setup scripts automate the installation and configuration of the Arch Linux environment:

### arch_default.sh

Installs essential packages and tools:

- **Base Packages**: fd, fzf, git, less, man-db, ripgrep, stow, tree
- **GUI Packages**: kvantum, nwg-look, qt5ct, qt5-wayland, qt6-wayland
- **Fonts**: ttf-symbola, ttf-twemoji, noto-fonts-cjk, noto-fonts-emoji, woff2-font-awesome
- **Optional**: Paru (AUR helper), NVIDIA drivers

### hyprland.sh

Installs Hyprland and related packages:

- **Hyprland**: libnotify, pamixer, pavucontrol, sddm-theme-sugar-candy, swaync, quickshell, waybar
- **Walker**: A custom application launcher built from source
- **Elephant**: A desktop application launcher

### apps.sh

Installs various applications and tools:

- **Yazi**: Terminal file manager with dependencies
- **Ghostty**: Terminal emulator
- **Fish Shell**: With starship, eza, fzf, zoxide, bat
- **Neovim**: With LazyVim configuration
- **Coding Environment**: Cargo (Rust), Elixir, QMK
- **LazyVim Dependencies**: Node.js, npm, markdownlint-cli
- **Applications**: Discord, Brave, OpenCode, MistralVibe 2.0

### llm_agents.sh

Sets up LLM (Language Model) agents:

- **Mistral Vibe**: Configures the Mistral Vibe agent with shared resources and specific configurations
- **OpenCode**: Configures the OpenCode agent with shared resources and specific configurations

## Usage

To use these configurations, you can either:

1. **Symlink the entire archlinux directory** to your `~/.config` directory:
   ```bash
   cd ~/.dotfiles/archlinux
   stow .
   ```

2. **Symlink individual components** as needed:
   ```bash
   cd ~/.dotfiles/archlinux
   stow hypr waybar swaync
   ```

## Customization

The configurations are designed to be modular and customizable. You can:

- **Modify individual files**: Each configuration file is well-commented and organized
- **Add new modules**: For Waybar, you can add new modules by creating new JSON files in the `modules/` directory
- **Change keybindings**: Edit the keybinding files to match your preferred layout
- **Adjust styling**: Modify the CSS files to change the appearance

## Troubleshooting

If you encounter issues:

1. **Check logs**: Most applications provide logs that can help identify the problem
2. **Verify dependencies**: Ensure all required packages are installed
3. **Review configuration**: Check for syntax errors or incorrect settings
4. **Consult documentation**: Refer to the official documentation for each application

## Notes

- The configurations assume a specific directory structure and may need adjustments for your system
- Some configurations reference files or directories that may not exist by default
- The setup scripts are designed for a fresh Arch Linux installation and may need modifications for existing systems


## Comparison with macOS Setup

For a comparison of equivalent tools and workflows between Arch Linux and macOS, see the [[macOS Configuration]] documentation.
