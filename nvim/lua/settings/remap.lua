--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes --
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- NORMAL Mode --
local save_cmd = "<cmd>w!<CR>"
local keys = {
  -- General --
  { "n", "<C-s>", save_cmd, { desc = 'save on Ctrl-s' } },
  { "n", "<C-S>", save_cmd, { desc = 'save on Ctrl-S' } },
  { {"n", "v"}, "<leader>y", [["+y]], { desc = '[y]ank to clipboard' } },
  { "n", "<leader>Y", [["+Y]], { desc = '[Y]ank full line to clipboard' } },
  { "n", "J", "mzJ`z" },                -- concat the next line at the end of the current line without moving the cursor
  { "n", "<C-d>", "<C-d>zz" },          -- move down but stay at the middle of the screen
}

  -- Windows Management --
local window_management_keys = {
  { { 'n', 'v' }, '<leader>wqa', ':qa<CR>', { remap = true, desc = '[w]indow [q]uit [a]ll' } },
  { { 'n', 'v' }, '<leader>wq!', ':qa!<CR>', { remap = true, desc = '[w]indow [q]uit all[!]' } },
  { { 'n', 'v' }, '<leader>wqw', ':wq<CR>', { remap = true, desc = '[w]indow [q]uit and [w]rite' } },
  { { 'n', 'v' }, '<leader>wc', ':q<CR>', { remap = true, desc = '[w]indow [c]lose' } },
  { { 'n', 'v' }, '<leader>wd', '<C-w>o', { remap = true, desc = '[w]indow [d]elete all other window' } },
  { { 'n', 'v' }, '<leader>wv', ':vsplit<CR>', { remap = true, desc = '[w]indow [v]ertical split' } },
  { { 'n', 'v' }, '<leader>ws', ':split<CR>', { remap = true, desc = '[w]indow horizontal [s]plit' } },
  { { 'n', 'v' }, '<leader>w|', ':vsplit<CR>', { remap = true, desc = '[w]indow vertical split  |' } },
  { { 'n', 'v' }, '<leader>w-', ':split<CR>', { remap = true, desc = '[w]indow horizontal split --' } },
  { { 'n', 'v' }, '<leader>w=', "<C-w>=", { remap = true, desc = 'balance [w]indow size [=]' } },
  { { 'n', 'v' }, '<leader>wh', "<C-w>h", { remap = true, desc = 'move to left [w]indow' } },
  { { 'n', 'v' }, '<leader>wj', "<C-w>j", { remap = true, desc = 'move to down [w]indow' } },
  { { 'n', 'v' }, '<leader>wk', "<C-w>k", { remap = true, desc = 'move to up [w]indow' } },
  { { 'n', 'v' }, '<leader>wl', "<C-w>l", { remap = true, desc = 'move to right [w]indow' } },
  { {'n', 'v'}, "<leader>ww", "<C-W>p", { remap = true, desc = "[w]indow move to previous [w]indow" } },
}

for _, key in pairs(keys) do
  vim.keymap.set(key[1], key[2], key[3], key[4])
end

for _, key in pairs(window_management_keys) do
  vim.keymap.set(key[1], key[2], key[3], key[4])
end

for i = 1, 9, 1 do
  vim.keymap.set(
  {'n', 'v'},
  "<leader>w" ..  i,
  "<cmd>exe " .. i .. " . 'winc w'<CR>",
  { remap = true, desc = "go to [w]indow [" .. i .. "]"})
end

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
