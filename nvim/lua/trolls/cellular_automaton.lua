return {
  'Eandrju/cellular-automaton.nvim',
  cmd = 'CellularAutomaton',
  keys = {
    { "<leader>zt",
      "<cmd>CellularAutomaton make_it_rain<CR>",
      desc = "[z] make it [r]ain" },
    { "<leader>zg",
      "<cmd>CellularAutomaton game_of_life<CR>",
      desc = "[z] [g]ame of life" }
  },
}
