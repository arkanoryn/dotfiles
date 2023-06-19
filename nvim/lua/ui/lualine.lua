-- Setup LuaLine: the bar at the bottom of each buffer
local Util = require('settings.util')

return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",

  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      component_separators = { left = '', right = ''}, -- other options: '|'
      section_separators = { left = '', right = ''},
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        "branch",
        {
          "diff",
          symbols = {
            added = Util.icons.git.added,
            modified = Util.icons.git.modified,
            removed = Util.icons.git.removed,
          },
        },
      },
      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = Util.icons.diagnostics.Error,
            warn = Util.icons.diagnostics.Warn,
            info = Util.icons.diagnostics.Info,
            hint = Util.icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        -- get path?
        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        -- stylua: ignore
        -- {
        --   function() return require("nvim-navic").get_location() end,
        --   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
        -- },
      },
      lualine_x = {
        -- stylua: ignore
        -- TODO:
        -- {
        --   function() return require("noice").api.status.command.get() end,
        --   cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
        --   color = Util.fg("Statement"),
        -- },
        -- -- stylua: ignore
        -- {
        --   function() return require("noice").api.status.mode.get() end,
        --   cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        --   color = Util.fg("Constant"),
        -- },
        -- -- stylua: ignore
        { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
      },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        function()
          return " " .. os.date("%R")
        end,
      },
    },
  },
}
