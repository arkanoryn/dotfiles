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
  { "n", "<Esc>", "<cmd><Esc>:noh<CR>", { desc = 'save on Ctrl-s', silent = true } },
  { "n", "<C-s>", save_cmd, { desc = 'save on Ctrl-s' } },
  { "n", "<C-S>", save_cmd, { desc = 'save on Ctrl-S' } },
  { {"n", "v"}, "<leader>y", [["+y]], { desc = '[y]ank to clipboard' } },
  { "n", "<leader>Y", [["+Y]], { desc = '[Y]ank full line to clipboard' } },
  { "n", "J", "mzJ`z" },                -- concat the next line at the end of the current line without moving the cursor
  { "n", "<C-d>", "<C-d>zz" },          -- move down but stay at the middle of the screen
  { "x", "<leader>p", [["_dP]], { desc = '[p]aste without overriding yank' } },
  { "i", "<C-c>", "<Esc>" },            -- CTRL-c behaves has Esc
  -- Word Actions --
  ---- Remap for dealing with word wrap
  { 'n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
  { 'n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },

  { "v", "J", ":m '>+1<CR>gv=gv" },     -- move down the selected lines in visual mode
  { "v", "K", ":m '<-2<CR>gv=gv" },     -- move up the selected lines in visual mode
  { "v", "<A-j>", ":m '>+1<CR>gv=gv" },     -- move down the selected lines in visual mode
  { "v", "<A-k>", ":m '<-2<CR>gv=gv" },     -- move up the selected lines in visual mode
  { "v", "<A-down>", ":m '>+1<CR>gv=gv" },     -- move down the selected lines in visual mode
  { "v", "<A-up>", ":m '<-2<CR>gv=gv" },     -- move up the selected lines in visual mode

  ---- Move text up and down
  { "n", "<A-j>", "<Esc>:m .+1<CR>==", { desc = "move text down" } },
  { "n", "<A-k>", "<Esc>:m .-2<CR>==", { desc = "move text up" } },
  { "n", "<A-down>", "<Esc>:m .+1<CR>==", { desc = "move text down" } },
  { "n", "<A-up>", "<Esc>:m .-2<CR>==", { desc = "move text up" }  },
  { "i", "<A-down>", "<Esc>:m .+1<CR>==gi", { desc = "move text down" }  },
  { "i", "<A-up>", "<Esc>:m .-2<CR>==gi", { desc = "move text up" }  },

  { "n", "<leader>l", "<cmd>:Lazy<CR>", { desc = "open Lazy" } },

  -- Actions Management - <leader>a --

  -- Buffers Management - <leader>b --
  -- TODO:
  { "n", "<leader>b]", vim.cmd.bnext, { desc = "[b]uffer: next" } },
  { "n", "<leader>bn", vim.cmd.bnext, { desc = "[b]uffer: [n]ext" } },
  { { "n", "v", "i" }, "<A-n>", vim.cmd.bnext, { desc = "buffer: next" } },
  { "n", "<leader>b[", vim.cmd.bprevious, { desc = "[b]uffer: previous" } },
  { "n", "<leader>bN", vim.cmd.bprevious, { desc = "[b]uffer: previous [N]" } },
  { { "n", "v", "i" }, "<A-N>", vim.cmd.bprevious, { desc = "buffer: previous" } },
  { "n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "[b]uffer [d]elete" } },
  { "n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end, { desc = "[b]uffer [d]elete (Force)" } },
  -- switch to buffer / buffers list [see /lua/editor/telescope.lua]
  -- fuzzy search buffer [see /lua/editor/telescope.lua]
  -- new empty buffer
  -- rename buffer
  { "n", "<leader>bs", save_cmd, { desc = '[b]uffer: [s]ave' } },
  { "n", "<leader>bS", "<cmd>wa!<CR>", { desc = '[b]uffer: [s]ave all' } },
  { "n", "<leader>by", "<cmd>%y+<CR>", { desc = '[b]uffer: [y]ank' } },
  -- buffer's undo tree -- [see lua/editor/undotree.lua]
  -- hide buffer?

  -- Code Management - <leader>c --
  -- TODO:
  -- jump to [d]efinition
  -- jump to reference D
  -- eval? [e]
  -- eval & replace? [E]
  -- [f]ormat buffer / region
  -- find [i]mplementation
  { "n", "<leader>cw", "<cmd>:let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>", { desc = "[b]uffer: remove trailing [w]hitespaces", noremap = true } },
  { "n", "<leader>cW", function ()
    vim.cmd(':%s/\\s\\+$//e')
    vim.cmd(':%s/\\n\\{2,}/\\r\\r/e')
  end, { desc = '[b]uffer: remove trailing [W]hitelines', noremap = true } },
  -- [x] list errors -- see diagnostic
  -- list errors in [p]opup -- see diagnostic
  -- [n]ext error -- see diagnostic
  -- previous error [N] -- see diagnostic
  -- next error [ -- see diagnostic
  -- previous error ] -- see diagnostic

  -- Git Management -- <leader>g --
  -- see [/lua/coding/git.lua]
  -- switch branch
  -- blame
  -- create
  ---- branch
  ----commit
  ----fixup
  ----issue
  ----pr
  ----init repo
  ----clone repo
  -- clone
  -- file delete
  -- find ..,
  ---- commit
  ---- file
  ---- gitconfilefile
  ---- issue
  ---- PR
  -- fetch
  -- status
  -- Status popup
  -- buffer log
  -- revert hunk at point
  -- revert file
  -- stage hunk at point
  -- stage file
  -- time machine
  -- unstage file
  --

  -- Quit Management - <leader>q --
  -- TODO:
  -- restore last session
  -- restore session from files
  { { 'n', 'v' }, '<leader>qq', ':qa<CR>', { remap = true, desc = '[q]uit nVim' } },
  { { 'n', 'v' }, '<leader>qQ', ':qa!<CR>', { remap = true, desc = '[q]uit nVim without saving' } },
  -- restart and restore
  -- restart
  -- quick save current session
  -- save session to file

  -- Windows Management - <leader>w --
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

for i = 1, 9, 1 do
  vim.keymap.set(
  {'n', 'v'},
  "<leader>w" ..  i,
  "<cmd>exe " .. i .. " . 'winc w'<CR>",
  { remap = true, desc = "go to [w]indow [" .. i .. "]"})
end

for _, key in pairs(keys) do
  vim.keymap.set(key[1], key[2], key[3], key[4])
end
