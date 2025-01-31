local wezterm = require("wezterm")

local config = wezterm.config_builder()

local function active_tab_idx(mux_win)
	for _, item in ipairs(mux_win:tabs_with_info()) do
		-- wezterm.log_info('idx: ', idx, 'tab:', item)
		if item.is_active then
			return item.index
		end
	end
end

-- https://wezfurlong.org/wezterm/config/keys.html
config.keys = {
	{
		key = "t",
		mods = "CMD",
		-- https://github.com/wez/wezterm/issues/909
		-- this will open new tabs next to the current active tab
		action = wezterm.action_callback(function(win, pane)
			local mux_win = win:mux_window()
			local idx = active_tab_idx(mux_win)
			mux_win:spawn_tab({})
			win:perform_action(wezterm.action.MoveTab(idx + 1), pane)
		end),
	},
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
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},
	-- Enable scrolling back to the last input prompt
	{ key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(1) },
}

for i = 1, 8 do
	-- CTRL+ALT + number to move to that position
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = wezterm.action.MoveTab(i - 1),
	})
end

-- config.color_scheme = "Gruvbox dark, soft (base16)"
-- config.color_scheme = "OneDark (base16)"
config.color_scheme = "Catppuccin Macchiato"

config.font = wezterm.font("MonoLisa")
-- config.font = wezterm.font("JetBrainsMono Nerd Font")
-- config.font = wezterm.font("MesloLGS NF")
-- config.font = wezterm.font("FiraCode Nerd Font")
-- config.font = wezterm.font("Monaspace Argon Var")
-- config.font = wezterm.font("Hack", { weight = "Regular" })
config.font_size = 11
config.line_height = 1.4
config.initial_cols = 150
config.initial_rows = 45
config.scrollback_lines = 100000
config.tab_bar_at_bottom = true

-- local theme = require("lua/rose-pine").moon
local theme = wezterm.color.get_builtin_schemes()["Catppuccin Macchiato"]
-- local theme = wezterm.color.get_builtin_schemes()["OneDark (base16)"]

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	-- font = wezterm.font({ family = "MonoLisa", weight = "Bold" }),

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

		inactive_tab_edge = theme.ansi[1],

		inactive_tab = {
			bg_color = theme.background,
			fg_color = "#EEE",
		},

		new_tab = {
			fg_color = "#EEE",
			bg_color = theme.background,
		},
	},
}

-- config.colors = theme.colors()
-- config.window_frame = theme.window_frame() -- needed only if using fancy tab bar

config.window_padding = { left = 10, right = 10, top = 0, bottom = 0 }

wezterm.on("update-right-status", function(window)
	local time = wezterm.strftime("%H:%M")

	window:set_right_status(wezterm.format({
		{ Background = { Color = theme.background } },
		{ Text = " " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		{ Text = "  " },
	}))
end)

return config
