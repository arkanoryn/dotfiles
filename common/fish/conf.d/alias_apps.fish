switch (uname)
    case Linux
        set EDITOR "NVIM_APPNAME=lazyvim nvim"
        set DOTFILES "~/.dotfiles"
    case Darwin
        set EDITOR "NVIM_APPNAME=LazyVim nvim"
        set DOTFILES "~/.dotfiles"
end

alias reload='exec fish'

# Lazy-load eza aliases on first use
function __init_eza_abbr --description "Initialize eza abbreviations on first use"
    if type -q eza
        abbr l 'eza --icons=auto' # long list
        abbr ls 'eza -1 --icons=auto' # short list
        abbr la "eza -lag --icons --sort=name --group-directories-first"
        abbr ll 'eza -lha --icons=auto --sort=name --group-directories-first' # long list all
        abbr ld 'eza -lhD --icons=auto' # long list dirs
        abbr lt 'eza --icons=auto --tree' # list folder as tree
        abbr lt1 'eza --icons=auto --tree --level=1' # list folder as tree depth 1
        abbr lt2 'eza --icons=auto --tree --level=2' # list folder as tree (depth 2)
        abbr lta 'eza -lTag --icons=auto' # list folder as tree
        abbr lta1 'eza -lTag --icons=auto level=1' # list folder as tree
        abbr lta2 'eza -lTag --icons=auto level=2' # list folder as tree
        functions --erase __init_eza_abbr
    else
        set_color $fish_color_error --bold
        echo -n "[Warning] "
        set_color normal
        echo "'eza' is not installed. Consider installing it to enjoy listing aliases."
        functions --erase __init_eza_abbr
    end
end

# Lazy-load bat alias on first use
function __init_bat_abbr --description "Initialize bat abbreviations on first use"
    if type -q bat
        abbr cat "bat -A"
        functions --erase __init_bat_abbr
    else
        set_color $fish_color_error --bold
        echo -n "[Warning] "
        set_color normal
        echo "'bat' is not installed. Consider installing it to enjoy better cat outputs."
        functions --erase __init_bat_abbr
    end
end

# Lazy-load fzf alias on first use
function __init_fzf_abbr --description "Initialize fzf abbreviations on first use"
    if type -q fzf
        abbr fzf "fzf --preview \"bat --color=always --style=numbers --line-range=:500 {}\""
        functions --erase __init_fzf_abbr
    else
        set_color $fish_color_error --bold
        echo -n "[Warning] "
        set_color normal
        echo "'fzf' is not installed."
        functions --erase __init_fzf_abbr
    end
end

# Trigger lazy-loading when abbreviations are first used
abbr --erase l 2>/dev/null; abbr l "__init_eza_abbr; l"
abbr --erase ls 2>/dev/null; abbr ls "__init_eza_abbr; ls"
abbr --erase la 2>/dev/null; abbr la "__init_eza_abbr; la"
abbr --erase ll 2>/dev/null; abbr ll "__init_eza_abbr; ll"
abbr --erase ld 2>/dev/null; abbr ld "__init_eza_abbr; ld"
abbr --erase lt 2>/dev/null; abbr lt "__init_eza_abbr; lt"
abbr --erase lt1 2>/dev/null; abbr lt1 "__init_eza_abbr; lt1"
abbr --erase lt2 2>/dev/null; abbr lt2 "__init_eza_abbr; lt2"
abbr --erase lta 2>/dev/null; abbr lta "__init_eza_abbr; lta"
abbr --erase lta1 2>/dev/null; abbr lta1 "__init_eza_abbr; lta1"
abbr --erase lta2 2>/dev/null; abbr lta2 "__init_eza_abbr; lta2"

abbr --erase cat 2>/dev/null; abbr cat "__init_bat_abbr; cat"
abbr --erase fzf 2>/dev/null; abbr fzf "__init_fzf_abbr; fzf"

abbr mkdir "mkdir -p"

# NeoVim
abbr y $EDITOR
abbr yh "$EDITOR ."
abbr vi $EDITOR
alias s nvim # useful if there is a distinction between LazyVim and vanilla nvim
alias st "nvim ."

switch (uname)
    case Linux
        alias ,. "cd ~/.dotfiles"
        alias ,,. "cd ~/.dotfiles/ && $EDITOR"
    case Darwin
        alias ,keyboards "cd ~/projects/qmk_keyboards/"
        alias ,,keyboards "cd ~/projects/qmk_keyboards/ && $EDITOR ."
        alias ,qmk "cd ~/projects/qmk_root/"
        alias ,anynines "cd ~/projects/anynines/"
        alias ,move "cd ~/projects/anynines/move/"
        alias ,,move "cd ~/projects/anynines/move/ && $EDITOR ."
        alias ,. "cd ~/.dotfiles"
        alias ,,. "cd ~/.dotfiles/ && $EDITOR ."
end

alias ,config "cd ~/.config"
alias ,,config "cd ~/.config && $EDITOR ."
alias econfig "$EDITOR ~/.config"
alias edotfiles "$EDITOR $DOTFILES"

## qmk compiles
alias sweep-full "cd users/v1/scripts/generator/ && python3 main.py && cd ~/projects/qmk_keyboards && qmk flash -kb splitkb/aurora/sweep/rev1 -k"
alias sweep-simple "qamk flash -kb splitkb/aurora/sweep/rev1 -k"
