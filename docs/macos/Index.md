# macOS Documentation Index

Welcome to the macOS documentation for this dotfiles repository. This index provides an overview of the macOS-specific configurations and guides you to the appropriate documentation.

## 📚 Table of Contents

### 🎯 Core Components

- **[AeroSpace](aerospace.md)**: Tiling window manager for macOS
  - Keyboard-driven window management
  - Multiple workspace layouts
  - Application launching and switching
  - Mouse pointer centering

- **[SketchyBar](sketchybar.md)**: Customizable status bar for macOS
  - System monitoring widgets
  - Application indicators
  - Customizable appearance
  - Workspace management

### 📁 Directory Structure

```
macOS/
├── aerospace/          # AeroSpace window manager
│   ├── aerospace-graphite.toml
│   ├── aerospace-laptop.toml
│   ├── aerospace-qwerty.toml
│   └── scripts/
│       └── layout_toggle.sh
└── sketchybar/         # SketchyBar status bar
    ├── bar.lua
    ├── config/
    │   ├── app_icons.lua
    │   ├── colors.lua
    │   ├── icons.lua
    │   ├── laptop_config.lua
    │   ├── paths.lua
    │   └── settings.lua
    ├── default.lua
    ├── init.lua
    ├── items/
    │   ├── aerospace_modes.lua
    │   ├── apple.lua
    │   ├── battery.lua
    │   ├── calendar.lua
    │   ├── front_app.lua
    │   ├── init.lua
    │   ├── keyboard.lua
    │   ├── netstat.lua
    │   ├── uname.lua
    │   └── volume.lua
    ├── plugins/
    │   ├── keyboard.sh
    │   └── netstat.sh
    └── themes/
        └── arrows.lua
```

### 🚀 Getting Started

1. **Install Dependencies**: Install required packages using Homebrew
   ```bash
   brew install --cask nikitabobko/tap/aerospace
   brew install lua
   brew tap FelixKratz/formulae
   brew install sketchybar borders
   ```

2. **Install Configurations**: Symlink the macOS configurations
   ```bash
   cd ~/.dotfiles/macOS
   stow .
   ```

3. **Selective Installation**: Install only specific components
   ```bash
   cd ~/.dotfiles/macOS
   stow aerospace sketchybar
   ```

### 🔧 Key Features

- **AeroSpace Window Management**: Keyboard-driven tiling window management
- **SketchyBar Status Monitoring**: System resource monitoring and indicators
- **macOS Integration**: Seamless integration with macOS native features
- **Multiple Layouts**: Support for different keyboard layouts and configurations
- **Workspace Management**: Efficient workspace organization and navigation

### 📖 Related Documentation

- **[Common Configuration](../common/README.md)**: Cross-platform tools and utilities
- **[Arch Linux Configuration](../archlinux/README.md)**: Arch Linux-specific setup
- **[Agents Documentation](../common/agents.md)**: AI agent configurations

### 🎯 Usage Patterns

- **Window Management**: Keyboard-driven window organization and navigation
- **System Monitoring**: Real-time resource usage tracking
- **Application Management**: Efficient application launching and switching
- **Workspace Organization**: Multiple workspace layouts and management

### 🐛 Troubleshooting

If you encounter issues:

1. **Check AeroSpace Logs**: Review AeroSpace logs for errors
2. **Verify Dependencies**: Ensure all required packages are installed
3. **Review Configuration**: Check for syntax errors in config files
4. **Consult Documentation**: Refer to official documentation for each component
5. **Test Incrementally**: Add configurations gradually to identify conflicts

### 📝 Notes

- The macOS configuration assumes a standard macOS environment
- Some configurations may require additional permissions or settings
- The setup is optimized for development workflows and productivity
- AeroSpace requires macOS 12.0 (Monterey) or later

### 🔗 Quick Links

- [AeroSpace Documentation](https://github.com/nikitabobko/AeroSpace)
- [SketchyBar Documentation](https://felixkratz.github.io/SketchyBar/)
- [macOS Developer Documentation](https://developer.apple.com/documentation)
- [Homebrew Documentation](https://brew.sh/)