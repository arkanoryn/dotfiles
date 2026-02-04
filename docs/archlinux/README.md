# Arch Linux Configuration Documentation

This directory contains documentation for the Arch Linux-specific configurations in this dotfiles repository.

## Overview

The `archlinux/` directory contains configurations for:
- **Hyprland**: A dynamic tiling Wayland compositor
- **Waybar**: A highly customizable Wayland bar
- **SwayNC**: A notification center for Wayland
- **Scripts**: Various utility scripts for system management
- **Setup Scripts**: Scripts to automate the setup of the Arch Linux environment

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

## Hyprland Configuration

Hyprland is the primary window manager used in this setup. The configuration is split into multiple files for better organization:

- **hyprland.conf**: Main configuration file that sources other configuration files
- **config/**: Contains modular configuration files for different aspects of Hyprland
  - `aesthetics.conf`: Visual settings like gaps, borders, and animations
  - `apps.conf`: Application-specific settings
  - `autostart.conf`: Applications to start with Hyprland
  - `environment.conf`: Environment variables
  - `keybindings.conf`: Default keybindings (QWERTY layout)
  - `keybindings.graphite.conf`: Keybindings for Graphite keyboard layout
  - `keybindings.qwerty.conf`: Keybindings for QWERTY keyboard layout
  - `layouts.conf`: Window layout settings
  - `variables.conf`: Variable definitions for applications

### Key Features

- **Dual Keyboard Layout Support**: Configurations for both QWERTY and Graphite keyboard layouts
- **Modular Configuration**: Easy to maintain and update individual aspects of the setup
- **Custom Keybindings**: Optimized for productivity with a focus on window management
- **Autostart Applications**: Automatically starts essential applications like Waybar, SwayNC, and Hyprpaper

### Keybindings

The keybindings are designed to be efficient and intuitive. The main modifier is the `SUPER` key (Windows key), and the `meh` key (ALT&CONTROL&SHIFT) is used for more complex actions.

#### General Shortcuts

- `SUPER + Q`: Kill active window
- `SUPER + SHIFT + Q`: Kill all windows of the current application
- `SUPER + meh + Q`: Logout
- `SUPER + L`: Lock screen

#### Application Launchers

- `meh + T`: Open terminal
- `meh + G`: Open browser
- `meh + V`: Open file manager
- `meh + W`: Open application launcher

#### Window Management

- `meh + H/J/K/L`: Move focus (left/down/up/right)
- `meh + U`: Toggle floating mode
- `meh + I/P`: Resize active window

#### Workspace Management

- `meh + U/I/O/P`: Switch to workspace 1/2/3/4
- `meh + M`: Enter workspace mode
- `meh + comma`: Enter layout mode
- `meh + N`: Enter selection mode

## Waybar Configuration

Waybar is a highly customizable status bar for Wayland compositors. The configuration includes:

- **config.jsonc**: Main configuration file defining the bar's structure and modules
- **style.css**: Styling for the bar and its modules
- **modules/**: Individual module configurations
  - `clock.jsonc`: Time and date display
  - `cpu.jsonc`: CPU usage and temperature
  - `gpu.jsonc`: GPU usage and temperature
  - `memory.jsonc`: Memory usage
  - `pending_updates.jsonc`: System updates notification
  - `power.jsonc`: Power/battery status
  - `submap.jsonc`: Submap indicator
  - `workspaces.jsonc`: Workspace indicator
- **scripts/**: Utility scripts for Waybar modules
  - `cpuinfo.sh`: CPU information and temperature
  - `gpuinfo.sh`: GPU information and temperature
  - `pending_update.sh`: Check for pending updates
  - `volumecontrol.sh`: Volume control
  - `wallpaper.sh`: Wallpaper management

### Key Features

- **Modular Design**: Each module is configured separately for easy customization
- **Custom Scripts**: Enhanced functionality through custom scripts
- **Styling**: Uses CSS for flexible theming
- **Integration**: Works seamlessly with Hyprland and other Wayland applications

## SwayNC Configuration

SwayNC is a notification center for Wayland compositors. The configuration includes:

- **config.json**: Main configuration file defining the notification center's behavior and appearance

### Key Features

- **Positioning**: Centered at the top of the screen
- **Widgets**: Includes DND (Do Not Disturb), buttons grid, MPRIS (media player), volume, backlight, and notifications
- **Customization**: Various settings for appearance and behavior

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
