alias reload='exec fish'

# eza (better `ls`)
alias l "eza --icons"
alias ls "eza --icons"
alias ll "eza -lg --icons"
alias la "eza -lag --icons"
alias lt "eza -lTg --icons"
alias lt1 "eza -lTg --level=1 --icons"
alias lt2 "eza -lTg --level=2 --icons"
alias lt3 "eza -lTg --level=3 --icons"
alias lta "eza -lTag --icons"
alias lta1 "eza -lTag --level=1 --icons"
alias lta3 "eza -lTag --level=2 --icons"
alias lta3 "eza -lTag --level=3 --icons"

# Bat (better `cat`, but can be used for more)
alias cat "bat -A"
alias fzf "fzf --preview \"bat --color=always --style=numbers --line-range=:500 {}\""


# Directories
alias ,. "cd ~/.dotfiles/"
alias ,,. "cd ~/.dotfiles/ && yh"
alias ,keyboards "cd ~/projects/qmk_keyboards/"
alias ,,keyboards "cd ~/projects/qmk_keyboards/ && yh"
alias ,qmk "cd ~/projects/qmk_root/"
alias ,anynines "cd ~/projects/anynines/"
alias ,move "cd ~/projects/anynines/move/"
alias ,,move "cd ~/projects/anynines/move/ && yh"

# NeoVim
alias y "NVIM_APPNAME=LazyVim nvim"
alias yh "NVIM_APPNAME=LazyVim nvim ."
alias s nvim
alias st "nvim ."

# qmk compiles
alias seep-full "cd users/v1/scripts/generator/ && python3 main.py && cd ~/projects/qmk_keyboards && qmk flash -kb splitkb/aurora/sweep/rev1 -k"
alias seep-simple "qamk flash -kb splitkb/aurora/sweep/rev1 -k"
