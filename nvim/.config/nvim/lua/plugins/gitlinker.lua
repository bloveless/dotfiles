return {
	{
		"ruifm/gitlinker.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>gy",
				function()
					require("gitlinker").get_buf_range_url("n")
				end,
				{ desc = "[g]it permalink [y]ank" },
			},
		},
		opts = {
			mappings = nil,
		},
	},
}
