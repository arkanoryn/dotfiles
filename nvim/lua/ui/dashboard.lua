local opts = function()
    local dashboard = require("alpha.themes.dashboard").config

    return dashboard
end

return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = opts,
}
