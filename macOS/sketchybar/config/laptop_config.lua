local aerospace = require("items.aerospace_modes")
local apple = require("items.apple")
local front_app = require("items.front_app")
local keyboard = require("items.keyboard")
local netstat = require("items.netstat")
local workspaces = require("items.workspaces")
local paths = require("config.paths")

local function update_for_laptop()
	aerospace.set({
		position = "left",
	})
	apple.set({
		drawing = false,
	})
	front_app.set({
		drawing = false,
	})
	keyboard.set({
		position = "left",
	})
	netstat.set_netstat_up({
		drawing = false,
	})
	netstat.set_netstat_down({
		drawing = false,
	})
	workspaces.set({
		position = "left",
	})
end

local file = io.open(paths.keymap_conf, "r")

if file then
	local current_keymap = file:read("*l")
	file:close()

	if current_keymap == "laptop" then
		update_for_laptop()
	else
		print("Could not open file, loading default config.")
	end
end
