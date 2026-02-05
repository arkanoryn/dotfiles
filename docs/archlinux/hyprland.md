# Hyprland Configuration

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

## Key Features

- **Dual Keyboard Layout Support**: Configurations for both QWERTY and Graphite keyboard layouts
- **Modular Configuration**: Easy to maintain and update individual aspects of the setup
- **Custom Keybindings**: Optimized for productivity with a focus on window management
- **Autostart Applications**: Automatically starts essential applications like Waybar, SwayNC, and Hyprpaper

## Keybindings

The keybindings are designed to be efficient and intuitive. The main modifier is the `SUPER` key (Windows key), and the `meh` key (ALT&CONTROL&SHIFT) is used for more complex actions.

### General Shortcuts

- `SUPER + Q`: Kill active window
- `SUPER + SHIFT + Q`: Kill all windows of the current application
- `SUPER + meh + Q`: Logout
- `SUPER + L`: Lock screen

### Application Launchers

- `meh + T`: Open terminal
- `meh + G`: Open browser
- `meh + V`: Open file manager
- `meh + W`: Open application launcher

### Window Management

- `meh + H/J/K/L`: Move focus (left/down/up/right)
- `meh + U`: Toggle floating mode
- `meh + I/P`: Resize active window

### Workspace Management

- `meh + U/I/O/P`: Switch to workspace 1/2/3/4
- `meh + M`: Enter workspace mode
- `meh + comma`: Enter layout mode
- `meh + N`: Enter selection mode

## Apps Directory

The `apps/` directory contains configuration files for specific applications that integrate with Hyprland. This includes application-specific rules, window management preferences, and custom launch configurations.

## Integration with Other Components

Hyprland works seamlessly with other components in this setup:

- **Waybar**: Status bar that displays system information and workspace indicators. See [Waybar documentation](waybar.md) for details.
- **SwayNC**: Notification center that integrates with Hyprland. See [SwayNC documentation](swayNC.md) for configuration details.
- **Common Tools**: Hyprland integrates with common tools like Fish shell, Tmux, and WezTerm. See the [Common Configuration documentation](../common/README.md) for more information.

## Troubleshooting

If you encounter issues with Hyprland:

1. **Check Logs**: Hyprland provides detailed logs for debugging
2. **Verify Dependencies**: Ensure all required packages are installed
3. **Review Configuration**: Check for syntax errors in configuration files
4. **Consult Official Documentation**: Refer to the [Hyprland Wiki](https://wiki.hyprland.org/)

