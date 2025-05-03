local sbar = require("sketchybar")
local paths = require("config.paths")

local keyboard_mode = sbar.add("item", "keyboard_mode", {
	position = "center",
	click_script = paths.plugin_dir .. "keyboard.sh swapped",
	label = "",
})

local function state_to_label(state)
	if state == "qwerty" then
		return "󰌌"
	elseif state == "graphite" then
		return ""
	end
end

sbar.add("event", "keyboard_state_update")

sbar.exec(paths.plugin_dir .. "keyboard.sh state")

keyboard_mode:subscribe("keyboard_state_update", function(env)
	keyboard_mode:set({
		label = { string = state_to_label(env.KEYBOARD_STATE) },
	})
end)
