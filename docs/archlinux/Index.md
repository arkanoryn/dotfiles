# Arch Linux Documentation Index

Welcome to the Arch Linux documentation for this dotfiles repository. This index provides an overview of the Arch Linux-specific configurations and guides you to the appropriate documentation.

## 📚 Table of Contents

### 🎯 Core Components

- **[Hyprland](hyprland.md)**: Dynamic tiling Wayland compositor
  - Window management and keybindings
  - Multi-monitor support
  - Application-specific rules
  - Dual keyboard layout support (QWERTY/Graphite)

- **[Waybar](waybar.md)**: Customizable Wayland status bar
  - System monitoring widgets
  - Workspace and window management
  - Modular architecture
  - Custom styling and themes

- **[SwayNC](swayNC.md)**: Notification center for Wayland
  - Notification management
  - Custom styling
  - Integration with Wayland components

### 📁 Directory Structure

```
archlinux/
├── hypr/               # Hyprland window manager
├── waybar/             # Waybar status bar
├── swaync/             # SwayNC notification center
├── scripts/            # Utility scripts
└── setup_scripts/      # Automated setup scripts
```

### 🚀 Getting Started

1. **Install Dependencies**: Run the setup script to install required packages
   ```bash
   ./archlinux/setup.sh
   ```

2. **Install Configurations**: Symlink the Arch Linux configurations
   ```bash
   cd ~/.dotfiles/archlinux
   stow .
   ```

3. **Selective Installation**: Install only specific components
   ```bash
   cd ~/.dotfiles/archlinux
   stow hypr waybar
   ```

### 🔧 Key Features

- **Hyprland Window Management**: Dynamic tiling with floating windows
- **Waybar Status Monitoring**: System resource monitoring and indicators
- **SwayNC Notifications**: Customizable notification management
- **Setup Scripts**: Automated installation and configuration
- **Multi-Monitor Support**: Comprehensive display management

### 📖 Related Documentation

- **[Common Configuration](../common/README.md)**: Cross-platform tools and utilities
- **[macOS Configuration](../macos/README.md)**: macOS-specific setup and tools
- **[Agents Documentation](../common/agents.md)**: AI agent configurations

### 🎯 Usage Patterns

- **Development Workflow**: Optimized for coding and development tasks
- **Window Management**: Keyboard-driven window organization
- **System Monitoring**: Real-time resource usage tracking
- **Notification Management**: Centralized notification handling

### 🐛 Troubleshooting

If you encounter issues:

1. **Check Hyprland Logs**: `journalctl -u hyprland -f`
2. **Verify Wayland Session**: Ensure you're running a Wayland session
3. **Review Configuration**: Check for syntax errors in config files
4. **Consult Documentation**: Refer to official documentation for each component

### 📝 Notes

- The Arch Linux configuration assumes a Wayland-based environment
- Some configurations may require additional packages or dependencies
- The setup is optimized for development workflows and productivity

### 🔗 Quick Links

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Documentation](https://github.com/Alexays/Waybar)
- [SwayNC GitHub](https://github.com/ErikReider/SwayNotificationCenter)
- [Arch Linux Wiki](https://wiki.archlinux.org/)