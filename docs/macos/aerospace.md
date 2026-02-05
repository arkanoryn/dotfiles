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

## Integration with Other Components

AeroSpace works seamlessly with other components in this setup:

- **SketchyBar**: AeroSpace integrates with SketchyBar to display workspace information and window management controls. See [SketchyBar documentation](sketchybar.md) for details.
- **Common Tools**: AeroSpace works with common tools like Fish shell and Tmux. See the [Common Configuration documentation](../common/README.md) for more information.

## Troubleshooting

If you encounter issues with AeroSpace:

1. **Check Logs**: Review AeroSpace logs for errors
2. **Verify Dependencies**: Ensure all required packages are installed
3. **Review Configuration**: Check for syntax errors in configuration files
4. **Consult Documentation**: Refer to the official AeroSpace documentation


