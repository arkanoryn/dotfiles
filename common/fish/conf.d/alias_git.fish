# Git aliases
abbr -a gss git status -sb

abbr -a ga git add
abbr -a gaa git add --all

abbr -a gc git commit -v
abbr -a gcsmg git commit -m
abbr -a gca git commit -v -a
abbr -a gc! git commit -v --amend
abbr -a gcn! git commit -v --no-edit --amend
abbr -a gcan! git commit -v -a --no-edit --amend

abbr -a gb git branch
abbr -a gbd git branch -d

abbr -a gcl git clone

abbr -a gco git checkout
abbr -a gcb git checkout -b

abbr -a ggl git pull (__git.current_branch)
abbr -a ggp git push origin (__git.current_branch)
abbr -a ggf git push --force origin (__git.current_branch)

abbr -a gd git diff
abbr -a gds git diff --staged

abbr -a gr git rebase -i HEAD~15
abbr -a gf git fetch

abbr -a gfc git findcommit
abbr -a gfm git findmessage

abbr -a glg git log --stat

abbr -a grb git rebase
abbr -a grbm git rebase (__git.default_branch)
abbr -a grb git rebase --continue
