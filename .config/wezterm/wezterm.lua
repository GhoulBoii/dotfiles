local wezterm = require 'wezterm'
wezterm.on("toggle-opacity", function(window, pane)
 local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 1.0;
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

return {
  font = wezterm.font("FiraCode Nerd Font"),
  font_size = 14.0,
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 0.8,
  keys = {
    {key="B", mods="CTRL", action=wezterm.action{EmitEvent="toggle-opacity"}},
  },
}
