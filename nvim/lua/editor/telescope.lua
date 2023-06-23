-- Setup for Telescope: a Fuzzy Finder (files, lsp, etc)

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",

    dependencies = {
      "nvim-lua/plenary.nvim",

      {
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        event = "VeryLazy",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
    },

    keys = function()
      local builtin = require("telescope.builtin")

      local fzf_current_buffer = function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end

      return {
        -- General
        { "<leader><space>", builtin.find_files, desc = "Find file" },
        { "<C-p>", builtin.find_files, desc = "Find file", remap = true, mode = { "n", "v", "i" } },
        { "<leader>*", builtin.grep_string, desc = "Search current word" },
        { "<leader>/", builtin.live_grep, desc = "Search project" },

        -- Buffers
        { "<leader>bl", builtin.buffers, desc = "[l]ist" },
        { "<leader>b/", fzf_current_buffer, desc = "Fuzzily search in current buffer" },

        -- Code
        { "<leader>cx", vim.diagnostic.setloclist, desc = "open errors popup" },
        { "<leader>cX", vim.diagnostic.open_float, desc = "open errors list" },

        -- Helpers
        { "<leader>hk", builtin.keymaps, desc = "[k]eymaps" },
      }
    end,
  },
}
