local wezterm = require 'wezterm'
local hostname = wezterm.hostname()
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Dracula (Official)'

if hostname == "Bekolay-Windows" then
  config.default_domain = "WSL:Debian"
else
  config.default_domain = "local"
end

config.font = wezterm.font 'Fira Code'
config.font_size = 9.5
config.freetype_load_flags = 'NO_HINTING'
config.freetype_load_target = 'HorizontalLcd'

config.enable_tab_bar = false

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.8,
}
config.warn_about_missing_glyphs = false

config.leader = { key = 'w', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = 'v',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = 'w',
    mods = 'LEADER|CTRL',
    action = wezterm.action.ActivatePaneDirection("Next"),
  }
}

return config

