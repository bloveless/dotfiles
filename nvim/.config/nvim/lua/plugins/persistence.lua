return {
	{
		"folke/persistence.nvim",
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				{ desc = "[q][s] Load session" },
			},

			{
				"<leader>qS",
				function()
					require("persistence").load()
				end,
				{ desc = "[q][S] Select session to load" },
			},

			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				{ desc = "[q][l] Load last session" },
			},

			{
				"<leader>qd",
				function()
					require("persistence").load({ last = true })
				end,
				{ desc = "[q][d] Stop persistence, session won't be saved" },
			},
		},
		opts = {},
	},
}
