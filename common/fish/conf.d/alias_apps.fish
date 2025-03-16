alias reload='exec fish'

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
else
    set_color $fish_color_error --bold
    echo -n "[Warning] "
    set_color normal
    echo "'eza' is not installed. Consider installing it to enjoy listing aliases."
end

if type -q bat
    abbr cat "bat -A"
else
    set_color $fish_color_error --bold
    echo -n "[Warning] "
    set_color normal
    echo "'bat' is not installed. Consider installing it to enjoy better cat outputs."
end

if type -q fzf
    abbr fzf "fzf --preview \"bat --color=always --style=numbers --line-range=:500 {}\""
else
    set_color $fish_color_error --bold
    echo -n "[Warning] "
    set_color normal
    echo "'fzf' is not installed."
end

abbr mkdir "mkdir -p"

switch (uname)
    #case Linux
    case MacOS
        alias ,keyboards "cd ~/projects/qmk_keyboards/"
        alias ,,keyboards "cd ~/projects/qmk_keyboards/ && yh"
        alias ,qmk "cd ~/projects/qmk_root/"
        alias ,anynines "cd ~/projects/anynines/"
        alias ,move "cd ~/projects/anynines/move/"
        alias ,,move "cd ~/projects/anynines/move/ && yh"
    case '*'
        alias ,. "cd ~/.dotfiles"
        alias ,,. "cd ~/.dotfiles/ && yh"
end

# NeoVim
if path is ~/.config/lazyvim
    alias y "NVIM_APPNAME=LazyVim nvim"
    alias yh "NVIM_APPNAME=LazyVim nvim ."
else
    alias y nvim
    alias yh "nvim ."
end
alis vi nvim
alias s nvim
alias st "nvim ."

## qmk compiles
alias sweep-full "cd users/v1/scripts/generator/ && python3 main.py && cd ~/projects/qmk_keyboards && qmk flash -kb splitkb/aurora/sweep/rev1 -k"
alias sweep-simple "qamk flash -kb splitkb/aurora/sweep/rev1 -k"
