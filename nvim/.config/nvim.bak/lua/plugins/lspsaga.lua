return {
	{
		"nvimdev/lspsaga.nvim",
		event = "VimEnter",
		keys = {
			{ "<leader>ca", "<cmd>Lspsaga code_action<cr>", mode = { "n", "x" }, desc = "[C]ode [A]ction" },
			{ "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next diagnostic" },
			{ "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Previous diagnostic" },
			{ "<leader>a", "<cmd>Lspsaga outline<cr>", desc = "Outline" },
			{ "<leader>rn", "<cmd>Lspsaga rename<cr>", desc = "LSP Rename" },
		},
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					virtual_text = false,
				},
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
}
