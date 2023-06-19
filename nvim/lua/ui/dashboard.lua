return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
        local dashboard = require("alpha.themes.dashboard").config

        return dashboard
    end,
}
