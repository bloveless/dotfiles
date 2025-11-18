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

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "rose-pine-moon"
	else
		return "rose-pine-dawn"
	end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13
config.line_height = 1.4
config.initial_cols = 180
config.initial_rows = 35
config.scrollback_lines = 100000
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE|MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR"

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		icons_enabled = true,
		tabs_enabled = true,
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
		component_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thin,
			right = wezterm.nerdfonts.ple_left_half_circle_thin,
		},
		tab_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
	},
	sections = {
		tabline_a = {},
		tabline_b = {},
		tabline_c = {},
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = {},
		tabline_y = { "cpu", "ram" },
		tabline_z = { "datetime", "battery" },
	},
	extensions = {},
})

return config
