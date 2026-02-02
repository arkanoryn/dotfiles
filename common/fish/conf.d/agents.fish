switch (uname)
    case Linux
        alias dev-vibe "$HOME/Code/mistral-vibe/dev-vibe (pwd)"

        alias nyxara "dev-vibe --agent nyxara (pwd)"
        alias elyndra "dev-vibe --agent elyndra (pwd)"
        alias zephyra "dev-vibe --agent zephyra (pwd)"

        set -gx VIBE_HOME "~/.vibe"
        # case Darwin
end
