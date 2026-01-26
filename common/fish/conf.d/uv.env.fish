switch (uname)
    case Linux
        set -g fish_greeting "[Linux] Welcome to ArkCorp's $hostname!"

        source "$HOME/.config/fish/conf.d/env.fish"
    case Darwin
        source "$HOME/.local/bin/env.fish"
    case '*'
        echo "uv.env.fish is not setup."
end
