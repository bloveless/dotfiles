return {
	{
		"cbochs/grapple.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		keys = {
			{ "<leader>m", "<cmd>Grapple toggle<cr>", { desc = "Grapple toggle tag" } },
			{ "<leader>M", "<cmd>Grapple toggle_tags<cr>", { desc = "Grapple open tags window" } },
			{ "<leader>n", "<cmd>Grapple cycle_tags next<cr>", { desc = "Grapple cycle next tag" } },
			{ "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", { desc = "Grapple cycle previous tag" } },
			{ "<leader>1", "<cmd>Grapple select index=1<cr>", { desc = "Grapple cycle index one" } },
			{ "<leader>2", "<cmd>Grapple select index=2<cr>", { desc = "Grapple cycle index two" } },
			{ "<leader>3", "<cmd>Grapple select index=3<cr>", { desc = "Grapple cycle index three" } },
			{ "<leader>4", "<cmd>Grapple select index=4<cr>", { desc = "Grapple cycle index four" } },
			{ "<leader>5", "<cmd>Grapple select index=5<cr>", { desc = "Grapple cycle index five" } },
			{ "<leader>6", "<cmd>Grapple select index=6<cr>", { desc = "Grapple cycle index six" } },
			{ "<leader>7", "<cmd>Grapple select index=7<cr>", { desc = "Grapple cycle index seven" } },
			{ "<leader>8", "<cmd>Grapple select index=8<cr>", { desc = "Grapple cycle index eight" } },
			{ "<leader>9", "<cmd>Grapple select index=9<cr>", { desc = "Grapple cycle index nine" } },
		},
		opts = {
			scope = "git_branch",
		},
		config = function(_, opts)
			require("grapple").setup(opts)
		end,
	},
}
