## LazyVim Configuration

LazyVim is a Neovim configuration that provides a modular and extensible setup for Neovim. It offers a consistent editing experience across both Arch Linux and macOS systems.

### Key Files

- **init.lua**: Main initialization file with bootstrap logic
- **lua/config/**: Core configuration files
  - `autocmds.lua`: Auto commands for various events
  - `keymaps.lua`: Comprehensive key mappings
  - `lazy.lua`: Lazy.nvim plugin manager configuration
  - `options.lua`: Neovim options and settings
- **lua/plugins/**: Plugin configurations
  - `catppuccin.lua`: Catppuccin Mocha theme configuration
  - `lint.lua`: Linting and code quality plugins
  - `treesitter.lua`: Treesitter syntax highlighting
  - `example.lua`: Example plugin configuration template

### Key Features

- **Modular Architecture**: Easy to maintain and update individual components
- **Performance Optimized**: Plugins loaded on demand for fast startup
- **Extensible Plugin System**: Support for additional plugins and customizations
- **Consistent Theming**: Catppuccin Mocha theme throughout
- **Cross-Platform**: Works identically on Arch Linux and macOS
- **Modern Neovim Features**: Leverages latest Neovim capabilities

### Configuration Details

**Bootstrap Process:**
- Automatically installs lazy.nvim plugin manager
- Sets up LazyVim framework with sensible defaults
- Configures plugin installation and updates

**Core Configuration:**
- **Options**: Comprehensive Neovim options for optimal editing experience
- **Key Mappings**: Productivity-focused key mappings for common tasks
- **Auto Commands**: Context-aware commands for different file types and events

**Plugin Management:**
- **Lazy Loading**: Plugins loaded only when needed for performance
- **Dependency Management**: Automatic handling of plugin dependencies
- **Update System**: Easy plugin updates and version management

**Theming:**
- **Catppuccin Mocha**: Primary color scheme with custom adjustments
- **Syntax Highlighting**: Enhanced syntax highlighting with Treesitter
- **UI Consistency**: Consistent appearance across all plugins

**Performance Optimizations:**
- **Startup Time**: Minimized startup time through lazy loading
- **Memory Usage**: Efficient memory management for large sessions
- **Responsive UI**: Fast and responsive user interface

### Integration

LazyVim integrates seamlessly with:
- **Tmux**: Vim-Tmux Navigator for seamless navigation
- **Fish Shell**: Consistent workflow and keybindings
- **Starship**: Compatible theming and appearance
- **WezTerm**: Consistent color scheme and font rendering
- **Agents**: Supports LLM agent workflows for code assistance

### Key Mappings

**Basic Navigation:**
- Standard Vim navigation keys with enhancements
- Buffer navigation and management
- Window splitting and management

**Plugin-Specific:**
- LSP integration keybindings
- Telescope fuzzy finder mappings
- Git integration commands
- Debugging shortcuts

**Custom Workflows:**
- Project-specific keybindings
- Task automation shortcuts
- Custom command sequences


