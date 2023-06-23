# nVim Config

## General Cheatsheet

### Searches

| command | description | example |
|---------|-------------|---------|
| / | search <term> forward | /my |
| ? | search <term> backward | ?my |
| * | search current word forward |  |
| # | search current word backward |  |

### Actions

| shortcut | description |
|---------|-------------|
| vi{ | will visual select everything inside the current or next `{}` Also works with other types of braces. |
| va{ | same as above but will select the parenthese with. |


this is a {  test } message

## TODO:

- surround
 - format on save and shortcuts: https://github.com/LazyVim/LazyVim/blob/ed89d01113b7c8495224cb7a88fe5ccb3f001ac5/lua/lazyvim/plugins/lsp/format.lua#L46
- tabs
- move the rest of /init.lua
- review treesitter setup
- configure telescope
    - map telescope
- general key mappings
    - map buffer shortcuts
    - map to create new file / buffer
    - remove trailing whitespaces on save
- coding
    - surround
    - https://github.com/akinsho/toggleterm.nvim
    - hhttps://github.com/Wansmer/treesj
    - fhast move to windows via 1, 2, 3...
    - ehasy motion or similar
    - hharpoon
- auto generate list symbols?
- sort list?
- marks?
- https://github.com/stevearc/aerial.nvim/

## Folders
- settings: general / global settings
- coding: all coding-related settings
- editor: everything that is related to make vim a good editor
- ui: everything related to make vim look good

## <leader> Keymaps folders

| shortcut | description |
|---------|-------------|
| a | action? |
| b | buffer |
| c | code |
| d | |
| e | |
| f | file |
| g | git |
| h | help |
| i | insert |
| j | |
| k | |
| l | |
| m | |
| n | notes |
| o | open |
| p | project |
| q | quit |
| r | |
| s | search |
| t | toggle? / tab? |
| u | |
| v | |
| w | window |
| x | |
| y | |
| z | |
