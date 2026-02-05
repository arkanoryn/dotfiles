# Common Configuration Documentation Index

Welcome to the common configuration documentation. This index provides an overview of the cross-platform configurations that work seamlessly on both Arch Linux and macOS systems.

## 📚 Table of Contents

### 🎯 Core Components

- **[Fish Shell](fish.md)**: User-friendly command line shell
  - Extensive aliases and functions
  - Custom keybindings and theme
  - Plugin management with Fisher
  - Environment configuration

- **[Starship](starship.md)**: Minimal, blazing-fast shell prompt
  - Git integration and status indicators
  - Cross-platform compatibility
  - Customizable appearance

- **[Tmux](tmux.md)**: Terminal multiplexer
  - Catppuccin Mocha theme
  - Vim-style keybindings
  - Session and window management
  - Plugin integration

- **[WezTerm](wezterm.md)**: GPU-accelerated terminal emulator
  - Cross-platform configuration
  - Custom keybindings and appearance
  - Font and theme management

- **[LazyVim](lazyvim.md)**: Neovim configuration
  - Lazy.nvim plugin manager
  - Comprehensive plugin setup
  - Language server integration
  - Code formatting and linting

- **[Agents](agents.md)**: LLM agent configurations
  - Mistral Vibe agent configurations
  - Code review, writing, and development assistance
  - Custom prompts and skills
  - Shared resources and configurations

- **[Git](git.md)**: Version control configuration
  - Aliases and ignore patterns
  - Cross-platform consistency
  - Integration with development workflow

- **[Ghostty](ghostty.md)**: Terminal emulator
  - Alternative terminal configuration
  - Cross-platform support
  - Custom appearance and behavior

- **[Snippets](README.md#snippets-configuration)**: Code snippets
  - Reusable code templates
  - Multi-language support
  - Productivity enhancements

### 📁 Directory Structure

```
common/
├── agents/             # AI agent configurations
├── fish/               # Fish shell setup
├── git/                # Git configuration
├── ghostty/            # Ghostty terminal
├── lazyvim/            # Neovim configuration
├── snippets/           # Code snippets
├── starship/           # Shell prompt
├── tmux/               # Terminal multiplexer
└── wezterm/            # Terminal emulator
```

### 🚀 Getting Started

1. **Install All Common Configurations**:
   ```bash
   cd ~/.dotfiles/common
   stow .
   ```

2. **Selective Installation**: Install only specific components
   ```bash
   cd ~/.dotfiles/common
   stow fish starship tmux wezterm
   ```

### 🔧 Key Features

- **Cross-Platform Consistency**: Same core tools on both Arch Linux and macOS
- **Modular Design**: Install only what you need
- **Productivity Focus**: Optimized for developer workflows
- **Consistent Theming**: Catppuccin Mocha theme throughout
- **AI Assistance**: Integrated Mistral Vibe agents

### 📖 Related Documentation

- **[Arch Linux Configuration](../archlinux/README.md)**: Arch Linux-specific setup
- **[macOS Configuration](../macos/README.md)**: macOS-specific setup
- **[Agents Documentation](agents.md)**: Detailed agent configurations

### 🎯 Usage Patterns

- **Development Workflow**: Comprehensive coding environment
- **Terminal Management**: Tmux sessions and WezTerm integration
- **Shell Productivity**: Fish shell with extensive aliases
- **Code Editing**: LazyVim with language server support
- **AI Assistance**: Mistral Vibe agents for various tasks

### 🐛 Troubleshooting

If you encounter issues:

1. **Check Logs**: Most applications provide detailed logs
2. **Verify Dependencies**: Ensure all required packages are installed
3. **Review Configuration**: Check for syntax errors or incorrect settings
4. **Consult Documentation**: Refer to official documentation for each tool
5. **Test Incrementally**: Add configurations gradually to identify conflicts

### 📝 Best Practices

- **Backup Existing Configs**: Before installing, backup existing configurations
- **Test in Stages**: Install and test components incrementally
- **Use Version Control**: Keep your dotfiles in Git for easy recovery
- **Document Changes**: Note any customizations you make
- **Regular Updates**: Keep configurations up to date

### 🔗 Quick Links

- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [Starship Documentation](https://starship.rs/)
- [Tmux Documentation](https://github.com/tmux/tmux/wiki)
- [WezTerm Documentation](https://wezfurlong.org/wezterm/)
- [LazyVim Documentation](https://www.lazyvim.org/)
- [Git Documentation](https://git-scm.com/doc)