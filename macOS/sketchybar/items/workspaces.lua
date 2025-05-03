local colors = require("config.colors")
local settings = require("config.settings")
local app_icons = require("config.app_icons")
local sbar = require("sketchybar")

sbar.add("event", "aerospace_workspace_change")

local workspaces = {}

-- Function to execute shell commands and return the output
local function execute_command(command)
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	return result
end

local function add_workspace(monitor_id, workspace_id)
	local space = sbar.add("space", "space." .. tostring(workspace_id), {
		space = monitor_id,
		display = monitor_id,
		position = "center",
		icon = {
			font = { family = settings.default_font.numbers, size = 18 },
			string = workspace_id,
			padding_left = 14,
			padding_right = 7,
			color = colors.aerospace.workspaces.inactive.icon,
			highlight_color = colors.aerospace.workspaces.active.highlight,
		},
		label = {
			padding_right = 20,
			color = colors.aerospace.workspaces.inactive.icon,
			highlight_color = colors.aerospace.workspaces.active.icon,
			font = "sketchybar-app-font:Regular:14.0",
		},
		padding_right = 4,
		padding_left = 4,
		background = {
			color = colors.aerospace.workspaces.inactive.background,
			border_width = 1,
			height = 30,
		},
		click_script = "aerospace workspace " .. workspace_id,
	})

	workspaces[workspace_id] = space

	-- Padding space
	sbar.add("space", "space.padding." .. tostring(workspace_id), {
		space = monitor_id,
		script = "",
		width = settings.group_paddings,
	})

	space:subscribe({ "aerospace_workspace_change" }, function(env)
		local selected = tonumber(env.FOCUSED_WORKSPACE) == workspace_id

		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
			background = {
				color = selected and colors.aerospace.workspaces.active.background
					or colors.aerospace.workspaces.inactive.background,
				border_color = selected and colors.aerospace.workspaces.active.border
					or colors.aerospace.workspaces.inactive.border,
			},
		})
	end)
end

-- Get monitor information
local monitors = {}
local monitor_output = execute_command("aerospace list-monitors")
for line in monitor_output:gmatch("[^\r\n]+") do
	local id, name = line:match("(%d+) | (.+)")
	if id and name then
		monitors[tonumber(id)] = name
	end
end

-- Get workspaces for each monitor
for monitor_id, _ in pairs(monitors) do
	local workspace_output = execute_command("aerospace list-workspaces --monitor " .. monitor_id)
	for workspace_id in workspace_output:gmatch("[^\r\n]+") do
		add_workspace(monitor_id, tonumber(workspace_id))
	end
end

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

local function set_icon_line(workspace_id)
	sbar.exec(
		[[aerospace list-windows --workspace ]] .. tostring(workspace_id) .. [[ | awk -F '|' '{print $2}']],
		function(appNames)
			local appCounts = {}
			-- Split the input string by newline into individual app names
			for appName in string.gmatch(appNames, "[^\r\n]+") do
				-- Trim leading and trailing whitespace
				appName = appName:match("^%s*(.-)%s*$")
				if appCounts[appName] then
					appCounts[appName] = appCounts[appName] + 1
				else
					appCounts[appName] = 1
				end
			end

			local icon_line = ""
			local no_app = true
			for app, _ in pairs(appCounts) do
				no_app = false
				local lookup = app_icons[app]
				local icon = ((lookup == nil) and app_icons["Default"] or lookup)
				icon_line = icon_line .. icon
			end

			if no_app then
				icon_line = " —"
			end

			if workspace_id == "focused" then
				sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
					for id in focused_workspace:gmatch("%S+") do
						workspaces[tonumber(id)]:set({ label = icon_line })
					end
				end)
			else
				sbar.animate("tanh", 10, function()
					workspaces[tonumber(workspace_id)]:set({ label = icon_line })
				end)
			end
		end
	)
end

space_window_observer:subscribe({ "aerospace_workspace_change" }, function(env)
	set_icon_line(env.FOCUSED_WORKSPACE)
end)

space_window_observer:subscribe({ "space_windows_change" }, function()
	set_icon_line("focused")
end)

-- initial run
local ok, ws = pcall(function()
	return execute_command("aerospace list-workspaces --focused"):gsub("%s+", "")
end)
local focused_workspace = ok and tonumber(ws) or -1

sbar.trigger("aerospace_workspace_change", { FOCUSED_WORKSPACE = focused_workspace })
