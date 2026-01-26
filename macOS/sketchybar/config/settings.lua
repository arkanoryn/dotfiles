local fonts = {
	sf_pro = {
		text = "SF Pro", -- Used for text
		numbers = "SF Mono", -- Used for numbers
		-- Unified font style map
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Semibold",
			["Bold"] = "Bold",
			["Heavy"] = "Heavy",
			["Black"] = "Black",
		},
	},
	fira_code = {
		text = "FiraCode Nerd Font", -- Used for text
		numbers = "FiraCode Nerd Font Mono", -- Used for numbers
		size = 20,
		style_map = {
			["Regular"] = "Retina",
			["Semibold"] = "Medium",
			["Bold"] = "SemiBold",
			["Heavy"] = "Bold",
			["Black"] = "ExtraBold",
		},
	},
}

return {
	paddings = 3,
	group_paddings = 5,
	icons = "sf-symbols", -- alternatively available: NerdFont
	fonts = fonts,
	default_font = fonts.fira_code,
}
