switch (uname)
    case Linux
        alias dev-vibe $HOME/Code/mistral-vibe/dev-vibe

        alias nyxara "dev-vibe --agent nyxara"
        alias elyndra "dev-vibe --agent elyndra"
        alias zephyra "dev-vibe --agent zephyra"

        set -gx VIBE_HOME "~/.vibe"
        # case Darwin
end
