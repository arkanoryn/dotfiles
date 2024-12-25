# STARSHIP config
set -Ux STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

# put the prompt on the last line
tput cup $COLUMNS 0

fish_vi_key_bindings

set -g fish_greeting "Welcome to Ark Corp!"
