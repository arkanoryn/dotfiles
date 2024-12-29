alias reload='exec fish'

alias l "ls -la"
alias la "ls -la"
alias lt "ls --tree"

alias d cd
alias , cd

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
