local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on('update-right-status', function(window, pane)
    window:set_right_status(window:active_workspace())
end)


local function tab_title(tab_info)
    local title = tab_info.tab_title

    if title and #title > 0 then
        return title
    end

    local pane_title = tab_info.active_pane.title

    if pane_title and #pane_title > 0 then
        local first_word = pane_title:match("^(%S+)")
        return first_word
    end

    return "fish"
end


wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local title = tab_title(tab)

        if tab.is_active then
            return {
                { Background = { Color = "cyan" } },
                { Foreground = { Color = "black" } },
                { Attribute = { Intensity = "Bold" } },
                { Text = " " .. title .. " " },
            }
        else
            return {
                { Background = { Color = "gray" } },
                { Foreground = { Color = "white" } },
                { Text = " " .. title .. " " },
            }
        end
    end)

wezterm.on('augment-command-palette', function(window, pane)
    return {
        {
            brief = 'Rename tab',
            icon = 'md_rename_box',

            action = act.PromptInputLine {
                description = 'Enter new name for tab',
                initial_value = 'My Tab Name',
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end),
            },
        },
    }
end)
