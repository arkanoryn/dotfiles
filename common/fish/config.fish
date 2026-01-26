switch (uname)
    case Linux
        set -g fish_greeting "[Linux] Welcome to ArkCorp's $hostname!"

        set -gx OPENSSL_CONF /etc/ssl/openssl.cnf
        set -gx OPENSSL_MODULES /usr/lib/ssl/engines-3
        # if type -q tmux
        #     if not test -n "$TMUX"
        #         tmux attach-session -t default || tmux new-session -s default
        #     end
        # end
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        if test -f /opt/miniconda3/bin/conda
            eval /opt/miniconda3/bin/conda "shell.fish" hook $argv | source
        else
            if test -f "/opt/miniconda3/etc/fish/conf.d/conda.fish"
                . "/opt/miniconda3/etc/fish/conf.d/conda.fish"
            else
                set -x PATH /opt/miniconda3/bin $PATH
            end
        end
        # <<< conda initialize <<<
    case Darwin
        fish_add_path /opt/homebrew/bin
        set -g fish_greeting "[MacOS] Welcome to ArkCorp's $hostname!"

        # Added by LM Studio CLI (lms)
        set -gx PATH $PATH $HOME/.lmstudio/bin
        # End of LM Studio CLI section
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

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/anynines/.lmstudio/bin
# End of LM Studio CLI section

