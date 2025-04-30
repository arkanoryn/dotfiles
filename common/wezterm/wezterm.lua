local wezterm = require("wezterm")

-- wezterm.mux.spawn_window { width = 60, height = 30 }

return {
	-- run fish
	default_prog = { "/opt/homebrew/bin/fish", "-l" },

	-- Appareance
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 16.0,
	font = wezterm.font("FiraCode Nerd Font", { weight = "Medium" }),

	macos_window_background_blur = 30,
	initial_cols = 120,
	initial_rows = 40,
	window_background_opacity = 0.8,
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	adjust_window_size_when_changing_font_size = false,

	-- Keybindings / shortcuts
	keys = {
		{
			key = "/",
			mods = "CTRL",
			action = wezterm.action.QuickSelect,
		},
		{
			key = "k",
			mods = "CMD",
			action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CMD",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
}
