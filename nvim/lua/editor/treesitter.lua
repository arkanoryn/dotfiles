-- Setup treesitter: a plugin to Highlight, edit, and navigate code

return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    -- 'nvim-treesitter/nvim-treesitter-textobjects',
    "p00f/nvim-ts-rainbow",
  },
  build = ':TSUpdate',
  event = { "BufReadPost", "BufNewFile" },

  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "vim",
      "vimdoc",
      "yaml",
    },
    auto_install = true,
    context_commentstring = {
      enable = true,
    },
    rainbow = {
      enable = true,
      disable = { }, -- list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
      -- colors = {}, -- table of hex strings
      -- termcolors = {} -- table of colour name strings
    },
  },

  --- @param opts TSConfig
  config = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      ---@type table<string, boolean>
      local added = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if added[lang] then
          return false
        end
        added[lang] = true
        return true
      end, opts.ensure_installed)
    end
    require("nvim-treesitter.configs").setup(opts)
  end,
}

  -- config = function ()
  --   -- See `:help nvim-treesitter`
  --   require('nvim-treesitter.configs').setup {
  --     -- Add languages to be installed here that you want installed for treesitter
  --
  --     highlight = { enable = true },
  --     indent = { enable = true },
  --     incremental_selection = {
  --       enable = true,
  --       keymaps = {
  --         init_selection = '<c-space>',
  --         node_incremental = '<c-space>',
  --         scope_incremental = '<c-s>',
  --         node_decremental = '<M-space>',
  --       },
  --     },
  --     textobjects = {
  --       select = {
  --         enable = true,
  --         lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
  --         keymaps = {
  --           -- You can use the capture groups defined in textobjects.scm
  --           ['aa'] = '@parameter.outer',
  --           ['ia'] = '@parameter.inner',
  --           ['af'] = '@function.outer',
  --           ['if'] = '@function.inner',
  --           ['ac'] = '@class.outer',
  --           ['ic'] = '@class.inner',
  --         },
  --       },
  --       move = {
  --         enable = true,
  --         set_jumps = true, -- whether to set jumps in the jumplist
  --         goto_next_start = {
  --           [']m'] = '@function.outer',
  --           [']]'] = '@class.outer',
  --         },
  --         goto_next_end = {
  --           [']M'] = '@function.outer',
  --           [']['] = '@class.outer',
  --         },
  --         goto_previous_start = {
  --           ['[m'] = '@function.outer',
  --           ['[['] = '@class.outer',
  --         },
  --         goto_previous_end = {
  --           ['[M'] = '@function.outer',
  --           ['[]'] = '@class.outer',
  --         },
  --       },
  --       swap = {
  --         enable = true,
  --         swap_next = {
  --           ['<leader>a'] = '@parameter.inner',
  --         },
  --         swap_previous = {
  --           ['<leader>A'] = '@parameter.inner',
  --         },
  --       },
  --     },
  --   }
  -- end
