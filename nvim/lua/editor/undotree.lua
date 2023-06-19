undo_cmd = vim.cmd.UndotreeToggle

return {
  'mbbill/undotree',
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>au", undo_cmd, desc = "[a]ction: [u]ndo tree toggle" },
    { "<leader>tu", undo_cmd, desc = "[t]oggle [u]ndo tree" },
    { "<leader>su", undo_cmd, desc = "[s]earch [u]ndo tree" },
  },
}
