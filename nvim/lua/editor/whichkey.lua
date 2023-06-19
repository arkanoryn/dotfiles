-- Setup for which key
-- A plugin to display a helper popup bar at the bottom of the page for the
-- pending key stroke

return {
  'folke/which-key.nvim',
  event = "VeryLazy",

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
      ["<leader>b"] = { name = "+[b]uffer" },
      ["<leader>c"] = { name = "?[c]ode" },
      -- ["<leader>d"] = { name = "tbd" },
      -- ["<leader>e"] = { name = "tbd" },
      ["<leader>f"] = { name = "?[f]ile" },
      ["<leader>g"] = { name = "?[g]it" },
      ["<leader>h"] = { name = "?[h]elp" },
      ["<leader>i"] = { name = "?[i]nsert" },
      -- ["<leader>j"] = { name = "tbd" },
      -- ["<leader>k"] = { name = "tbd" },
      -- ["<leader>l"] = { name = "tbd" },
      ["<leader>m"] = { name = "+[m]essages" }, -- notifications
      ["<leader>n"] = { name = "?[n]otes" },
      ["<leader>o"] = { name = "?[o]pen" },
      ["<leader>p"] = { name = "?[p]roject" },
      ["<leader>q"] = { name = "?[q]uit" },
      -- ["<leader>r"] = { name = "tbd" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>t"] = { name = "?[t]oggle? / tab? / todo?" },
      -- ["<leader>u"] = { name = "tbd" },
      -- ["<leader>v"] = { name = "tbd" },
      ["<leader>w"] = { name = "+[w]indow" },
      ["<leader>x"] = { name = "?to e[x]ecute (todos)" },
      -- ["<leader>y"] = { name = "tbd" },
      -- ["<leader>z"] = { name = "tbd" },
    }
    require('which-key').setup(opts)
    require('which-key').register(folders, {})
  end
}

