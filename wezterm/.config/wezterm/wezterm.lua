local wezterm = require("wezterm")

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

return {
	-- color_scheme = "Catppuccin Macchiato", -- or Macchiato, Frappe, Latte
	-- color_scheme = "tokyonight_storm",
	color_scheme = "nord",
	-- color_scheme = "Gruvbox dark, medium (base16)",
	-- color_scheme = "Kanagawa (Gogh)",
	-- color_scheme = "rose-pine-moon",
	-- font = wezterm.font "MonoLisa Nerd Font",
	-- font = wezterm.font "MesloLGS NF",
	font_size = 12,
	initial_cols = 150,
	initial_rows = 45,
	scrollback_lines = 50000,
	keys = mykeys,
}
