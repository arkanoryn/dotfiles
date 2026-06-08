local sbar = require("sketchybar")
local paths = require("config.paths")

local keyboard_script = paths.plugin_dir .. "keyboard.sh"
local keymaps = {
	{ id = "qwerty", label = "QWERTY", icon = "󰌌" },
	{ id = "laptop", label = "Laptop", icon = "󰌢" },
	{ id = "graphite", label = "Graphite", icon = "" },
}

local keyboard_mode = sbar.add("item", "keyboard_mode", {
	position = "center",
	click_script = "sketchybar --set $NAME popup.drawing=toggle",
	label = "",
	popup = {
		height = 35,
	},
})

local function state_to_label(state)
	for _, keymap in ipairs(keymaps) do
		if state == keymap.id then
			return keymap.icon
		end
	end

	return "󰌌"
end

local function select_keymap(keymap)
	sbar.exec(keyboard_script .. " select " .. keymap)
	keyboard_mode:set({ popup = { drawing = false } })
end

for _, keymap in ipairs(keymaps) do
	local keymap_id = keymap.id
	local item = sbar.add("item", "keyboard_" .. keymap_id, {
		position = "popup." .. keyboard_mode.name,
		icon = keymap.icon,
		label = keymap.label,
	})

	item:subscribe("mouse.clicked", function(_)
		select_keymap(keymap_id)
	end)
end

sbar.add("event", "keyboard_state_update")

sbar.exec(keyboard_script .. " state")

keyboard_mode:subscribe("keyboard_state_update", function(env)
	keyboard_mode:set({
		label = { string = state_to_label(env.KEYBOARD_STATE) },
	})
end)

return {
	set = function(properties)
		keyboard_mode:set(properties)
	end,
}
