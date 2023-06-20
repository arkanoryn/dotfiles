local check_backspace = function()
  local col = vim.fn.col '.' - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
end

local luasnip_plugin = {
  'L3MON4D3/LuaSnip',
  event = { 'BufReadPost', 'BufNewFile' },
  build = (not jit.os:find 'Windows') and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp" or nil,

  dependencies = {
    'rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  opts = {
    history = true,
    delete_check_events = 'TextChanged',
  },

  -- stylua: ignore
  keys = {
    {
      '<tab>',
      function()
        return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
      end,
      expr = true, silent = true, mode = 'i',
    },
    { '<tab>', function() require('luasnip').jump(1) end, mode = 's' },
    { '<s-tab>', function() require('luasnip').jump(-1) end, mode = { 'i', 's' } },
  },
}

return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = { 'BufReadPost', 'BufNewFile' },

  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp', event = { 'BufReadPost', 'BufNewFile' } },
    luasnip_plugin,
    { 'hrsh7th/cmp-buffer', event = { 'BufReadPost', 'BufNewFile' } },
    { 'hrsh7th/cmp-path', event = { 'BufReadPost', 'BufNewFile' } },
    { 'hrsh7th/cmp-cmdline', event = { 'BufReadPost', 'BufNewFile' } },
    { 'hrsh7th/cmp-nvim-lua', event = { 'BufReadPost', 'BufNewFile' } },
    { 'saadparwaiz1/cmp_luasnip', event = { 'BufReadPost', 'BufNewFile' } },
  },

  opts = function()
    vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    return {
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<c-p>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<S-CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        -- power TAB and S-TAB
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip and luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif check_backspace() then
            fallback()
          else
            fallback()
          end
        end, {
          'i',
          's',
        }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          'i',
          's',
        }),
      },

      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format('%s', require('settings.util').icons.kind[vim_item.kind])

          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]

          return vim_item
        end,
      },

      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'cmdline' },
      },

      window = {
        documentation = {
          border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        },
      },

      experimental = {
        ghost_text = {
          hl_group = 'CmpGhostText',
        },
      },
    }
  end,
}
