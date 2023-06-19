-- Setup Buffer Line

local bufferline_plugin = {
  "akinsho/bufferline.nvim",
  dependencies = { 'echasnovski/mini.bufremove' },
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "[b]uffer [p]in toggle" },
    { "<leader>tp", "<Cmd>BufferLineTogglePin<CR>", desc = "[t]oggle [b]uffer pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "delete [b]uffers non-[P]inned" },
  },
  opts = {
    options = {
      -- stylua: ignore
      close_command = function(n) require("mini.bufremove").delete(n, false) end,
      -- stylua: ignore
      right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      diagnostics_indicator = function(_, _, diag)
        local icons = require("settings.util").icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  },
}

local scope_plugin = {
  "tiagovla/scope.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function (_, opts)
    require("scope").setup(opts)
    require("telescope").load_extension("scope")
  end
}

return {
  bufferline_plugin,
  scope_plugin,
}
