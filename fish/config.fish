# Add PATHs
fish_add_path -a /opt/homebrew/bin
fish_add_path -a /opt/homebrew/sbin
fish_add_path -a /usr/local/sbin

# STARSHIP config
set -Ux STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

# NeoVim
set -Ux NVIM_APPNAME lazyvim

# Git aliases
alias gss "git status -s"

alias ga "git add"
alias gaa "git add --all"

alias gb "git branch"
alias gbd "git branch -d"

alias gc "git commit -v"
alias gc! "git commit -v --amend"
alias gcn! "git commit -v --no-edit --amend"
alias gcan! "git commit -v -a --no-edit --amend"
alias gcmsg "git commit -m"

alias gcb "git checkout -b"
alias gf "git fetch"

alias glg "git log --stat"

alias grb "git rebase"
alias grb "git rebase --continue"

echo "Welcome to Ark Corp!"
