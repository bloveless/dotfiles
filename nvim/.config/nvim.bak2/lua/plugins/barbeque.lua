return {
	{
		"utilyre/barbecue.nvim",
		enabled = false,
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency (using mini.icons instead)
			"nvchad/ui",
			"nvchad/base46",
		},
		opts = {
			theme = "gruvbox",
			create_autocmd = false, -- prevent barbecue from updating itself automatically
			exclude_filetypes = { "toggleterm", "netrw" },
			show_modified = true,
		},
		config = function(_, opts)
			require("barbecue").setup(opts)

			vim.api.nvim_create_autocmd({
				"WinResized",
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",
				"BufModifiedSet",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
	},
}
