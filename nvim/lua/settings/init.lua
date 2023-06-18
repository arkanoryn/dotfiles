-- disable netrw at the very start as it can conflict with neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("settings.set")
require("settings.remap")
