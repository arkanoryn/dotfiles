local wezterm = require("wezterm")
local act = wezterm.action

return {
	{
		key = "/",
		mods = "CTRL",
		action = act.QuickSelect,
	},
	{
		key = "k",
		mods = "CMD",
		action = act.ClearScrollback("ScrollbackAndViewport"),
	},
	-- This will create a new split
	{
		key = "s",
		mods = "ALT",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "ALT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	-- Rotate the panes
	{
		key = "u",
		mods = "ALT",
		action = act.RotatePanes("CounterClockwise"),
	},
	{ key = "i", mods = "ALT", action = act.RotatePanes("Clockwise") },
	-- swap current pane with target
	{
		key = "b",
		mods = "ALT",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	-- Jump to pane
	{
		key = "g",
		mods = "ALT",
		action = act.PaneSelect({
			alphabet = "gjklfdsarueiwopq",
		}),
	},

	-- WORKSPACES

	{
		key = "i",
		mods = "ALT",
		action = act.SwitchToWorkspace({
			name = "dotfiles",
		}),
	},
	{
		key = "u",
		mods = "ALT",
		action = act.SwitchToWorkspace({
			name = "programming",
		}),
	},
	{
		key = "o",
		mods = "ALT",
		action = act.SwitchToWorkspace({
			name = "move",
		}),
	},
	{
		key = "t",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	{
		key = "r",
		mods = "ALT",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
}
