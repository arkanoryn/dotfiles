-- disable netrw at the very start as it can conflict with neo-tree
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

require("core.set")
require("core.remap")

-- Install package manager https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- this will load all the plugins in /lua/ark-config/plugins/
require("lazy").setup({{import = "plugins"}})

