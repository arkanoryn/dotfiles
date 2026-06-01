switch (uname)
    case Linux
        # vibe aliases
        alias nyxara "vibe --agent nyxara"
        alias elyndra "vibe --agent elyndra"
        alias zephyra "vibe --agent zephyra"

        set -gx VIBE_HOME "~/.vibe"
        # case Darwin

        # Pi aliases
        abbr piv 'pi --provider mistral --model mistral-medium-3.5'
        abbr pim 'pi --provider minimax --model minimax-m2.7'
        abbr pic 'pi --provider openai-codex --model gpt-5.5'
end
