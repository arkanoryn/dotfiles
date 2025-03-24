# Getting Started [MacOS]

## Pre-requisites

### Packages

```sh
brew install stow # to manage all the configuration folders

# terminal packages
brew install brew install --cask wezterm \
  && brew install fish \
  && brew install starship \
  && brew install eza \
  && brew install zoxide \
  && brew install bat \
  && brew install fzf \

# mac windows management packages
brew install --cask nikitabobko/tap/aerospace
brew install lua \
  && brew tap FelixKratz/formulae \
  && brew install sketchybar \
  && brew install borders

# LazyVim Dependencies
brew install ripgrep 
  && brew install fd \
  # fzf might be skipped if already installed with the terminal packages
  && brew install fzf \ 
  && brew install neovim
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

Packages have been spread between `MacOS` specific packages and settings and common ones.
You can decide to link all of them to your own `.config` folder, or only some of them.

To do so, `cd` into `macOS` and run the command below. Do the same for `common`.

```sh
stow .
```
If you want to only link _some_ packages, `cd` into `common` or `macOS` and run the command:

```sh
stow <folder>
```

## Documentation

Some of the configurations and shortcuts the tools I am using create are
documented under the `/docs` folder.
While all files are simple markdown ones, the folder is an
[Obsidian](https://obsidian.md/) folder. You might want to open it with that
application instead of a regular app, as it is mostly built as atomic notes with
all notes being embedded in the map of contents.

---

# Getting Started [ArchLinux]

Before running these dotfiles, you should ensure that the following packages have been installed.

```sh
yay -S libva-nvidia-driver \ #if you run an nvidia Graphic Card
    nvidia-settings \ # same as above
    qt5-wayland qt6-wayland  qt5ct nwg-look kvantum \ # for graphical interfaces
    ripgrep \
    fd \
    fzf \
    zen-browser-bin \
    neovim \
    fish \
    starship\
    ghostty \
    less \
    tree \
    eza \
    zoxide \
    bat \
    stow \
    waybar \
    ttf-font-awesome \
    libnotify swaync \
    pamixer \
    pavucontrol \
    tree \
    man-db \
    sddm-theme-sugar-candy
```

> [!info]
> _yazi requires the following packages to run as expected._

```sh
yay -S yazi \
ffmpeg \
7zip \
jq \
poppler \
fd \
ripgrep \
fzf \
zoxide \
imagemagick
```
> [!WARNING]
> Read the [Nvidia guide](https://wiki.hyprland.org/Nvidia/) as there are
> special rules/configurations that can not be done from just the .dotfiles.

## Todos

### .dotfiles

- [x] Fix fish to be usable in both archlinux and macOS
- [x] eza
- [x] zoxide
- [x] bat

### Hyprland

### Bindings

### Other apps
- [ ] login
- [x] wallpapers
- [x] waybar
- [ ] swaync
- [ ] hyprshot
- [ ] hyprlock
- [ ] hypridle
- [ ] hyprpaper
- [ ] swwww
- [ ] yazi

### Waybar

A lot of work to do on the waybar,but it's a good starting point for now.

### Audio Control

- [ ] use pipewire (and remove any un-necessary other app)
- [ ] make the controller floating under the area (by default) instead of opening another tiled window

