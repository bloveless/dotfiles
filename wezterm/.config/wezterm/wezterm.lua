local wezterm = require("wezterm")

local config = wezterm.config_builder()

local mykeys = {
	{ key = "{", mods = "SHIFT|ALT", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "}", mods = "SHIFT|ALT", action = wezterm.action.MoveTabRelative(1) },
}

for i = 1, 8 do
	-- CTRL+ALT + number to move to that position
	table.insert(mykeys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = wezterm.action.MoveTab(i - 1),
	})
end

-- color_scheme = "Catppuccin Macchiato", -- or Macchiato, Frappe, Latte
-- color_scheme = "tokyonight_storm",
config.color_scheme = "nord"
-- color_scheme = "Gruvbox dark, medium (base16)",
-- color_scheme = "Kanagawa (Gogh)",
-- color_scheme = "rose-pine-moon",
-- font = wezterm.font "MonoLisa Nerd Font",
-- font = wezterm.font "MesloLGS NF",
config.font = wezterm.font("MonaspiceXe Nerd Font")
config.font_size = 11
config.initial_cols = 150
config.initial_rows = 45
config.scrollback_lines = 50000
config.keys = mykeys
config.tab_bar_at_bottom = true

return config
