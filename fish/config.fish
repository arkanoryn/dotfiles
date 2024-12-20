# Add PATHs
fish_add_path -a "/opt/homebrew/bin"
fish_add_path -a "/opt/homebrew/sbin"
fish_add_path -a "/usr/local/sbin"

# STARSHIP config
set -Ux STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

set -Ux NVIM_APPNAME lazyvim

echo "Welcome to Ark Corp!"