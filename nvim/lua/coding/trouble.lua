
return {
  'folke/trouble.nvim',
  event = "VeryLazy",
 dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ato", vim.cmd.TroubleToggle, desc = "[a]ction: [t]rouble [n]ext quickfix" },
    { "<leader>atn", vim.cmd.cprev, desc = "[a]ction: [t]rouble [n]ext quickfix" },
    { "<leader>atp", vim.cmd.cprev, desc = "[a]ction: [t]rouble [p]revious quickfix" },
    { "<leader>att", "<cmd>TroubleToggle<cr>", desc = "[a]ction: [t]rouble [t]oggle" },
    { "<leader>atw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "[a]ction: [t]rouble toggle [w]orkspace_diagnostics" },
    { "<leader>atd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "[a]ction: [t]rouble toggle [d]ocument_diagnostics" },
    { "<leader>atq", "<cmd>TroubleToggle quickfix<cr>", desc = "[a]ction: [t]rouble toggle [q]uickfix" },
    { "<leader>atl", "<cmd>TroubleToggle loclist<cr>", desc = "[a]ction: [t]rouble toggle [l]oclist" },
    { "<leader>ats", "<cmd>TroubleToggle lsp_references<cr>", desc = "[a]ction: [t]rouble l[s]p references" },
  },
}
