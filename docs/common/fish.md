## Fish Shell Configuration

Fish is a user-friendly command line shell that provides features like autosuggestions, syntax highlighting, and easy configuration. It serves as the primary shell across both Arch Linux and macOS systems.

### Key Files

- **config.fish**: Main configuration file with universal settings
- **conf.d/**: Configuration snippets organized by functionality
  - `alias_apps.fish`: Application-specific aliases (yazi, neovim, etc.)
  - `alias_git.fish`: Comprehensive Git aliases for workflow optimization
  - `agents.fish`: Aliases for LLM agent interactions
  - `conda.fish`: Conda environment management
  - `env.fish`: Cross-platform environment variables
  - `fish_frozen_key_bindings.fish`: Custom key bindings
  - `fish_frozen_theme.fish`: Theme configuration
  - `nvm.fish`: Node Version Manager integration
  - `rustup.fish`: Rust toolchain management
  - `tmux.fish`: Tmux integration and aliases
  - `uv.env.fish`: Python virtual environment management
- **functions/**: Custom shell functions
  - Git helper functions for branch management
  - NVM version management functions
- **completions/**: Custom command completions
  - Fisher package manager completions
  - NVM completions

### Key Features

- **Cross-Platform Support**: Automatically detects OS and applies appropriate configurations
- **Performance Optimization**: Lazy loading of aliases and functions for faster startup
- **Productivity Focus**: Extensive aliases for common development tasks
- **Version Management**: Integrated support for NVM, Rustup, Conda, and UV
- **Agent Integration**: Specialized aliases for Mistral Vibe and other LLM agents
- **Tmux Integration**: Seamless workflow between Fish and Tmux

### Aliases

**Application Aliases:**
- `y`: Launch Yazi file manager
- `yh`: Launch Yazi in current directory
- `vi`: Launch Neovim
- `s`: Launch with sudo
- `st`: Launch with sudo and terminal
- `,.`: Open current directory in GUI file manager
- `,,.`: Open parent directory in GUI file manager
- `,config`: Open dotfiles configuration
- `,,config`: Open dotfiles configuration in parent directory
- `econfig`: Edit configuration files
- `edotfiles`: Edit dotfiles

**Git Aliases:**
- `gss`: Git status short
- `ga`: Git add
- `gaa`: Git add all
- `gc`: Git commit
- `gcsmg`: Git commit with message
- `gca`: Git commit amend
- `gc!`: Git commit with no verify
- `gcn!`: Git commit with no verify and no edit
- `gcan!`: Git commit amend with no verify
- `gb`: Git branch
- `gbd`: Git branch delete
- `gcl`: Git clone
- `gco`: Git checkout
- `gcb`: Git checkout branch
- `ggl`: Git pull
- `ggp`: Git push
- `ggf`: Git push force
- `gd`: Git diff
- `gds`: Git diff staged
- `gr`: Git reset
- `gf`: Git fetch
- `gfc`: Git fetch and clean
- `gfm`: Git fetch master
- `glg`: Git log graph
- `grb`: Git rebase
- `grbm`: Git rebase master
- `grbi`: Git rebase interactive

**QMK Aliases:**
- `sweep-full`: Full QMK firmware sweep
- `sweep-simple`: Simple QMK firmware sweep

### Functions

**Git Functions:**
- `__git.current_branch`: Get current Git branch name
- `__git.default_branch`: Get default Git branch name
- `__git.is_repo`: Check if current directory is a Git repository

**NVM Functions:**
- `_nvm_index_update`: Update NVM index
- `_nvm_list`: List available Node.js versions
- `_nvm_version_activate`: Activate specific Node.js version
- `_nvm_version_deactivate`: Deactivate current Node.js version

### Configuration Details

The Fish configuration is designed to work seamlessly across both Arch Linux and macOS:

- **OS Detection**: Automatically detects the operating system and loads appropriate settings
- **Theme**: Uses a consistent color scheme that works well with both light and dark terminal themes
- **Performance**: Optimized for fast startup with lazy loading of non-essential components
- **Integration**: Deep integration with other tools in the ecosystem (Tmux, Neovim, agents)


