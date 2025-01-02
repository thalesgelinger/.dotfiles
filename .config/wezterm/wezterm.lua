local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.color_scheme = 'Tokyo Night Storm'
config.font = wezterm.font "Hack Nerd Font"
config.font_size = 18.0


config.window_padding = {
    left = 16,
    right = 16,
    top = 16,
    bottom = 16,
}

config.keys = {
    {
        key = "f",
        mods = "CTRL",
        action = wezterm.action.SpawnCommandInNewTab {
            args = { os.getenv("HOME") .. '/.local/bin/tmux-sessionizer' },
        },
    }
}


return config
