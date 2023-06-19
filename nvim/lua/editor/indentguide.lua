local blank_lines = {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- char = "▏",
    char = "╎",
    filetype_exclude = {
      "help",
      "alpha",
      "dashboard",
      "neo-tree",
      "trouble",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
    },
    show_trailing_blankline_indent = true,
    show_current_context = true,
    show_current_context_start = true,
  },
}

-- active indent guide and indent text objects
local animation = {
  "echasnovski/mini.indentscope",
  version = false, -- wait till new 0.7.0 release to put it back on semver
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    symbol = "╎",
    options = { try_as_border = true },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}

return {
  blank_lines,
  animation,
}
