return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = 'ToggleTerm',

  opts = {
    ft = "lazyterm",
    -- size = { width = 0.9, height = 0.9 },
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 20,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
      width = 120,
      height = 30,
    },
  },

  keys = function ()
    return {
      { "<leader>ct", "<cmd>ToggleTerm<CR>", desc = "[t]erminal" },
    }
  end
}
