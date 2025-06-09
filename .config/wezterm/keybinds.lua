require "utils"
local wezterm = require 'wezterm'
local jumper_keys = require "jumper"
local act = wezterm.action

local keys = {
    {
        key = 'r',
        mods = 'CMD|SHIFT',
        action = wezterm.action.ReloadConfiguration,
    },
    {
        key = "%",
        mods = "LEADER",
        action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "\"",
        mods = "LEADER",
        action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "[",
        mods = "LEADER",
        action = act.ActivateCopyMode
    },
    {
        key = 's',
        mods = 'LEADER',
        action = act.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
        },
    },
    {
        key = 'g',
        mods = 'LEADER',
        action = wezterm.action.SpawnCommandInNewTab {
            args = { '/opt/homebrew/bin/lazygit' },
        },
    },
    {
        key = 'd',
        mods = 'LEADER',
        action = wezterm.action.SpawnCommandInNewTab {
            args = { '/opt/homebrew/bin/lazydocker' },
        },
    },
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'x',
        mods = 'LEADER',
        action = wezterm.action.CloseCurrentTab { confirm = true },
    },
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    {
        key = "h",
        mods = "LEADER",
        action = wezterm.action { ActivatePaneDirection = "Left" }
    },

    {
        key = "l",
        mods = "LEADER",
        action = wezterm.action { ActivatePaneDirection = "Right" }
    },

    {
        key = "k",
        mods = "LEADER",
        action = wezterm.action { ActivatePaneDirection = "Up" }
    },

    {
        key = "j",
        mods = "LEADER",
        action = wezterm.action { ActivatePaneDirection = "Down" }
    },
    {
        key = 'p',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal {
            args = { '/opt/homebrew/bin/nvim', os.getenv("HOME") .. '/.config/wezterm/jumps.lua' }
        },
    },

    {
        key = 'n',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal {
            args = { '/opt/homebrew/bin/nvim', os.getenv("HOME") .. '/Documents/daily_notes/' .. os.date("%Y-%m-%d") .. ".md" }
        },
    },

}

local function get_folders_choices(directory)
    local folders = {}
    local command = 'ls -d "' .. directory .. '"/*/'
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    for folder in result:gmatch("[^\n]+") do
        table.insert(folders, {
            id = folder,
            label = folder
        })
    end

    return folders
end

local function sessionizer()
    local choices = {}
    local work = get_folders_choices(os.getenv("HOME") .. "/Projects/work")
    local personal = get_folders_choices(os.getenv("HOME") .. "/Projects/personal")

    for _, v in ipairs(work) do
        table.insert(choices, v)
    end
    for _, v in ipairs(personal) do
        table.insert(choices, v)
    end

    return act.InputSelector {
        fuzzy = true,
        action = wezterm.action_callback(function(window, pane, id, label)
            if not id and not label then
                wezterm.log_info 'cancelled'
            else
                local workspace_name = label:match(".*/(.*)/")
                window:perform_action(
                    wezterm.action.SwitchToWorkspace({
                        name = workspace_name,
                        spawn = {
                            label = 'Workspace: ' .. label,
                            cwd = id,
                        },
                    }), pane)
            end
        end),
        title = 'What do you want to work on?',
        choices = choices,
    }
end

table.insert(keys, { key = "f", mods = "CTRL", action = sessionizer() })

for i = 1, 8 do
    table.insert(keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = act.ActivateTab(i - 1),
    })
end

table.merge(keys, jumper_keys)

return keys
