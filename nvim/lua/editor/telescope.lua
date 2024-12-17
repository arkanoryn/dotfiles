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

    opts = function ()
      local actions = require("telescope.actions")

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
        },
        -- TODO: check the mappings example from below and see what would fit me
        -- mappings = {
        --   i = {
        --     ["<C-n>"] = actions.cycle_history_next,
        --     ["<C-p>"] = actions.cycle_history_prev,

        --     ["<C-j>"] = actions.move_selection_next,
        --     ["<C-k>"] = actions.move_selection_previous,

        --     ["<C-c>"] = actions.close,

        --     ["<Down>"] = actions.move_selection_next,
        --     ["<Up>"] = actions.move_selection_previous,

        --     ["<CR>"] = actions.select_default,
        --     ["<C-x>"] = actions.select_horizontal,
        --     ["<C-v>"] = actions.select_vertical,
        --     ["<C-t>"] = actions.select_tab,

        --     ["<C-u>"] = actions.preview_scrolling_up,
        --     ["<C-d>"] = actions.preview_scrolling_down,

        --     ["<PageUp>"] = actions.results_scrolling_up,
        --     ["<PageDown>"] = actions.results_scrolling_down,

        --     ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        --     ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        --     ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        --     ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        --     ["<C-l>"] = actions.complete_tag,
        --     ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
        --   },

        --   n = {
        --     ["<esc>"] = actions.close,
        --     ["<CR>"] = actions.select_default,
        --     ["<C-x>"] = actions.select_horizontal,
        --     ["<C-v>"] = actions.select_vertical,
        --     ["<C-t>"] = actions.select_tab,

        --     ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        --     ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        --     ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        --     ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        --     ["j"] = actions.move_selection_next,
        --     ["k"] = actions.move_selection_previous,
        --     ["H"] = actions.move_to_top,
        --     ["M"] = actions.move_to_middle,
        --     ["L"] = actions.move_to_bottom,

        --     ["<Down>"] = actions.move_selection_next,
        --     ["<Up>"] = actions.move_selection_previous,
        --     ["gg"] = actions.move_to_top,
        --     ["G"] = actions.move_to_bottom,

        --     ["<C-u>"] = actions.preview_scrolling_up,
        --     ["<C-d>"] = actions.preview_scrolling_down,

        --     ["<PageUp>"] = actions.results_scrolling_up,
        --     ["<PageDown>"] = actions.results_scrolling_down,

        --     ["?"] = actions.which_key,
        --   },
        -- },
      }
    end,

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

        -- Git
        { "<leader>gb", "<cmd>Telescope git_bcommits<CR>", desc = "[b]uffer's commits" },
        { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "[c]ommits" },
        { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "[s]tatus" },

        -- Helpers
        { "<leader>hk", builtin.keymaps, desc = "[k]eymaps" },
      }
    end,
  },
}
