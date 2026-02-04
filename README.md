# Dotfiles Repository

This repository contains my personal dotfiles configuration for both macOS and Arch Linux systems. The configurations are designed to provide a consistent, productive development environment across both operating systems while leveraging platform-specific tools where appropriate.

## 📚 Table of Contents

- [Dotfiles Repository](#dotfiles-repository)
  - [📚 Table of Contents](#-table-of-contents)
  - [🌟 Features](#-features)
  - [📁 Repository Structure](#-repository-structure)
  - [📦 Platform-Specific Configurations](#-platform-specific-configurations)
    - [macOS Configuration](#macos-configuration)
    - [Arch Linux Configuration](#arch-linux-configuration)
  - [🔧 Common Configurations](#-common-configurations)
  - [🚀 Getting Started](#-getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Selective Installation](#selective-installation)
  - [📖 Documentation](#-documentation)
  - [🎯 Key Features by Platform](#-key-features-by-platform)
  - [🔧 Customization](#-customization)
  - [🐛 Troubleshooting](#-troubleshooting)
  - [🤝 Contributing](#-contributing)
  - [📝 License](#-license)

## 🌟 Features

- **Cross-platform consistency**: Same core tools and workflows on both macOS and Arch Linux
- **Modular design**: Install only what you need, or everything at once
- **Comprehensive documentation**: Detailed guides for each component
- **Productivity-focused**: Optimized for developer workflows
- **AI-assisted development**: Integrated Mistral Vibe agents for coding assistance
- **Consistent theming**: Catppuccin Mocha theme throughout

## 📁 Repository Structure

```
dotfiles/
├── .tasks/                  # Task management and project tracking
├── archlinux/              # Arch Linux specific configurations
│   ├── hypr/               # Hyprland window manager
│   ├── waybar/             # Waybar status bar
│   ├── swaync/             # Sway notification center
│   ├── scripts/            # Utility scripts
│   └── setup_scripts/      # Automated setup scripts
├── common/                 # Cross-platform configurations
│   ├── agents/             # AI agent configurations
│   ├── fish/               # Fish shell setup
│   ├── git/                # Git configuration
│   ├── lazyvim/            # Neovim configuration
│   ├── starship/           # Shell prompt
│   ├── tmux/               # Terminal multiplexer
│   ├── wezterm/            # Terminal emulator
│   └── snippets/           # Code snippets
├── macOS/                  # macOS specific configurations
│   ├── aerospace/          # AeroSpace window manager
│   └── sketchybar/         # SketchyBar status bar
├── docs/                   # Comprehensive documentation
│   ├── archlinux/          # Arch Linux docs
│   ├── common/             # Common docs
│   ├── macos/              # macOS docs
│   └── notes/              # Technical notes and guides
└── README.md               # This file
```

## 📦 Platform-Specific Configurations

### macOS Configuration

The macOS configuration includes:

- **AeroSpace**: A powerful tiling window manager for macOS
  - Multiple layout configurations (Graphite, Laptop, QWERTY)
  - Custom scripts for layout management
  - Keyboard-driven window management

- **SketchyBar**: A highly customizable status bar
  - Modular design with configurable items
  - System monitoring (battery, network, volume, etc.)
  - Application integration and workspace management

- **Integration**: Seamless integration with macOS native features

### Arch Linux Configuration

The Arch Linux configuration includes:

- **Hyprland**: A dynamic tiling Wayland compositor
  - Custom keybindings and workspace management
  - Window rules and application configurations
  - Multi-monitor support

- **Waybar**: A customizable Wayland bar
  - Modular architecture with configurable modules
  - System monitoring and status indicators
  - Workspace and window management

- **SwayNC**: Notification center for Wayland
  - Custom styling and notification management
  - Integration with other Wayland components

- **Setup Scripts**: Automated installation and configuration
  - `arch_default.sh`: Essential packages and tools
  - `hyprland.sh`: Hyprland and related packages
  - `apps.sh`: Applications and development tools
  - `llm_agents.sh`: AI agent setup

## 🔧 Common Configurations

The common configurations provide a consistent experience across both platforms:

### 🐟 Fish Shell
- Extensive aliases and functions
- Custom keybindings and theme
- Plugin management with Fisher
- Environment configuration

### ⭐ Starship
- Consistent prompt across all shells
- Git integration and status indicators
- Cross-platform compatibility

### 🐍 Tmux
- Catppuccin Mocha theme
- Vim-style keybindings
- Session and window management
- Plugin integration (TPM, vim-tmux-navigator)

### 🦀 WezTerm
- GPU-accelerated terminal emulator
- Cross-platform configuration
- Custom keybindings and appearance
- Font and theme management

### 💻 LazyVim
- Neovim configuration with Lazy.nvim
- Comprehensive plugin setup
- Language server integration
- Code formatting and linting

### 🤖 AI Agents
- Mistral Vibe agent configurations
- Code review, writing, and development assistance
- Custom prompts and skills
- Shared resources and configurations

### 📝 Code Snippets
- Reusable code templates
- Multi-language support
- Productivity enhancements

## 🚀 Getting Started

### Prerequisites

#### macOS

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required packages
brew install stow wezterm fish starship eza zoxide bat fzf
brew install --cask wezterm
brew install lua
brew tap FelixKratz/formulae
brew install sketchybar borders
brew install --cask nikitabobko/tap/aerospace
brew install ripgrep fd neovim
```

#### Arch Linux

```bash
# Install required packages
sudo pacman -S stow wezterm fish starship eza zoxide bat fzf
sudo pacman -S lua sketchybar borders
sudo pacman -S ripgrep fd neovim

# For additional packages, run the setup script
./archlinux/setup.sh
```

### Installation

To install all configurations for your platform:

```bash
# For macOS
cd ~/.dotfiles/macOS && stow .

# For Arch Linux
cd ~/.dotfiles/archlinux && stow .

# For common configurations (run from both platforms)
cd ~/.dotfiles/common && stow .
```

### Selective Installation

To install only specific components:

```bash
# Example: Install only Fish and Starship
cd ~/.dotfiles/common && stow fish starship

# Example: Install only AeroSpace on macOS
cd ~/.dotfiles/macOS && stow aerospace

# Example: Install only Hyprland on Arch Linux
cd ~/.dotfiles/archlinux && stow hypr
```

## 📖 Documentation

Comprehensive documentation is available in the `docs/` directory:

- **Platform-specific guides**: Detailed setup and configuration instructions
- **Component documentation**: In-depth explanations of each tool's configuration
- **Technical notes**: Implementation details and design decisions
- **Troubleshooting guides**: Common issues and solutions

The documentation is organized as an Obsidian vault, allowing for:
- Atomic notes with cross-referencing
- Graph view for visualizing relationships
- Backlinks for easy navigation
- Markdown-based content

## 🎯 Key Features by Platform

### macOS Features

- **AeroSpace Window Management**:
  - Keyboard-driven window tiling
  - Multiple workspace layouts
  - Application launching and switching
  - Mouse pointer centering

- **SketchyBar Status Bar**:
  - System monitoring widgets
  - Application indicators
  - Customizable appearance
  - Workspace management

### Arch Linux Features

- **Hyprland Window Management**:
  - Dynamic tiling and floating windows
  - Custom keybindings and rules
  - Multi-monitor support
  - Wayland compatibility

- **Waybar Status Bar**:
  - Modular widget system
  - System resource monitoring
  - Network and battery indicators
  - Custom styling and themes

### Common Features

- **Fish Shell Enhancements**:
  - Extensive alias system
  - Custom functions and completions
  - Environment management
  - Plugin integration

- **Tmux Productivity**:
  - Consistent keybindings
  - Session persistence
  - Window and pane management
  - Visual theming

- **LazyVim Development**:
  - Plugin management
  - Language server support
  - Code navigation and editing
  - Project management

## 🔧 Customization

All configurations are designed to be easily customizable:

1. **Modify individual files**: Each configuration file is well-commented
2. **Add new components**: Extend with additional tools and modules
3. **Adjust theming**: Change color schemes and appearance
4. **Change keybindings**: Edit keybinding files to match your preferences
5. **Add new agents**: Extend AI assistance capabilities

## 🐛 Troubleshooting

If you encounter issues:

1. **Check logs**: Most applications provide detailed logs
2. **Verify dependencies**: Ensure all required packages are installed
3. **Review configuration**: Check for syntax errors or incorrect settings
4. **Consult documentation**: Refer to official documentation for each tool
5. **Test incrementally**: Add configurations gradually to identify conflicts

## 📝 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🎯 Philosophy

This dotfiles repository is designed with the following principles:

- **Productivity**: Minimize mouse usage and maximize keyboard efficiency
- **Consistency**: Provide the same experience across different platforms
- **Modularity**: Allow selective installation of components
- **Documentation**: Comprehensive guides for setup and usage
- **Extensibility**: Easy to customize and extend for individual needs

The goal is to create a development environment that works seamlessly whether you're on macOS or Arch Linux, with platform-specific optimizations where they provide the most benefit.
