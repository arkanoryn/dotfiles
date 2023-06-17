vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NORMAL Mode
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'open Ex' })
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = '[y]ank to clipboard' })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = '[Y]ank full line to clipboard' })
vim.keymap.set("n", "Q", "<nop>")                -- no recordings
vim.keymap.set("n", "J", "mzJ`z")                -- concat the next line at the end of the current line without moving the cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")          -- move down but stay at the middle of the screen
vim.keymap.set("n", "<C-u>", "<C-u>zz")          -- move up but stay at the middle of the screen

-- VISUAL & SELECT Mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")     -- move down the selected lines in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")     -- move up the selected lines in visual mode

-- VISUAL Mode
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = '[p]aste without overriding yank' })

-- INTERACTIVE Mode
vim.keymap.set("i", "<C-c>", "<Esc>")            -- CTRL-c behaves has Esc
