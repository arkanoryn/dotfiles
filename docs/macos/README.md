# macOS Configuration Documentation

This directory contains documentation for the macOS-specific configurations in this dotfiles repository.

## Overview

The `macOS/` directory contains configurations for:
- **AeroSpace**: A tiling window manager for macOS
- **SketchyBar**: A highly customizable status bar for macOS
- **Scripts**: Various utility scripts for system management

## Structure

```
macOS/
├── aerospace/
│   ├── aerospace-graphite.toml
│   ├── aerospace-laptop.toml
│   ├── aerospace-qwerty.toml
│   └── scripts/
│       └── layout_toggle.sh
├── sketchybar/
│   ├── bar.lua
│   ├── config/
│   │   ├── app_icons.lua
│   │   ├── colors.lua
│   │   ├── icons.lua
│   │   ├── laptop_config.lua
│   │   ├── paths.lua
│   │   └── settings.lua
│   ├── default.lua
│   ├── init.lua
│   ├── items/
│   │   ├── aerospace_modes.lua
│   │   ├── apple.lua
│   │   ├── battery.lua
│   │   ├── calendar.lua
│   │   ├── front_app.lua
│   │   ├── init.lua
│   │   ├── keyboard.lua
│   │   ├── netstat.lua
│   │   ├── uname.lua
│   │   └── volume.lua
│   ├── plugins/
│   │   ├── keyboard.sh
│   │   └── netstat.sh
│   └── themes/
│       └── arrows.lua
└── .stowrc
```

## AeroSpace Configuration

AeroSpace is a tiling window manager for macOS that provides efficient window management and workspace organization. The configuration is split into multiple files for different keyboard layouts:

- **aerospace-graphite.toml**: Configuration for Graphite keyboard layout
- **aerospace-laptop.toml**: Configuration for laptop use
- **aerospace-qwerty.toml**: Configuration for QWERTY keyboard layout
- **scripts/layout_toggle.sh**: Script to toggle between different layouts

### Key Features

- **Dual Keyboard Layout Support**: Configurations for both QWERTY and Graphite keyboard layouts
- **Modular Configuration**: Easy to maintain and update individual aspects of the setup
- **Custom Keybindings**: Optimized for productivity with a focus on window management
- **Integration with SketchyBar**: Notifies SketchyBar about workspace changes

### Keybindings

The keybindings are designed to be efficient and intuitive. The main modifier is the `ctrl-shift-alt` (meh) key combination.

#### General Shortcuts

- `ctrl-shift-alt-Q`: Open 1Password
- `ctrl-shift-alt-W`: Open Brave Browser
- `ctrl-shift-alt-E`: Open Obsidian
- `ctrl-shift-alt-R`: Open Alfred
- `ctrl-shift-alt-T`: Open Zoom
- `ctrl-shift-alt-A`: Open Harvest
- `ctrl-shift-alt-S`: Open Things3
- `ctrl-shift-alt-D`: Open WezTerm
- `ctrl-shift-alt-F`: Open Slack
- `ctrl-shift-alt-G`: Open Google Chrome
- `ctrl-shift-alt-Z`: Open WezTerm
- `ctrl-shift-alt-X`: Open HazeOver
- `ctrl-shift-alt-C`: Open Mail
- `ctrl-shift-alt-V`: Open Code

#### Window Management

- `alt-J/K/L/;`: Move focus (left/down/up/right)
- `ctrl-shift-alt-J/K/L/;`: Move focus with wrap-around
- `ctrl-shift-alt-U/I/O/P`: Switch to workspace 1/2/3/4

#### Modes

- `ctrl-shift-alt-P`: Enter selection mode
- `ctrl-shift-alt-1`: Enter workspace mode
- `ctrl-shift-alt-comma`: Enter layout mode

### Layout Toggle Script

The `layout_toggle.sh` script allows switching between different keyboard layouts.

## SketchyBar Configuration

SketchyBar is a highly customizable status bar for macOS. The configuration is written in Lua and includes:

- **bar.lua**: Main bar configuration
- **config/**: Configuration files for colors, icons, and settings
  - `app_icons.lua`: Application icons
  - `colors.lua`: Color scheme definitions
  - `icons.lua`: Icon definitions
  - `laptop_config.lua`: Laptop-specific configuration
  - `paths.lua`: Path definitions
  - `settings.lua`: General settings
- **default.lua**: Default configuration
- **init.lua**: Initialization script
- **items/**: Individual item configurations
  - `aerospace_modes.lua`: AeroSpace modes indicator
  - `apple.lua`: Apple logo and preferences
  - `battery.lua`: Battery status
  - `calendar.lua`: Calendar and time
  - `front_app.lua`: Front application indicator
  - `init.lua`: Items initialization
  - `keyboard.lua`: Keyboard layout indicator
  - `netstat.lua`: Network statistics
  - `uname.lua`: User information
  - `volume.lua`: Volume control
- **plugins/**: Utility scripts for SketchyBar
  - `keyboard.sh`: Keyboard layout management
  - `netstat.sh`: Network statistics monitoring
- **themes/**: Theme configurations
  - `arrows.lua`: Arrow theme

### Key Features

- **Modular Design**: Each item is configured separately for easy customization
- **Custom Scripts**: Enhanced functionality through custom scripts
- **Styling**: Uses Lua for flexible theming
- **Integration**: Works seamlessly with AeroSpace and other macOS applications

### Color Scheme

The color scheme is based on Catppuccin Mocha and includes definitions for various colors.

### Items Configuration

Each item in SketchyBar is configured with specific properties for different functionalities.

### Plugins

- **keyboard.sh**: Manages keyboard layout switching and state
- **netstat.sh**: Monitors network statistics and updates SketchyBar

## Usage

To use these configurations, you can either:

1. **Symlink the entire macOS directory** to your `~/.config` directory:
   ```bash
   cd ~/.dotfiles/macOS
   stow .
   ```

2. **Symlink individual components** as needed:
   ```bash
   cd ~/.dotfiles/macOS
   stow aerospace sketchybar
   ```

## Customization

The configurations are designed to be modular and customizable. You can modify individual files, add new items, change keybindings, and adjust styling.

## Troubleshooting

If you encounter issues, check logs, verify dependencies, review configuration, and consult documentation.

## Notes

- The configurations assume a specific directory structure and may need adjustments for your system
- Some configurations reference files or directories that may not exist by default
- The setup scripts are designed for a fresh macOS installation and may need modifications for existing systems