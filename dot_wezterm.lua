local wezterm = require('wezterm')
local hostname = wezterm.hostname()
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Dracula (Official)'

if hostname == 'Bekolay-Windows' then
  config.default_domain = 'WSL:Debian'
else
  config.default_domain = 'local'
end

config.front_end = 'WebGpu'

config.font = wezterm.font('Fira Code')
config.font_size = 9.5

config.enable_tab_bar = false

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.8,
}
config.warn_about_missing_glyphs = false

local act = wezterm.action
config.disable_default_key_bindings = true
config.leader = { key = 'w', mods = 'SUPER', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = act.CopyTo('Clipboard'),
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = act.PasteFrom('Clipboard'),
  },
  {
    key = 'v',
    mods = 'LEADER',
    action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = 'w',
    mods = 'LEADER|SUPER',
    action = act.ActivatePaneDirection('Next'),
  },
  {
    key = '=',
    mods = 'LEADER',
    action = act.IncreaseFontSize,
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.DecreaseFontSize,
  },
  {
    key = '0',
    mods = 'LEADER',
    action = act.ResetFontSize,
  },
  {
    key = 'r',
    mods = 'LEADER',
    action = act.ReloadConfiguration,
  },
}

return config
