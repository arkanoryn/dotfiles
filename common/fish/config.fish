switch (uname)
    case Darwin # macOS
        fish_add_path /opt/homebrew/bin
end

# STARSHIP config
set -Ux STARSHIP_CONFIG ~/.config/starship/starship.toml
function starship_transient_rprompt_func
    starship module time
end
starship init fish | source
enable_transience

# Zoxide initialization
zoxide init --cmd cd fish | source

# put the prompt on the last line
#tput cup $COLUMNS 0

#set fish_vi_force_cursor 1
#fish_vi_key_bindings

set -g fish_greeting "Welcome to Ark Corp!"
