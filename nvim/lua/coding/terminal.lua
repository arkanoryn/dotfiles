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

  config = function (_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "double",
        width = 180,
        height = 50,
      },
      -- function to run on opening the terminal
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      end,
      -- function to run on closing the terminal
      on_close = function(_)
        vim.cmd("startinsert!")
      end,
    })

    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end
  end,

  keys = {
    { "<leader>ct", "<cmd>ToggleTerm<CR>", desc = "[t]erminal" },
    { "<leader>tef", "<cmd>ToggleTerm<CR>", desc = "[f]loat" },
    {"<leader>teh", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "t[e]rminal [h]orizontal" },
    { "<leader>tev", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "t[e]rmimal [v]ertical" },
    { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", {noremap = true, silent = true, desc = "lazy[g]it"} },
  }
}
