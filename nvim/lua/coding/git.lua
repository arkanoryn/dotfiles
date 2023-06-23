return {
  {
    "tpope/vim-fugitive",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "tpope/vim-rhubarb",
    cmd = "GBrowse"
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
        delay = 1000,
        ignore_whitespace = false,
      },

      numhl = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghp", gs.prev_hunk, "[p]revious Hunk")
        map("n", "<leader>ghn", gs.next_hunk, "[n]ext Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },

  keys = function ()
      return {
        { "<leader>tgb", "<cmd>:Gitsigns toggle_current_line_blame<CR>", { desc = "[g]it [b]lame line" } },
        { "<leader>tgs", "<cmd>:Gitsigns toggle_signs<CR>", { desc = "[g]it [s]ign column" } },
        { "<leader>tgl", "<cmd>Gitsigns toggle_linehl<CR>", { desc = "[g]it [l]ine highlight" } },
        { "<leader>tgn", "<cmd>Gitsigns toggle_numhl<CR>", { desc = "[g]it [n]number highlight" } },
        { "<leader>tgw", "<cmd>Gitsigns toogle_word_diff<CR>", { desc = "[g]it [w]ord difference" } },
      }
    end,
  }
}
