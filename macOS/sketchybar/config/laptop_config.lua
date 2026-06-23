local sbar = require("sketchybar")
local aerospace = require("items.aerospace_modes")
local aerospace_layout = require("items.aerospace_layout")
local apple = require("items.apple")
local front_app = require("items.front_app")
local keyboard = require("items.keyboard")
local netstat = require("items.netstat")
local paths = require("config.paths")
local workspaces = require("items.workspaces")

local keyboard_script = paths.plugin_dir .. "keyboard.sh"

local function update_for_laptop()
	aerospace.set({ position = "left" })
	aerospace_layout.set({ position = "left" })
	keyboard.set({ position = "left" })
	workspaces.set({ position = "left" })

	apple.set({ drawing = false })
	front_app.set({ drawing = false })
	netstat.set_netstat_up({ drawing = false })
	netstat.set_netstat_down({ drawing = false })
end

local function update_for_default()
	aerospace.set({ position = "center" })
	aerospace_layout.set({ position = "center" })
	keyboard.set({ position = "center" })
	workspaces.set({ position = "center" })

	apple.set({ drawing = true })
	front_app.set({ drawing = true })
	netstat.set_netstat_up({ drawing = true })
	netstat.set_netstat_down({ drawing = true })
end

local function apply_keymap_layout(keymap)
	if keymap == "laptop" then
		update_for_laptop()
	else
		update_for_default()
	end
end

local function fetch_current_keymap()
	local file = io.open(paths.keymap_conf, "r")
	if not file then
		return "qwerty"
	end

	local current_keymap = file:read("*l")
	file:close()

	return current_keymap or "qwerty"
end

local laptop_config_observer = sbar.add("item", "laptop_config_observer", {
	drawing = false,
	updates = true,
})

laptop_config_observer:subscribe("keyboard_state_update", function(env)
	apply_keymap_layout(env.KEYBOARD_STATE)
end)

apply_keymap_layout(fetch_current_keymap())
sbar.exec(keyboard_script .. " state")
