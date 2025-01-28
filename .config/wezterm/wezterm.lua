require "events"
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.keys = require "keybinds"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 0

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

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

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

return config
