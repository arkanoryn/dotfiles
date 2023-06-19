local M = {}

function M.fg(name)
  ---@type {foreground?:number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

M.icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = "󱨇 ",
    removed = " ",
  },
  kind = {
    Text = "󱩼",
    Method = "m",
    Function = "󰊕",
    Constructor = "",
    Field = "",
    Variable = "󰆧",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "󱪗",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "󰬁",
  }
  -- find more here: https://www.nerdfonts.com/cheat-sheet
}

return M
