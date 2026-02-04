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
