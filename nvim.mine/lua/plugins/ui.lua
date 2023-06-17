local colorscheme = { 
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- load the colorscheme here
    vim.cmd.colorscheme 'catppuccin'
  end
}

local lualine = {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = false,
      theme = 'onedark',
      component_separators = '|',
      section_separators = '',
    },
  },
}

-- local filetree = {
--   "nvim-tree/nvim-tree.lua",
--   --  lazy = true,
--   version = "*",
--   dependencies = {
--     "nvim-tree/nvim-web-devicons",
--   },
--   cmd = "Neotree",
--   config = function()
--     require("nvim-tree").setup {
--       --       sort_by = "case_sensitive",
--       --       view = {
--       --         width = 30,
--       --       },
--       --       renderer = {
--       --         group_empty = true,
--       --       },
--       --       filters = {
--       --         dotfiles = true,
--       --       },
--     }
--   end,
--   keys = {
--     {
--       "<leader>fE",
--       function()
--         require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
--       end,
--       desc = "Explorer NeoTree (cwd)",
--     },
--   }
-- }

return {
  colorscheme, 
  lualine,
  -- filetree
}
