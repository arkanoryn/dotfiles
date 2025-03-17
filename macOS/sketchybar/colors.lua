--the following colors are the ones from catppuccin
local catppuccin = {
	rosewater = 0xfff5e0dc,
	flamingo = 0xfff2cdcd,
	pink = 0xfff5c2e7,
	mauve = 0xffcba6f7,
	red = 0xfff38ba8,
	maroon = 0xffeba0ac,
	peach = 0xfffab387,
	yellow = 0xfff9e2af,
	green = 0xffa6e3a1,
	teal = 0xff94e2d5,
	sky = 0xff89dceb,
	sapphire = 0xff74c7ec,
	blue = 0xff89b4fa,
	lavender = 0xffb4befe,
	text = {
		default = 0xffcdd6f4,
		sub0 = 0xffa6adc8,
		sub1 = 0xffbac2de,
		overlay0 = 0xff6c7086,
		overlay1 = 0xff7f849c,
		overlay2 = 0xff9399b2,
	},
	backgrounds = {
		surface0 = 0xff313244,
		surface1 = 0xff45475a,
		surface2 = 0xff585b70,
		base = 0xff1e1e2e,
		mantle = 0xff181825,
		crust = 0xff11111b,
	},
}

local primary = catppuccin.yellow
local success = catppuccin.green
local warning = catppuccin.yellow
local error = catppuccin.maroon

local text = {
	default = catppuccin.text.default,
	inactive = catppuccin.text.overlay0,
}

local front_app = {
	icon = primary,
	text = text.inactive,
}

local network = {
	upload = success,
	download = error,
}

local background = {
	main = catppuccin.backgrounds.base,
	active = catppuccin.backgrounds.surface0,
	inactive = catppuccin.backgrounds.crust,
}

local apple = {
	icon = primary,
	text = text.default,
}

local bar = {
	bg = background.main,
	border = background.active,
}

local popup = {
	bg = bar.bg,
	border = bar.border,
}

local aerospace = {
	workspaces = {
		active = {
			background = background.active,
			icon = text.default,
			border = success,
			highlight = success,
		},
		inactive = {
			background = background.inactive,
			icon = text.inactive,
			border = warning,
		},
	},
	modes = {
		main = {
			background = background.active,
			font_color = text.default,
		},
		selection = {
			background = catppuccin.teal,
			font_color = text.inactive,
		},
		workspace = {
			background = catppuccin.mauve,
			font_color = text.inactive,
		},
		layout = {
			background = catppuccin.lavender,
			font_color = text.inactive,
		},
	},
}

local volume = {
	icon = text.default,
	slider = {
		active = primary,
		inactive = text.inactive,
	},
}

return {
	aerospace = aerospace,
	apple = apple,
	bar = bar,
	front_app = front_app,
	network = network,
	popup = popup,
	transparent = 0x00000000,
	volume = volume,
	white = 0xffcad3f5,
}
