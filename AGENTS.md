# AGENTS.md - Coding Guidelines for Agentic Assistants

This repository is a personal dotfiles configuration using stow for managing system configurations. It contains Lua, Fish shell, Bash, and configuration files.

## CRITICAL: LazyVim Configuration Setup

The LazyVim configuration is located at `/home/arkanoryn/.dotfiles/common/lazyvim/lua/` and must be explicitly loaded via the `NVIM_APPNAME` environment variable. The shell is configured with:

```fish
set EDITOR "NVIM_APPNAME=lazyvim nvim"
```

**IMPORTANT**: Never examine or modify `~/.config/nvim/` directly—it may contain user-specific overrides. Always work with the `/home/arkanoryn/.dotfiles/common/lazyvim/` source files instead. Changes made directly to dotfiles will be symlinked to `~/.config/` via `stow`.

### Common LazyVim Issues & Solutions

**Fish Shell Aliases with Variables**
- Use `abbr` (abbreviations) instead of `alias` for variables to expand at execution time, not definition time
- Example: `abbr y $EDITOR` expands `$EDITOR` when you run `y`, not when the file is loaded
- Remove duplicate alias/abbr definitions - the last one wins

**Treesitter Errors**
- Treesitter module errors usually resolve with a full `Lazy! sync` followed by restarting nvim
- Don't override LazyVim's default treesitter config unless absolutely necessary
- Clear lazy cache if needed: `rm -rf /home/arkanoryn/.local/share/lazyvim/lazy`

## Build, Lint, and Test Commands

### Lua (LazyVim & Neovim Config)
- **Format**: `stylua /home/arkanoryn/.dotfiles/common/lazyvim`
- **Lint**: Use Neovim's built-in LSP or enable `lua_ls` via Mason
- **No formal tests** - configurations are validated by Neovim startup

### Fish Shell
- **Lint**: `fish --no-execute <file.fish>` - checks syntax without running
- **Test**: Source the file in Fish shell: `source <file.fish>`
- **Format**: No standard formatter; maintain consistent spacing and alignment

### Bash/Shell Scripts
- **Lint**: `shellcheck <script.sh>` - catches common errors and anti-patterns
- **Format**: Use `shfmt` for consistent formatting
- **Test**: `bash -n <script.sh>` or directly execute with error checking

### Running Single Tests
This is a configuration repository without formal unit tests. Validation occurs through:
1. Linting individual files (see above)
2. Testing configurations by reloading them in their respective shells
3. Manual verification after `stow` linking

## Code Style Guidelines

### Lua (LazyVim Configuration)

**Imports & Dependencies**
- Use `require()` to load modules at the top of files
- Follow LazyVim plugin spec structure for plugin configuration
- Use local variables to avoid polluting global scope

**Formatting & Style**
- Use `stylua` for automatic formatting (configured via `.stylua.toml` if present)
- Indent with 2 spaces
- Use `---@` annotations for type hints and IDE support
- Keep lines readable (stylua manages line length)

**Naming Conventions**
- Use `snake_case` for function and variable names
- Use `PascalCase` for class-like tables
- Prefix private functions with underscore: `_private_function()`
- Use descriptive, full names (avoid abbreviations where possible)

**Error Handling**
- Use `pcall()` for operations that might fail
- Check return values from `require()` calls
- Provide meaningful error messages with context

**Code Organization**
- Keep plugin specs modular (one plugin per file in `/plugins/` directory)
- Place configuration in `/config/` directory (options, keymaps, autocmds)
- Use comments with `--` for single-line and `--[[...]]` for multi-line documentation

### Fish Shell

**Imports & Sourcing**
- Load completions in `/conf.d/` using standard Fish patterns
- Use abbreviations (`abbr`) for shell aliases
- Source environment files early in configuration chain

**Formatting & Style**
- Indent with 4 spaces (Fish standard)
- Use descriptive function names with dots for namespacing: `__git.current_branch`
- Keep functions concise and focused

**Naming Conventions**
- Use `lowercase_with_underscores` for all identifiers
- Prefix private/internal functions with double underscore: `__internal_func`
- Use dots to namespace related functions: `__git.*`, `__prompt.*`

**Error Handling**
- Use `and` / `or` operators for chaining commands: `test -f file; and echo "found"`
- Check command exit status with `$status`
- Provide helpful error messages in user-facing functions

**Code Organization**
- Place shell functions in `/functions/` directory
- Place aliases in `/conf.d/` directory
- Keep completions in `/completions/` directory

### Bash/Shell Scripts

**Imports & Sourcing**
- Use `#!/usr/bin/env bash` shebang for portability
- Source scripts with `. ./path/to/script.sh` not `bash ./script.sh`
- Check if sourced vs executed: `[[ "${BASH_SOURCE[0]}" == "${0}" ]]`

**Formatting & Style**
- Indent with 2 spaces
- Use `set -euo pipefail` to catch errors early
- Quote all variable expansions: `"${var}"` not `$var`
- Use 4-space indentation for readability

**Naming Conventions**
- Use `UPPERCASE` for exported environment variables
- Use `lowercase` for local functions
- Use `snake_case` for all identifiers
- Use descriptive names for functions: `install_dependencies()` not `install()`

**Error Handling**
- Use `trap` to handle cleanup on exit or error
- Check return codes: `if ! command; then handle_error; fi`
- Provide context in error messages with file and line info
- Use `>&2` to send errors to stderr: `echo "Error: $msg" >&2`

**Code Organization**
- Group related setup scripts in `/archlinux/setup_scripts/`
- Keep utility functions separate from setup logic
- Add `|| exit 1` to critical commands that must succeed

## File Structure

```
/home/arkanoryn/.dotfiles/
├── common/                 # Cross-platform configs
│   ├── lazyvim/           # Neovim/LazyVim Lua configs
│   ├── fish/              # Fish shell configs
│   ├── tmux/              # Tmux configurations
│   └── ...
├── archlinux/             # ArchLinux-specific configs
│   ├── setup_scripts/     # Installation/setup bash scripts
│   └── ...
├── docs/                  # Markdown documentation (Obsidian vault)
└── AGENTS.md             # This file
```

## General Guidelines

### Documentation
- Use Markdown for all documentation
- Add comments explaining "why" not "what" the code does
- Include examples for non-obvious functionality

### Git Workflow
- Use conventional commits when relevant
- Keep commits focused on single concerns
- Test configurations locally before committing

### Repository Maintenance
- Use `stow` to manage symlink farms for configurations
- Test symlink creation with `stow --simulate` before applying
- Document any manual setup steps not automated by scripts

## Lua-Specific Details

The LazyVim configuration uses the following patterns:
- **Plugin specs** follow lazy.nvim format (see `/plugins/example.lua`)
- **Type annotations** use Lua Language Server comments (`---@type`, `---@param`)
- **Plugin configuration** uses `opts` table merging pattern
- **KeyMaps** are configured via plugin `keys` property
- **Autocmds** are set up in `/config/autocmds.lua` using `vim.api.nvim_create_autocmd()`

## Tools & Linters

Ensure these tools are installed for development:
- `stylua` - Lua formatter/linter (installed via Mason in Neovim)
- `shellcheck` - Shell script linter
- `shfmt` - Shell script formatter
- `fish` - Fish shell interpreter
- `lua` or `lua5.1` - Lua interpreter

## Tips for Agents

1. **Before modifying files**: Use linters to check current state
2. **When writing configs**: Test in the actual application (Neovim, Fish, etc.)
3. **Symlink operations**: Always simulate with `stow --simulate` first
4. **Error recovery**: Check `.git` history to understand configuration purpose
5. **Documentation**: Update relevant `.md` files in `/docs/` when adding features
