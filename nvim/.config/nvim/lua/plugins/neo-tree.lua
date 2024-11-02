return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
		checkout = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended (uses mini.icons)
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree filesystem reveal toggle<cr>", { desc = "File explorer" } },
		},
	},
}
