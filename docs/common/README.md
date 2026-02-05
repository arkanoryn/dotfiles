# Common Configuration Documentation

This directory contains documentation for the common configurations in this dotfiles repository that are shared between both Arch Linux and macOS systems. These configurations provide a consistent experience across both operating systems.

## Overview

The `common/` directory contains configurations for:
- **Fish Shell**: A user-friendly command line shell with cross-platform support (see [Fish documentation](fish.md))
- **Starship**: A minimal, blazing-fast, and infinitely customizable prompt (see [Starship documentation](starship.md))
- **Tmux**: A terminal multiplexer with Catppuccin Mocha theme (see [Tmux documentation](tmux.md))
- **WezTerm**: A GPU-accelerated cross-platform terminal emulator (see [WezTerm documentation](wezterm.md))
- **LazyVim**: A Neovim configuration with Lazy.nvim plugin manager (see [LazyVim documentation](lazyvim.md))
- **Agents**: LLM agent configurations for Mistral Vibe (see [Agents documentation](agents.md))
- **Zsh**: Zsh shell configuration with Powerlevel10k theme
- **Git**: Git configuration and ignore patterns (see [Git documentation](git.md))
- **Ghostty**: Terminal emulator configuration (see [Ghostty documentation](ghostty.md))
- **Snippets**: Code snippets for various languages

For a complete overview, see the [Common Configuration Documentation Index](Index.md).

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
└── .stowrc
```

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
