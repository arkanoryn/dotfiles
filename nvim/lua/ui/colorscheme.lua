return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins

  opts = {
    background = {
      light = "latte",
      dark = "Macchiato",
    },
    integrations = {
      alpha = true,
      cmp = true,
      gitsigns = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      lsp_trouble = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true },
      noice = true,
      notify = true,
      nvimtree = true,
      telescope = true,
      treesitter = true,
      which_key = true,
    },
    dim_inactive = {
      enabled = true,
    },
  },

  config = function(_, opts)
    require("catppuccin").setup(opts)

    vim.cmd.colorscheme "catppuccin" -- load the colorscheme here
  end
}
