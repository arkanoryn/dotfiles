local colors = require("colors")
local sbar = require("sketchybar")
local width = 50

local function formatBytes(bytes)
	if bytes == 0 then
		return "0b"
	end

	local k = 1024
	local dm = 1
	local sizes = { "b", "kb", "mb", "gb", "tb", "pb", "eb", "zb", "yb" }

	local i = math.floor(math.log(bytes) / math.log(k))

	local value = bytes / (k ^ i)
	if value >= 100 then
		dm = 0
	end
	local formattedValue = string.format("%." .. dm .. "f", value)

	return formattedValue .. " " .. sizes[i + 1]
end

local netstat_up = sbar.add("item", {
	position = "right",
	width = width,
	icon = { drawing = false },
})

sbar.add("item", {
	position = "right",
	icon = {
		string = "",
		font = "FiraCode Nerd Font Mono:Regular:16.0",
		color = colors.network.upload,
	},
})

local netstat_down = sbar.add("item", {
	position = "right",
	width = width,
	icon = { drawing = false },
})

sbar.add("item", {
	position = "right",
	icon = {
		string = "",
		font = "FiraCode Nerd Font Mono:Regular:16.0",
		color = colors.network.download,
	},
})

sbar.add("event", "netstat_update")

sbar.exec("~/.config/sketchybar/plugins/netstat.sh")

netstat_up:subscribe("netstat_update", function(env)
	local download = formatBytes(env.DOWNLOAD)
	local upload = formatBytes(env.UPLOAD)

	netstat_up:set({
		label = { string = upload, color = colors.network.upload },
	})
	netstat_down:set({
		label = { string = download, color = colors.network.download },
	})
end)
