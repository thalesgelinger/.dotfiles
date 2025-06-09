local wezterm = require 'wezterm'

local projects_path = os.getenv("HOME") .. "/Projects"

local project_shortcut = require "jumps"

local keys = {}

for key, path in pairs(project_shortcut) do
    local name = path:match("([^/]+)$")
    table.insert(keys, {
        key = key,
        mods = 'LEADER',
        action = wezterm.action_callback(function(window, pane)
            window:perform_action(
                wezterm.action.SwitchToWorkspace({
                    name = name,
                    spawn = {
                        label = name,
                        cwd = projects_path .. path,
                    },
                }), pane)
        end),
    })
end

return keys
