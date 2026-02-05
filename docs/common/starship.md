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


