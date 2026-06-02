switch (uname)
    case Linux
        # vibe aliases
        alias nyxara "vibe --agent nyxara"
        alias elyndra "vibe --agent elyndra"
        alias zephyra "vibe --agent zephyra"

        set -gx VIBE_HOME "~/.vibe"

        # Pi aliases
        abbr pim 'pi --provider minimax --model minimax-m2.7'
        abbr pic 'pi --provider openai-codex --model gpt-5.5'

    case Darwin
        abbr pic 'pi --provider github-copilot --model gpt-5.5'
end

# accessible in both MacOS and Linux
abbr piv 'pi --provider mistral --model mistral-medium-3.5'
