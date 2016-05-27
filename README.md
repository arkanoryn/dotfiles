# Fonts
## Powerline font
run ./install.sh to install the font once on the font folder
Currently using "Droid Sans Mono" from the font patched

## Awesome font
To install, follow the instruction at: https://github.com/gabrielelana/awesome-terminal-fonts
or use the fonts patched : https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy

If brew refuse to install, use the following command:
```
sudo chown -R $USER /usr/local
$ mkdir -p ~/Library/Caches/Homebrew/Formula
```

This should allow you to follow awesome-terminal-fonts instructions.

# ZSH
Zsh use oh-my-zsh
For using ZSH as a default shell, please type the following command:
`chsh -s /bin/zsh`

# Vim
* Install Vundle (cf. github repo)
* Link each vim folders into you ~/.vim


## YouCompleteMe
Install Clang through:

```
cd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer
```

## Vimproc
don't forget to manually compile vimproc through "make"

## AG
Install AG through:
```
brew install the_silver_searcher
brew install automake pkg-config pcre xz
```

# CTags
```
brew tap universal-ctags/universal-ctags

brew install --HEAD universal-ctags
```

# Git
Auto correction
`git config --global help.autocorrect 1`
