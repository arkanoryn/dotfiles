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

## Integration with Other Components

SketchyBar works seamlessly with other components in this setup:

- **AeroSpace**: SketchyBar integrates with AeroSpace to display workspace information and window management controls. See [AeroSpace documentation](aerospace.md) for details.
- **Common Tools**: SketchyBar works with common tools like Fish shell and Tmux. See the [Common Configuration documentation](../common/README.md) for more information.

## Troubleshooting

If you encounter issues with SketchyBar:

1. **Check Logs**: Review SketchyBar logs for errors
2. **Verify Dependencies**: Ensure all required packages are installed
3. **Review Configuration**: Check for syntax errors in configuration files
4. **Consult Documentation**: Refer to the official SketchyBar documentation


