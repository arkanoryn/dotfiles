local colors = require("config.colors")
local sbar = require("sketchybar")

-- valid MODES are: MAIN, SELECTION, WORKSPACE, LAYOUT

local modes = { main = "MAIN", selection = "SELECTION", workspace = "WORKSPACE", layout = "LAYOUT" }
local current_mode = modes.main

sbar.add("event", "aerospace_mode_change")

local aerospace_mode = sbar.add("item", "aerospace_mode", {
	updates = true,
	position = "center",
	label = {
		string = current_mode,
	},
})

local function update_item(config)
	aerospace_mode:set({
		label = {
			color = config.font_color,
			string = current_mode,
		},
	})
	sbar.bar({ color = config.background })
end

local function change_color_by_mode(env)
	current_mode = env.MODE_CHANGE

	if current_mode == modes.main then
		update_item(colors.aerospace.modes.main)
	elseif current_mode == modes.selection then
		update_item(colors.aerospace.modes.selection)
	elseif current_mode == modes.workspace then
		update_item(colors.aerospace.modes.workspace)
	elseif current_mode == modes.layout then
		update_item(colors.aerospace.modes.layout)
	end
end

aerospace_mode:subscribe({ "aerospace_mode_change" }, change_color_by_mode)

sbar.trigger("aerospace_mode_change", { MODE_CHANGE = current_mode })

return {
	set = function(properties)
		aerospace_mode:set(properties)
	end,
}
