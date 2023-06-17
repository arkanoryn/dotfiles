-- All Plugins required to manage LSP

-- local lsp = {
--   "neovim/nvim-lspconfig",
--   event = { "BufReadPre", "BufNewFile" },
--   dependencies = {
--     { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
--     { "folke/neodev.nvim", opts = {} },
--     "mason.nvim",
--     "williamboman/mason-lspconfig.nvim",
--     -- TODO use
--     -- {
--     --   "hrsh7th/cmp-nvim-lsp",
--     --   cond = function()
--     --     return require("lazyvim.util").has("nvim-cmp")
--     --   end,
--     -- },
--   },
--   ---@class PluginLspOpts
--   opts = {
--     -- options for vim.diagnostic.config()
--     diagnostics = {
--       underline = true,
--       update_in_insert = false,
--       virtual_text = {
--         spacing = 4,
--         source = "if_many",
--         prefix = "●",
--         -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
--         -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
--         -- prefix = "icons",
--       },
--       severity_sort = true,
--     },
--     -- add any global capabilities here
--     capabilities = {},
--     -- Automatically format on save
--     autoformat = true,
--     -- Enable this to show formatters used in a notification
--     -- Useful for debugging formatter issues
--     format_notify = false,
--     -- options for vim.lsp.buf.format
--     -- `bufnr` and `filter` is handled by the LazyVim formatter,
--     -- but can be also overridden when specified
--     format = {
--       formatting_options = nil,
--       timeout_ms = nil,
--     },
--   },
-- }
-- 
-- local formatter = {
--   "jose-elias-alvarez/null-ls.nvim",
--   event = { "BufReadPre", "BufNewFile" },
--   dependencies = { "mason.nvim" },
--   opts = function()
--     local nls = require("null-ls")
--     return {
--       root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
--       sources = {
--         nls.builtins.formatting.stylua,
--         -- nls.builtins.diagnostics.flake8,
--       },
--     }
--   end,
-- }
-- 
local mason = {
  "williamboman/mason.nvim",
  cmd = "Mason",
  -- keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  opts = {
    ensure_installed = {
      "stylua",
      "shfmt",
      -- "flake8",
    },
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    require("mason").setup(opts)

    local mr = require("mason-registry")
    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end
    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}

return {
  lsp,
  --formatter,
  mason,
}
