## Tmux Configuration

Tmux is a terminal multiplexer that allows you to manage multiple terminal sessions in a single window. It provides consistent session management across both Arch Linux (Wayland) and macOS environments.

### Key Files

- **tmux.conf**: Main configuration file with comprehensive settings
- **plugins/**: Tmux plugins for enhanced functionality
  - `catppuccin/`: Catppuccin Mocha theme with extensive customization
  - `tmux-sensible/`: Sensible defaults and best practices
  - `vim-tmux-navigator/`: Seamless navigation between Vim and Tmux
  - `tpm/`: Tmux Plugin Manager for easy plugin management

### Key Features

- **Custom Keybindings**: Uses `M-k` (Alt-k) as the prefix key for ergonomic access
- **Catppuccin Mocha Theme**: Beautiful and consistent theming across all Tmux elements
- **Plugin System**: Extensible functionality through plugins
- **Advanced Status Bar**: Highly customized status bar with system information
- **Cross-Platform**: Works consistently on both Arch Linux and macOS
- **Session Management**: Optimized workflow for managing multiple projects

### Configuration Details

**Core Configuration:**
- **Prefix Key**: `M-k` (Alt-k) - chosen for ergonomic access
- **Base Index**: Windows and panes start at 1 instead of 0 for intuitive numbering
- **Mouse Support**: Full mouse integration for easy window and pane management
- **History**: Extended scrollback history for better session recovery

**Theme Configuration:**
- **Catppuccin Mocha**: Primary color scheme with custom accents
- **Status Bar**: Multi-section status bar with:
  - Application status
  - Session information
  - System uptime
  - Date and time
  - Battery status
  - Custom user information

**Window Management:**
- Intuitive window creation and navigation
- Custom window naming conventions
- Visual indicators for active windows

**Pane Management:**
- Easy pane splitting and resizing
- Visual pane borders with custom colors
- Smart pane focusing

**Plugin Integration:**
- **Catppuccin**: Comprehensive theming for all Tmux elements
- **Vim-Tmux Navigator**: Seamless navigation between Vim and Tmux panes
- **Tmux Sensible**: Best practice defaults and sensible behaviors
- **TPM**: Easy plugin management and updates

### Keybindings

**Session Management:**
- `M-k c`: Create new window
- `M-k n`: Next window
- `M-k p`: Previous window
- `M-k [0-9]`: Switch to window number

**Pane Management:**
- `M-k %`: Vertical split
- `M-k "`: Horizontal split
- `M-k h/j/k/l`: Navigate panes
- `M-k H/J/K/L`: Resize panes

**Advanced Features:**
- `M-k d`: Detach session
- `M-k $`: Rename session
- `M-k s`: Show sessions
- `M-k :`: Command prompt

### Integration

Tmux integrates seamlessly with:
- **Fish Shell**: Primary shell with optimized keybindings
- **Neovim**: Vim-Tmux Navigator for seamless navigation
- **WezTerm**: Consistent theming and keybindings
- **Agents**: Works well with LLM agent workflows


