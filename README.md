# Fonts
Install a font from [nerdfonts.com/font-downloads](nerdfonts.com/font-downloads)

# ZSH
Using the [oh-my-zsh distribution](https://ohmyz.sh/#install).
See website for instructions and then create symlink of the different config files from `/zsh`

```bash
ln -s <dotfile_path>/zsh/zshenv ~/.zshenv
ln -s <dotfile_path>/zsh/zshrc ~/.zshrc
ln -s <dotfile_path>/zsh/zprofile ~/.zprofile
ln -s <dotfile_path>/zsh/p10k.zsh ~/.p10k.zsh
```

# Git
- [ ] move `~/.config/git/gitignore` to `.dotfile`

- Auto correction
```bash
git config --global user.name "<your_name>"
git config --global user.email "<your_email>"
git config --global help.autocorrect 1            # enable autocorrect
git config --global core.autocrlf true            # fix end of files
```

- global gitignore
```bash
ln -s git/gitignore ~/.config/git/gitignore
git config --global core.excludesfile <global.gitignore.file>
```
