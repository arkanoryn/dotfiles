vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NORMAL Mode
local save_cmd = "<cmd>w!<CR>"
vim.keymap.set("n", "<C-s>", save_cmd, { desc = 'save on Ctrl-s' })
vim.keymap.set("n", "<C-S>", save_cmd, { desc = 'save on Ctrl-S' })
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = '[y]ank to clipboard' })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = '[Y]ank full line to clipboard' })
vim.keymap.set("n", "Q", "<nop>")                -- no recordings
vim.keymap.set("n", "J", "mzJ`z")                -- concat the next line at the end of the current line without moving the cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")          -- move down but stay at the middle of the screen
vim.keymap.set("n", "<C-u>", "<C-u>zz")          -- move up but stay at the middle of the screen

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set({ 'n', 'v' }, '<leader>wqa', ':qa<CR>', { desc = '[w]indow [q]uit [a]ll' })
vim.keymap.set({ 'n', 'v' }, '<leader>wq!', ':qa!<CR>', { desc = '[w]indow [q]uit all[!]' })
vim.keymap.set({ 'n', 'v' }, '<leader>wqw', ':wq<CR>', { desc = '[w]indow [q]uit and [w]rite' })
vim.keymap.set({ 'n', 'v' }, '<leader>wv', ':vsplit<CR>', { desc = '[w]indow [v]ertical split' })
vim.keymap.set({ 'n', 'v' }, '<leader>ws', ':split<CR>', { desc = '[w]indow horizontal [s]plit' })
vim.keymap.set({ 'n', 'v' }, '<leader>wh', "<C-w>h", { desc = 'move to left [w]indow' })
vim.keymap.set({ 'n', 'v' }, '<leader>wj', "<C-w>j", { desc = 'move to down [w]indow' })
vim.keymap.set({ 'n', 'v' }, '<leader>wk', "<C-w>k", { desc = 'move to up [w]indow' })
vim.keymap.set({ 'n', 'v' }, '<leader>wl', "<C-w>l", { desc = 'move to right [w]indow' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")     -- move down the selected lines in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")     -- move up the selected lines in visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")     -- move down the selected lines in visual mode
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")     -- move up the selected lines in visual mode
vim.keymap.set("v", "<A-down>", ":m '>+1<CR>gv=gv")     -- move down the selected lines in visual mode
vim.keymap.set("v", "<A-up>", ":m '<-2<CR>gv=gv")     -- move up the selected lines in visual mode

-- Move text up and down
vim.keymap.set("n", "<A-j>", "<Esc>:m .+1<CR>==")
vim.keymap.set("n", "<A-k>", "<Esc>:m .-2<CR>==")
vim.keymap.set("n", "<A-down>", "<Esc>:m .+1<CR>==")
vim.keymap.set("n", "<A-up>", "<Esc>:m .-2<CR>==")

vim.keymap.set("i", "<A-down>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-up>", "<Esc>:m .-2<CR>==gi")

-- VISUAL Mode
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = '[p]aste without overriding yank' })

-- INTERACTIVE Mode
vim.keymap.set("i", "<C-c>", "<Esc>")            -- CTRL-c behaves has Esc

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Buffers
-- * buffer list and open
-- * next / prev buffer
-- * fzf buffer
