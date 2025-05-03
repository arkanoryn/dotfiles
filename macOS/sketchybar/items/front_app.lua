local colors = require("config.colors")
local app_icons = require("config.app_icons")

local front_app = sbar.add("item", {
	icon = {
		drawing = true,
		color = colors.front_app.icon,
		font = "sketchybar-app-font:Regular:14.0",
	},
	label = {
		color = colors.front_app.text,
		font = {
			style = "Black",
			size = 18.0,
		},
	},
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({
		icon = {
			string = app_icons[env.INFO],
		},
		label = {
			string = env.INFO,
		},
	})
end)

return {
	set = function(properties)
		front_app:set(properties)
	end,
}
