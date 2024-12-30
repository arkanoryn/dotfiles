# Getting Started

## Pre-requisites

### Packages

```sh
brew install stow # to manage all the configuration folders

# terminal packages
brew install brew install --cask wezterm
brew install fish
brew install starship

# mac windows management packages
brew install --cask nikitabobko/tap/aerospace
brew install lua && brew tap FelixKratz/formulae && brew install sketchybar
brew install borders

# LazyVim Dependencies
brew install ripgrep && brew install fd && brew install fzf
brew install neovim
```

* [Stow](https://www.gnu.org/software/stow/manual/stow.html): a symlink farm manager
* [WezTerm](https://wezfurlong.org/wezterm/): a terminal emulator
* [Fish](https://fishshell.com/): a command line shell
* [Starship](https://starship.rs/): a minimal, blazing-fast, and infinitely
  customizable prompt for any shell!
* [AeroSpace](https://github.com/nikitabobko/AeroSpace): a tiling window manager
* [SketchyBar](https://felixkratz.github.io/SketchyBar/): a fancy bar to work with
  AeroSpace

### Fonts

Install a font from [nerdfonts.com/font-downloads](nerdfonts.com/font-downloads).

> Info
> Wezterm requires `FiraCode`. This can be changed from the Wezterm config file.

## Installation / Setup

From the root of this repository, run the following command:

```sh
stow .
```

## Documentation

Some of the configurations and shortcuts that they create are documented under
the `/docs` folder.
While all files are simple markdown ones, the folder is an
[Obsidian](https://obsidian.md/) folder. You might want to open it with that
application instead of a regular app, as it is mostly built as atomic notes with
all notes being embedded in the map of contents.
