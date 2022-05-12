local wezterm = require 'wezterm'
wezterm.log_info("Config file " .. wezterm.config_file)

wezterm.on("toggle-opacity", function(window, pane)
 local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = nil
  else
    overrides.window_background_opacity = 1.0;
  end
  window:set_config_overrides(overrides)
end)

return {
  keys = {
    {key="B", mods="CTRL", action=wezterm.action{EmitEvent="toggle-opacity"}},
  },
  font = wezterm.font("Hack Nerd Font"),
  window_background_opacity = 0.8,
  hide_tab_bar_if_only_one_tab = true,
}
