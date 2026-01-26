---
tags:
  - moc
---

# Tmux

## Introduction

![[tmux-introduction]]

## Theme

![[tmux-theme]]

## Glossary

[[tmux-Session|Session]] > [[tmux-Windows|Window]] > [[tmux-Pane|Pane]]

## Shortcuts

### Prefix

Most of the Shortcuts are dependant on what tmux calls a `prefix`. From my understanding, it is the equivalent of the `leader` key in [[NeoVim]]
In order for tmux to be consistent with [[Aerospace]] I wanted to use the [[Meh]] key I have on my custom keyboards. Unfortunately I seem to be unable to match `C-M-S-k`. So for now I'll stick with the default.

> [!Info]+ Modifiers
>
> - `C` is for the `Control` key
> - `M` is for the `Meta` (== `Alt`) key
> - `S` is for the `Shift` key

### Session

#### CLI Commands

| Full Command                    | Command Shortcut           | Description                                                 |
| ------------------------------- | -------------------------- | ----------------------------------------------------------- |
| `tmux list-sessions`            | `tmux ls`                  | list all sessions                                           |
| `tmux attach`                   | `tmux a`                   | open a new session and attach to the most recently used one |
| `tmux attach -t <session name>` | `tmux a -t <session name>` | open a new session and attach to the session <session name> |
| `tmux rename-session <new session name>` |  | rename the session to <session name> |
| `tmux kill-session -t <session name>` |  | kill the session <session name> |

Some of the configurations and shortcuts the tools I am using create are documented under
the `/docs` folder.
While all files are simple markdown ones, the folder is an
[Obsidian](https://obsidian.md/) folder. You might want to open it with that
application instead of a regular app, as it is mostly built as atomic notes with
all notes being embedded in the map of contents.


#### Keyboard Shortcuts

|  Command          | Description                                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------------ |
| `prefix :new<CR>` | new session |
| `prefix $` | rename the session to <session name> |
| `prefix s` | list all session |

### Windows

%%
#### CLI Commands

| Full Command                    | Command Shortcut           | Description                                                 |
| ------------------------------- | -------------------------- | ----------------------------------------------------------- |
| `tmux list-sessions`            | `tmux ls`                  | list all sessions                                           |
%%

#### Keyboard Shortcuts

|  Command          | Description                                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------------ |
| `prefix c` | new window |
| `prefix w` | list window |
| `prefix n` | next window |
| `prefix p` | previous window |
| `prefix f` | find window |
| `prefix ,` | rename window |
| `prefix &` | kill window |
