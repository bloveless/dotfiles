require("nvim-tree").setup({
	view = {
		float = {
			enable = true,
			open_win_config = function()
				local screen_w = vim.opt.columns:get()
				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
				local _width = screen_w * 0.8
				local _height = screen_h * 0.85
				local width = math.floor(_width)
				local height = math.floor(_height)
				local center_y = ((vim.opt.lines:get() - _height) / 2) - vim.opt.cmdheight:get()
				local center_x = (screen_w - _width) / 2
				local layouts = {
					center = {
						anchor = "NW",
						relative = "editor",
						border = "rounded",
						row = center_y,
						col = center_x,
						width = width,
						height = height,
					},
				}
				return layouts.center
			end,
		},
		mappings = {
			list = {
				{ key = "<ESC>", action = "close" },
			},
		},
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
})

vim.keymap.set("n", "<leader>t", function()
	require("nvim-tree.api").tree.toggle({ find_file = true })
end)
