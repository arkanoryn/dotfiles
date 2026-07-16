switch (uname)
    case Linux
        # vibe aliases
        alias nyxara "vibe --agent nyxara"
        alias elyndra "vibe --agent elyndra"
        alias zephyra "vibe --agent zephyra"

        set -gx VIBE_HOME $HOME/.vibe

        # Pi aliases
        abbr pic 'pi --provider openai-codex --model gpt-5.5 --thinking medium'

    case Darwin
        abbr pic 'pi --provider github-copilot --model gpt-5.5'
        abbr ccs 'claude --model sonnet'
        abbr cco 'claude --model opus'
end

# accessible in both MacOS and Linux
abbr piv 'pi --provider mistral --model mistral-medium-3.5'
abbr pim 'pi --provider minimax --model MiniMax-M3'
