# Common Configuration Documentation

This directory contains documentation for the common configurations in this dotfiles repository that are shared between both Arch Linux and macOS systems. These configurations provide a consistent experience across both operating systems.

## Overview

The `common/` directory contains configurations for:
- **Fish Shell**: A user-friendly command line shell with cross-platform support
- **Starship**: A minimal, blazing-fast, and infinitely customizable prompt
- **Tmux**: A terminal multiplexer with Catppuccin Mocha theme
- **WezTerm**: A GPU-accelerated cross-platform terminal emulator
- **LazyVim**: A Neovim configuration with Lazy.nvim plugin manager
- **Agents**: LLM agent configurations for Mistral Vibe
- **Zsh**: Zsh shell configuration with Powerlevel10k theme
- **Git**: Git configuration and ignore patterns
- **Ghostty**: Terminal emulator configuration
- **Snippets**: Code snippets for various languages

## Structure

```
common/
├── agents/
│   ├── shared/
│   │   ├── prompts/
│   │   │   ├── code-reviewer_prompt.md
│   │   │   ├── ely.md
│   │   │   ├── nyx.md
│   │   │   └── zeph.md
│   │   └── skills/
│   │       ├── brainstorming/
│   │       ├── commit-work/
│   │       ├── finishing-a-development-branch/
│   │       ├── receiving-code-review/
│   │       ├── requesting-code-review/
│   │       ├── test-driven-development/
│   │       ├── writing-clearly-and-concisely/
│   │       └── writing-skills/
│   └── vibe/
│       ├── agents/
│       │   ├── code_reviewer.toml
│       │   ├── elyndra.toml
│       │   ├── nyxara.toml
│       │   └── zephyra.toml
│       └── config.toml
├── fish/
│   ├── completions/
│   │   ├── fisher.fish
│   │   └── nvm.fish
│   ├── conf.d/
│   │   ├── alias_apps.fish
│   │   ├── alias_git.fish
│   │   ├── agents.fish
│   │   ├── conda.fish
│   │   ├── env.fish
│   │   ├── fish_frozen_key_bindings.fish
│   │   ├── fish_frozen_theme.fish
│   │   ├── nvm.fish
│   │   ├── rustup.fish
│   │   ├── tmux.extra.conf
│   │   ├── tmux.fish
│   │   ├── tmux.only.conf
│   │   └── uv.env.fish
│   ├── functions/
│   │   ├── __git.current_branch.fish
│   │   ├── __git.default_branch.fish
│   │   ├── __git.is_repo.fish
│   │   ├── _nvm_index_update.fish
│   │   ├── _nvm_list.fish
│   │   ├── _nvm_version_activate.fish
│   │   └── _nvm_version_deactivate.fish
│   ├── config.fish
│   └── fish_plugins
├── git/
│   └── gitignore
├── ghostty/
│   ├── config
│   └── startup.sh
├── lazyvim/
│   ├── lua/
│   │   ├── config/
│   │   │   ├── autocmds.lua
│   │   │   ├── keymaps.lua
│   │   │   ├── lazy.lua
│   │   │   └── options.lua
│   │   └── plugins/
│   │       ├── catppuccin.lua
│   │       ├── lint.lua
│   │       └── treesitter.lua
│   ├── .gitignore
│   ├── .markdownlintrc
│   ├── .neoconf.json
│   ├── init.lua
│   ├── lazy-lock.json
│   ├── lazyvim.json
│   ├── LICENSE
│   ├── README.md
│   └── stylua.toml
├── snippets/
│   ├── c.snippets
│   └── package.json
├── starship/
│   └── starship.toml
├── tmux/
│   ├── plugins/
│   │   ├── catppuccin/
│   │   ├── tmux-sensible/
│   │   ├── tpm/
│   │   └── vim-tmux-navigator/
│   └── tmux.conf
├── wezterm/
│   ├── keys.lua
│   └── wezterm.lua
├── zsh/
│   ├── p10k.zsh
│   ├── zprofile
│   ├── zshenv
│   └── zshrc
└── .stowrc
```

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

## Starship Configuration

Starship is a minimal, blazing-fast, and infinitely customizable prompt for any shell. It provides a consistent prompt experience across both Fish and Zsh shells on Arch Linux and macOS.

### Key Files

- **starship.toml**: Main configuration file with comprehensive prompt settings

### Key Features

- **Cross-Shell Compatibility**: Works seamlessly with both Fish and Zsh
- **Custom Format**: Highly customized prompt format with left and right sections
- **Catppuccin Mocha Theme**: Uses the Catppuccin Mocha color palette for consistent theming
- **Modular Design**: Configures various modules (git, nodejs, python, etc.) independently
- **Performance Optimized**: Minimal overhead with fast rendering
- **Context-Aware**: Shows relevant information based on current directory and context

### Configuration Details

The Starship configuration is designed for maximum productivity:

**Prompt Structure:**
- **Left Side**: Shows current directory, Git status, and relevant tool versions
- **Right Side**: Shows time, battery status, and other system information

**Color Scheme:**
- Uses Catppuccin Mocha palette for consistent theming across all tools
- Carefully chosen colors for maximum readability

**Modules Configured:**
- **Git**: Shows branch name, status, and metrics
- **Node.js**: Shows current Node.js version
- **Python**: Shows current Python version
- **Rust**: Shows current Rust version
- **Package**: Shows current package version
- **Directory**: Shows current directory with truncation
- **Time**: Shows current time
- **Battery**: Shows battery status (on laptops)
- **Character**: Custom prompt character

**Performance Optimizations:**
- Disabled slow modules that aren't essential
- Configured timeouts for responsive behavior
- Minimal prompt rendering for fast shell performance

### Integration

Starship integrates seamlessly with:
- **Fish Shell**: Primary shell on both platforms
- **Zsh**: Alternative shell configuration
- **Tmux**: Works well within Tmux sessions
- **Neovim**: Consistent color scheme with editor

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

## WezTerm Configuration

WezTerm is a GPU-accelerated cross-platform terminal emulator and multiplexer that provides a consistent terminal experience across Arch Linux and macOS.

### Key Files

- **wezterm.lua**: Main configuration file with comprehensive settings
- **keys.lua**: Custom keybindings configuration

### Key Features

- **GPU Acceleration**: Hardware-accelerated rendering for smooth performance
- **Cross-Platform**: Consistent experience on both Arch Linux and macOS
- **Workspaces**: Multiple workspaces for organizing different projects
- **Advanced Keybindings**: Custom keybindings optimized for productivity
- **Theming**: Catppuccin Mocha color scheme with custom enhancements
- **Multiplexing**: Built-in terminal multiplexing capabilities
- **Font Rendering**: High-quality font rendering with ligature support

### Configuration Details

**Core Configuration:**
- **Default Shell**: Fish shell as the primary shell
- **Font**: Custom font configuration with ligatures and proper spacing
- **Color Scheme**: Catppuccin Mocha with custom adjustments
- **Window Management**: Custom window behavior and positioning

**Appearance:**
- **Color Scheme**: Catppuccin Mocha palette with custom accents
- **Font**: Primary font with fallback fonts for comprehensive coverage
- **Window Settings**: Custom window padding, decorations, and transparency
- **Tab Bar**: Customized tab bar appearance and behavior

**Keybindings:**
- **Window Management**: Keybindings for creating, closing, and navigating windows
- **Workspace Management**: Keybindings for switching between workspaces
- **Pane Management**: Keybindings for splitting and navigating panes
- **Custom Actions**: Special keybindings for common tasks

**Workspaces:**
- **dotfiles**: Dedicated workspace for dotfiles management
- **programming**: Workspace for programming projects
- **move**: Workspace for file management and organization

### Integration

WezTerm integrates seamlessly with:
- **Fish Shell**: Primary shell with consistent theming
- **Tmux**: Works alongside Tmux for advanced session management
- **Neovim**: Consistent color scheme and font rendering
- **Starship**: Compatible prompt rendering
- **Agents**: Supports LLM agent workflows

### Performance Optimizations

- **GPU Acceleration**: Leverages hardware acceleration for smooth rendering
- **Font Caching**: Optimized font caching for fast startup
- **Memory Management**: Efficient memory usage for long-running sessions
- **Input Handling**: Responsive input handling for productive workflows

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

## Zsh Configuration

Zsh is included as an alternative shell configuration, providing a Powerlevel10k-themed experience that works consistently across both Arch Linux and macOS systems.

### Key Files

- **zsh/p10k.zsh**: Powerlevel10k theme configuration
- **zshrc**: Main Zsh configuration file
- **zprofile**: Profile configuration for login shells
- **zshenv**: Environment configuration

### Key Features

- **Powerlevel10k Theme**: Modern, informative prompt with Git integration
- **Cross-Platform**: Consistent behavior on Arch Linux and macOS
- **Performance Optimized**: Fast startup and responsive behavior
- **Plugin Support**: Ready for Zsh plugin integration
- **Compatibility**: Works alongside Fish shell configuration

### Configuration Details

**Powerlevel10k Configuration:**
- Custom prompt segments for Git, directory, and status information
- Performance-optimized prompt rendering
- Consistent theming with other tools

**Shell Configuration:**
- Sensible defaults for Zsh behavior
- History management and search
- Completion system configuration
- Key binding setup

### Integration

Zsh integrates with:
- **Starship**: Alternative prompt system
- **Tmux**: Works well within Tmux sessions
- **Neovim**: Consistent workflow
- **Agents**: Supports agent workflows

## Git Configuration

Git configuration provides consistent version control settings across both Arch Linux and macOS systems.

### Key Files

- **git/gitignore**: Global Git ignore patterns

### Key Features

- **Cross-Platform Ignore Patterns**: Consistent ignore rules for both systems
- **Development-Focused**: Ignore patterns for common development tools and environments
- **Performance Optimized**: Efficient ignore pattern matching

### Configuration Details

**Ignore Patterns:**
- Common development artifacts (.DS_Store, logs, etc.)
- IDE-specific files and directories
- Build artifacts and cache directories
- Environment-specific files

### Integration

Git configuration works seamlessly with:
- **Fish Shell**: Git aliases and workflows
- **LazyVim**: Git integration within Neovim
- **Agents**: Git-related agent assistance
- **Tmux**: Git workflows in terminal sessions

## Ghostty Configuration

Ghostty is a modern terminal emulator configuration that provides an alternative to WezTerm with similar capabilities across both Arch Linux and macOS.

### Key Files

- **ghostty/config**: Main Ghostty configuration
- **ghostty/startup.sh**: Startup script for Ghostty

### Key Features

- **Modern Terminal**: GPU-accelerated terminal emulator
- **Cross-Platform**: Works on both Arch Linux and macOS
- **Performance Optimized**: Fast rendering and responsive input
- **Customizable**: Extensive configuration options

### Configuration Details

**Core Configuration:**
- Font and appearance settings
- Color scheme configuration
- Window behavior and management
- Input handling and keybindings

**Startup Script:**
- Environment setup for Ghostty sessions
- Integration with other tools
- Performance optimizations

### Integration

Ghostty integrates with:
- **Fish Shell**: Primary shell integration
- **Tmux**: Terminal multiplexing support
- **Neovim**: Consistent editing experience
- **Starship**: Prompt rendering

## Snippets Configuration

Code snippets provide reusable code templates and patterns for various programming languages, available across both Arch Linux and macOS systems.

### Key Files

- **snippets/c.snippets**: C language code snippets
- **snippets/package.json**: Snippet configuration

### Key Features

- **Cross-Language Support**: Snippets for multiple programming languages
- **Productivity Focus**: Common patterns and templates
- **Extensible**: Easy to add new snippets
- **Consistent**: Same snippets available on both platforms

### Configuration Details

**Snippet Organization:**
- Language-specific snippet files
- Common patterns and idioms
- Best practice templates
- Project scaffolding snippets

**Integration:**
- Works with code editors and IDEs
- Supports development workflows
- Enhances coding productivity

## Agents Configuration

The agents configuration includes settings for LLM (Language Model) agents, primarily focused on Mistral Vibe. These agents provide AI-assisted workflows for coding, writing, reviewing, and other development tasks across both Arch Linux and macOS systems.

### Key Files

- **vibe/config.toml**: Main configuration file for Mistral Vibe with global settings
- **vibe/agents/**: Individual agent configurations
  - `zephyra.toml`: Zephyra agent - general-purpose coding assistant
  - `elyndra.toml`: Elyndra agent - writing and documentation specialist
  - `nyxara.toml`: Nyxara agent - code review and quality expert
  - `code_reviewer.toml`: Dedicated code reviewer agent
- **shared/prompts/**: Agent personality and behavior definitions
  - `code-reviewer_prompt.md`: Code reviewer personality and instructions
  - `ely.md`: Elyndra personality and writing guidelines
  - `nyx.md`: Nyxara personality and review standards
  - `zeph.md`: Zephyra personality and coding approach
- **shared/skills/**: Reusable skills for agent workflows
  - `brainstorming/`: Creative problem-solving and idea generation
  - `writing-clearly-and-concisely/`: Professional writing standards
  - `writing-skills/`: Advanced writing techniques
  - `test-driven-development/`: TDD methodology and practices
  - `receiving-code-review/`: Handling code review feedback
  - `requesting-code-review/`: Preparing code for review
  - `finishing-a-development-branch/`: Branch completion workflow
  - `commit-work/`: Professional commit practices

### Key Features

- **Specialized Agents**: Multiple agents optimized for different development tasks
- **Custom Personalities**: Unique prompts defining each agent's behavior and expertise
- **Modular Skills**: Reusable skills that can be applied across different agents
- **Workflow Integration**: Deep integration with development workflows
- **Cross-Platform**: Consistent behavior on both Arch Linux and macOS
- **Extensible Architecture**: Easy to add new agents and skills


### Agent Usage Examples

**Zephyra (Coding Assistant):**
\`\`\`bash
vibe --agent zephyra "Write a Python function to parse JSON with error handling"
\`\`\`

**Elyndra (Writing Specialist):**
\`\`\`bash
vibe --agent elyndra "Help me write a better commit message for these changes"
\`\`\`

**Nyxara (Code Review Expert):**
\`\`\`bash
vibe --agent nyxara "Please review this pull request for security issues"
\`\`\`


### Agent Details

**Zephyra:**
- **Role**: General-purpose coding assistant
- **Expertise**: Code generation, debugging, algorithm design
- **Personality**: Technical, precise, solution-oriented
- **Use Cases**: Implementation help, bug fixing, code optimization

**Elyndra:**
- **Role**: Writing and documentation specialist
- **Expertise**: Technical writing, documentation, prose refinement
- **Personality**: Articulate, structured, communication-focused
- **Use Cases**: Documentation, commit messages, professional communication

**Nyxara:**
- **Role**: Code review and quality expert
- **Expertise**: Code analysis, best practices, quality assurance
- **Personality**: Analytical, thorough, standards-driven
- **Use Cases**: Code reviews, quality checks, best practice enforcement

**Code Reviewer:**
- **Role**: Dedicated code review agent
- **Expertise**: Comprehensive code analysis and improvement suggestions
- **Personality**: Detailed, constructive, improvement-focused
- **Use Cases**: Formal code reviews, pull request analysis

### Skills Framework

The skills system provides reusable workflow patterns:

**Brainstorming:**
- Creative problem-solving techniques
- Idea generation and evaluation
- Multi-perspective analysis

**Writing Skills:**
- Clear and concise communication
- Technical documentation standards
- Professional writing techniques

**Development Workflows:**
- Test-driven development practices
- Code review best practices
- Branch management strategies
- Commit message standards

### Integration

Agents integrate deeply with the development environment:
- **Fish Shell**: Agent aliases and shortcuts for quick access
- **Neovim**: Code assistance and analysis within the editor
- **Tmux**: Agent workflows within terminal sessions
- **Git**: Integration with Git workflows and commit processes
- **Project Management**: Support for development lifecycle tasks

### Configuration Approach

The agent configuration follows a modular approach:
- **Global Settings**: Shared configuration in `config.toml`
- **Agent-Specific**: Individual agent personalities and behaviors
- **Reusable Skills**: Common workflow patterns applied across agents
- **Prompt Engineering**: Carefully crafted prompts for optimal agent performance

### Performance Considerations

- **Context Management**: Efficient handling of conversation context
- **Resource Usage**: Optimized for development workflows
- **Response Quality**: Tuned for technical accuracy and relevance
- **Workflow Integration**: Designed to enhance rather than disrupt development processes


### Quick Start Guide

1. **Install Mistral Vibe** and configure agents
2. **Basic Usage:**
   \`\`\`bash
   vibe "Help me implement a REST API in Python"
   vibe --agent nyxara "Help me draft a README for this project"
   \`\`\`


## Usage

### Getting Started

To use these common configurations:

1. **Symlink the common directory** to your `~/.config` directory:
   ```bash
   cd ~/.dotfiles/common
   stow .
   ```

2. **Selective Installation**: Symlink only specific components as needed:
   ```bash
   cd ~/.dotfiles/common
   stow fish starship tmux
   ```

### Configuration Management

- **Fish Shell**: Primary shell with extensive aliases and integrations
- **Starship**: Consistent prompt across all shells
- **Tmux**: Terminal multiplexing with consistent keybindings
- **WezTerm**: Primary terminal emulator
- **LazyVim**: Neovim configuration for coding

### Cross-Platform Considerations

These configurations are designed to work seamlessly across both Arch Linux and macOS:

- **Consistent Keybindings**: Same keybindings work on both platforms
- **Unified Theming**: Catppuccin Mocha theme throughout
- **Shared Workflows**: Identical development workflows
- **Agent Integration**: Same AI assistance on both platforms

### Customization

The configurations are designed to be easily customizable:

1. **Modify Individual Files**: Each configuration file is well-commented
2. **Add New Components**: Easy to extend with additional tools
3. **Adjust Theming**: Modify color schemes and appearance
4. **Change Keybindings**: Edit keybinding files to match preferences

### Troubleshooting

If you encounter issues:

1. **Check Logs**: Most applications provide logs for debugging
2. **Verify Dependencies**: Ensure all required packages are installed
3. **Review Configuration**: Check for syntax errors or incorrect settings
4. **Consult Documentation**: Refer to official documentation for each tool
5. **Test Incrementally**: Add configurations gradually to identify conflicts

### Best Practices

- **Backup Existing Configs**: Before installing, backup existing configurations
- **Test in Stages**: Install and test components incrementally
- **Use Version Control**: Keep your dotfiles in Git for easy recovery
- **Document Changes**: Note any customizations you make
- **Regular Updates**: Keep configurations up to date with upstream changes

## Integration with Platform-Specific Configurations

These common configurations work alongside the platform-specific configurations:

- **Arch Linux**: Integrates with Hyprland, Waybar, and other Arch-specific tools
- **macOS**: Works with AeroSpace, SketchyBar, and macOS-specific configurations
- **Consistent Core**: Provides the same core experience on both platforms
- **Shared Workflows**: Identical development workflows regardless of OS

## Development Workflow

The common configurations support a comprehensive development workflow:

1. **Shell Environment**: Fish shell with extensive aliases and integrations
2. **Terminal Management**: Tmux for session management and WezTerm for terminal emulation
3. **Code Editing**: LazyVim for powerful Neovim configuration
4. **Version Control**: Git with comprehensive aliases and integrations
5. **AI Assistance**: Mistral Vibe agents for coding, writing, and reviewing
6. **Consistent Experience**: Same tools and workflows on both Arch Linux and macOS

## Performance Optimization

All configurations are optimized for performance:

- **Fast Startup**: Lazy loading and efficient initialization
- **Responsive UI**: Optimized rendering and input handling
- **Memory Efficiency**: Careful resource management
- **Cross-Platform**: Consistent performance on both Arch Linux and macOS

## Future Development

The common configurations are designed to be extensible:

- **New Tools**: Easy to add additional tools and integrations
- **Enhanced Agents**: Expand AI assistance capabilities
- **Improved Workflows**: Continuously refine development processes
- **Cross-Platform**: Maintain consistency across operating systems
