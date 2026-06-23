local sbar = require("sketchybar")
local paths = require("config.paths")

local layout_script = paths.aerospace_script_dir .. "layout_toggle.sh"

local aerospace_layout = sbar.add("item", "aerospace_layout", {
	position = "center",
	click_script = layout_script .. " toggle",
	icon = { drawing = false },
	label = { string = "▦" },
})

local function layout_to_icon(layout)
	if layout == "accordion" then
		return "☰"
	elseif layout == "tiles" then
		return "▦"
	end

	return "▦"
end

sbar.add("event", "aerospace_layout_update")

aerospace_layout:subscribe("aerospace_layout_update", function(env)
	aerospace_layout:set({
		label = { string = layout_to_icon(env.LAYOUT_STATE) },
	})
end)

sbar.exec(layout_script .. " state")
sbar.exec(layout_script .. " sync")

return {
	set = function(properties)
		aerospace_layout:set(properties)
	end,
}
