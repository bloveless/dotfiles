local wezterm = require("wezterm")

local config = wezterm.config_builder()

local mykeys = {
	{
		key = "{",
		mods = "SHIFT|ALT",
		action = wezterm.action.MoveTabRelative(-1),
	},
	{
		key = "}",
		mods = "SHIFT|ALT",
		action = wezterm.action.MoveTabRelative(1),
	},
	-- In order to clear the scrollback and with CMD+K an update needs to be made in MacOS keyboard shortcuts -> App Shortcuts
	-- Application: WezTerm
	-- Menu name: Clear the scrollback and viewport
	-- Shortcut CMD+K
	-- Menu name: Clear scrollback
	-- Shortcut CMD+SHIFT+K
	{
		key = "K",
		mods = "CMD",
		action = wezterm.action.Multiple({
			wezterm.action.ClearScrollback("ScrollbackAndViewport"),
			wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
	-- Enable scolling back to the last input prompt
	{ key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(1) },
}

for i = 1, 8 do
	-- CTRL+ALT + number to move to that position
	table.insert(mykeys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = wezterm.action.MoveTab(i - 1),
	})
end

config.color_scheme = "Catppuccin Frappe" -- or Macchiato, Frappe, Latte

-- color_scheme = "tokyonight_storm",
-- config.color_scheme = "nord"
-- color_scheme = "Gruvbox dark, medium (base16)",
-- color_scheme = "Kanagawa (Gogh)",
-- color_scheme = "rose-pine-moon",
-- font = wezterm.font "MonoLisa Nerd Font",
-- font = wezterm.font "MesloLGS NF",
config.font = wezterm.font("MonaspiceXe Nerd Font")
config.font_size = 12
config.line_height = 1.1
config.initial_cols = 150
config.initial_rows = 45
config.scrollback_lines = 50000
config.keys = mykeys
config.tab_bar_at_bottom = true

local theme = wezterm.color.get_builtin_schemes()["Catppuccin Frappe"]

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "MonaspiceXe Nerd Font", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 11.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = theme.background,

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = theme.background,
}

config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = theme.ansi[3],
			fg_color = "#333",
		},

		inactive_tab_edge = "#EEE",

		inactive_tab = {
			bg_color = "#4E5471",
			fg_color = "#EEE",
		},
	},
}

return config
