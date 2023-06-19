local noice = {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
    },
  },

  -- TODO: review mapping below
  -- stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>ml", function() require("noice").cmd("last") end, desc = "[m]essages [l]ast" },
    { "<leader>mh", function() require("noice").cmd("history") end, desc = "[m]essages [h]istory" },
    { "<leader>ma", function() require("noice").cmd("all") end, desc = "[m]essages [a]ll" },
    { "<leader>mc", function() require("noice").cmd("dismiss") end, desc = "[m]essages [c]lose all" },
    { "<c-f>",
      function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
      silent = true,
      expr = true,
      desc = "Scroll forward (messages)",
      mode = {"i", "n", "s"},
    },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
      silent = true,
      expr = true,
      desc = "Scroll backward (messages)",
      mode = {"i", "n", "s"},
    },
  },
}

local notify = {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  keys = {
    {
      "<leader>md",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "[m]essages [d]ismiss all notifications",
    },
  },
  opts = {
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  },
}

return {
  notify,
  noice,
}

