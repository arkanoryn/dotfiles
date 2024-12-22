local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	height = 38,
	color = colors.bar.bg,
	border_color = colors.bar.border,
	shadow = true,
	sticky = true,
	padding_right = 10,
	padding_left = 10,
	margin = 8,
	y_offset = 4,
	corner_radius = 12,
	blur_radius = 20,
	topmost = "window",
})
