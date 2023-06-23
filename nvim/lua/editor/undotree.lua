undo_cmd = vim.cmd.UndotreeToggle

return {
  'mbbill/undotree',
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>au", undo_cmd, desc = "[u]ndo tree toggle" },
    { "<leader>tu", undo_cmd, desc = "[u]ndo tree toggle" },
    { "<leader>su", undo_cmd, desc = "[u]ndo tree toggle" },
    { "<leader>eu", undo_cmd, desc = "[u]ndo tree toggle" },
  },
}
