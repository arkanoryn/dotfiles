-- Setup for which key
-- A plugin to display a helper popup bar at the bottom of the page for the
-- pending key stroke

return {
  'folke/which-key.nvim',

  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 100
  end,

  opts = {
    key_labels = {
      -- override the label used to display some keys.
      -- It doesn't effect WK in any other way.
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
  },

  config = function (_, opts)
    local folders = {
      -- ["<leader>a"] = { name = "+action?" },
      ["<leader>b"] = { name = "?buffer" },
      ["<leader>c"] = { name = "?code" },
      -- ["<leader>d"] = { name = "tbd" },
      -- ["<leader>e"] = { name = "tbd" },
      ["<leader>f"] = { name = "?file" },
      ["<leader>g"] = { name = "?git" },
      ["<leader>h"] = { name = "?help" },
      ["<leader>i"] = { name = "?insert" },
      -- ["<leader>j"] = { name = "tbd" },
      -- ["<leader>k"] = { name = "tbd" },
      -- ["<leader>l"] = { name = "tbd" },
      -- ["<leader>m"] = { name = "tbd" },
      ["<leader>n"] = { name = "?notes" },
      ["<leader>o"] = { name = "?open" },
      ["<leader>p"] = { name = "?project" },
      ["<leader>q"] = { name = "?quit" },
      -- ["<leader>r"] = { name = "tbd" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>t"] = { name = "?toggle? / tab?" },
      -- ["<leader>u"] = { name = "tbd" },
      -- ["<leader>v"] = { name = "tbd" },
      ["<leader>w"] = { name = "+window" },
      -- ["<leader>x"] = { name = "tbd" },
      -- ["<leader>y"] = { name = "tbd" },
      -- ["<leader>z"] = { name = "tbd" },
    }
    require('which-key').setup(opts)
    require('which-key').register(folders, {})
  end
}

