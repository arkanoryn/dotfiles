switch (uname)
    case Linux
        set -g fish_greeting "[Linux] Welcome to ArkCorp's $hostname!"
    case Darwin
        fish_add_path /opt/homebrew/bin
        set -g fish_greeting "[MacOS] Welcome to ArkCorp's $hostname!"
    case '*'
        set -g fish_greeting "[Unknown] $hostname is running an un-parametered fish.\nCheckout ~/.config/fish/config.fish"
end

# zoxide init; [WARNING] the `--cmd cd` flag replace the default cd. If not installed, I don't know how it will behave.
zoxide init --cmd cd fish | source

# STARSHIP config
set -Ux STARSHIP_CONFIG ~/.config/starship/starship.toml
function starship_transient_rprompt_func
    starship module time
end
starship init fish | source
enable_transience

# Zoxide initialization
zoxide init --cmd cd fish | source
