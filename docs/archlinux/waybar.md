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


