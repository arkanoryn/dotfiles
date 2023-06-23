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

- [ ] format on save and shortcuts: https://github.com/LazyVim/LazyVim/blob/ed89d01113b7c8495224cb7a88fe5ccb3f001ac5/lua/lazyvim/plugins/lsp/format.lua#L46
- [ ] tabs
- [ ] move the rest of /init.lua
- [ ] review treesitter setup
- [ ] configure telescope
    - [ ] map telescope
- [ ] general key mappings
    - [x] map buffer shortcuts
    - [ ] map to create new file / buffer
    - [ ] remove trailing whitespaces on save
- [ ] coding
    - [ ] https://github.com/akinsho/toggleterm.nvim
    - [ ] hhttps://github.com/Wansmer/treesj
    - [ ] harpoon
    - [ ] spectre: nvim-pack/nvim-spectre
- [ ] auto generate list symbols?
- [ ] sort list?
- [ ] marks?

