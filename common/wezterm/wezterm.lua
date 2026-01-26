local wezterm = require("wezterm")
local keymaps = require("keys")
local mux = wezterm.mux

-- wezterm.mux.spawn_window { width = 60, height = 30 }
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = { "/opt/homebrew/bin/fish", "-l" }
	if cmd then
		args = cmd.args
	end

	-- Set a workspace for coding on a current project
	-- Top pane is for the editor, bottom pane is for the build tool
	local dotfiles_dir = wezterm.home_dir .. "/.dotfiles"
	local projects_dir = wezterm.home_dir .. "/projects"
	local move_dir = wezterm.home_dir .. "/projects/anynines/move"

	mux.spawn_window({
		workspace = "dotfiles",
		cwd = dotfiles_dir,
		args = args,
	})

	mux.spawn_window({
		workspace = "programming",
		cwd = projects_dir,
		args = args,
	})

	mux.spawn_window({
		workspace = "move",
		cwd = move_dir,
		args = args,
	})

	-- We want to startup in the coding workspace
	mux.set_active_workspace("programming")
end)

return {
	-- run fish
	default_prog = { "/opt/homebrew/bin/fish", "-l" },

	-- Appareance
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 14.0,
	font = wezterm.font("FiraCode Nerd Font", { weight = "Medium" }),

	macos_window_background_blur = 30,
	initial_cols = 120,
	initial_rows = 40,
	window_background_opacity = 0.9,
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	adjust_window_size_when_changing_font_size = false,

	-- Keybindings / shortcuts
	keys = keymaps,
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CMD",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
}
