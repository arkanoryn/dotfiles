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

### .stowrc File

The \`.stowrc\` file contains configuration for GNU Stow, which manages symlinking of dotfiles. It specifies files and directories to ignore during the stow process.


## AeroSpace Introduction

[AeroSpace](https://github.com/nikitabobko/AeroSpace) is an i3-like tiling window manager for macOS designed to reduce mouse usage and improve productivity. It replaces tools like Hotkey App and Magnet, providing more flexibility for window management on large screens.

### Philosophy

AeroSpace uses a mode-based system similar to NeoVim, allowing access to virtually unlimited key combinations through different modes. This foundation enables efficient window and application management without requiring the mouse.

### Key Features


### Graphite Keyboard Layout

This configuration supports the [Graphite keyboard layout](https://github.com/rdavison/graphite-layout), an alternative layout designed for efficiency and ergonomics. Graphite differs significantly from QWERTY and is optimized for custom keyboards.

Key characteristics:
- Designed for efficiency and reduced finger movement
- Optimized for custom keyboard layouts
- Different key positions compared to QWERTY
- Full support in AeroSpace configurations

For QWERTY users, equivalent configurations are provided in `aerospace-qwerty.toml`.


- **Tiling Window Management**: Automatic window arrangement with customizable layouts
- **Mode-Based Navigation**: Different modes for window selection, workspace management, and layout control
- **Application Launching**: Built-in application launcher functionality
- **Mouse Positioning**: Centers mouse pointer in selected windows (useful for large screens)
- **TOML Configuration**: Easy to configure and portable across different macOS installations
- **Graphite Layout Support**: Full support for alternative keyboard layouts like Graphite

### Integration

AeroSpace works seamlessly with:
- **SketchyBar**: Status bar integration for workspace indicators
- **Janky_Borders**: Window border customization for better visual feedback
- **Custom Keyboards**: Supports special modifier keys like the `meh` key

### Comparison with Other Tools

**Hotkey App + Magnet** (Previous Setup):
- ✅ Simple and easy to use
- ✅ Good for basic window management
- ❌ Limited flexibility in window sizing
- ❌ Requires mouse for some operations

**AeroSpace**:
- ✅ Advanced tiling capabilities
- ✅ Full keyboard-driven workflow
- ✅ Better for large/ultrawide monitors
- ✅ More customizable and scriptable
- ❌ Steeper learning curve

For most users, Hotkey App + Magnet may be sufficient. AeroSpace is ideal for developers and power users who want complete keyboard control over their window management.


## AeroSpace Configuration

AeroSpace is a tiling window manager for macOS that provides efficient window management and workspace organization. The configuration is split into multiple files for different keyboard layouts:

- **aerospace-graphite.toml**: Configuration for Graphite keyboard layout
- **aerospace-laptop.toml**: Configuration for laptop use
- **aerospace-qwerty.toml**: Configuration for QWERTY keyboard layout
- **scripts/layout_toggle.sh**: Script to toggle between different layouts

### Key Features


### Graphite Keyboard Layout

This configuration supports the [Graphite keyboard layout](https://github.com/rdavison/graphite-layout), an alternative layout designed for efficiency and ergonomics. Graphite differs significantly from QWERTY and is optimized for custom keyboards.

Key characteristics:
- Designed for efficiency and reduced finger movement
- Optimized for custom keyboard layouts
- Different key positions compared to QWERTY
- Full support in AeroSpace configurations

For QWERTY users, equivalent configurations are provided in `aerospace-qwerty.toml`.


- **Dual Keyboard Layout Support**: Configurations for both QWERTY and Graphite keyboard layouts
- **Modular Configuration**: Easy to maintain and update individual aspects of the setup
- **Custom Keybindings**: Optimized for productivity with a focus on window management
- **Integration with SketchyBar**: Notifies SketchyBar about workspace changes

### Keybindings


### Special Keys and Modifiers

#### Meh Key

The `meh` key is a special modifier key bound to the space key when held. It's equivalent to pressing `CTRL+SHIFT+ALT` simultaneously. This key is essential for AeroSpace's keyboard-driven workflow:

- **meh + [key]**: Primary shortcuts for window and application management
- **alt + [key]**: Secondary shortcuts for window selection
- **ctrl-shift-alt + [key]**: Alternative notation for the same meh key combinations

#### Hand Distribution

The configuration follows an ergonomic hand distribution:
- **Left Hand**: Application management (meh + letter keys)
- **Right Hand**: Window management (meh + directional keys)
- **Home Row Focus**: Most shortcuts use home row keys for efficiency

#### Directional Keys

Directional navigation uses NeoVim-style keys:
- `h`: Left
- `a`: Down (Graphite layout)
- `e`: Up (Graphite layout)  
- `i`: Right (Graphite layout)

For QWERTY layouts, standard `h/j/k/l` keys are used.


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


### AeroSpace Modes

AeroSpace uses different modes for efficient window management:

#### Main Mode

The default mode for general operations:
- **Window Navigation**: meh + h/a/e/i (left/down/up/right)
- **Workspace Switching**: meh + f/o/u/j (workspaces 1-4)
- **Application Launching**: meh + [letter] for specific apps
- **Mode Switching**: meh + p (selection), meh + . (workspace), meh + < (layout)

#### Selection Mode

For advanced window selection and management:
- Enter with: meh + p
- Navigate windows with directional keys
- Perform actions on selected windows

#### Workspace Mode

For workspace organization:
- Enter with: meh + .
- Create, rename, and switch workspaces
- Move windows between workspaces

#### Layout Mode

For window layout customization:
- Enter with: meh + <
- Change window layouts (tiled, floating, etc.)
- Adjust window sizes and positions


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


### Graphite Keyboard Layout

This configuration supports the [Graphite keyboard layout](https://github.com/rdavison/graphite-layout), an alternative layout designed for efficiency and ergonomics. Graphite differs significantly from QWERTY and is optimized for custom keyboards.

Key characteristics:
- Designed for efficiency and reduced finger movement
- Optimized for custom keyboard layouts
- Different key positions compared to QWERTY
- Full support in AeroSpace configurations

For QWERTY users, equivalent configurations are provided in `aerospace-qwerty.toml`.


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

## Comparison with Arch Linux Setup

For a comparison of equivalent tools and workflows between macOS and Arch Linux, see the [[Arch Linux Configuration]] documentation.
