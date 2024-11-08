return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons (using mini.icons instead)
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			animation = false,
			insert_at_start = true,
		},
		config = function(_, opts)
			require("barbar").setup(opts)

			vim.keymap.set("n", "<C-p>", "<Cmd>BufferPick<CR>", { desc = "Buffer pick" })
			vim.keymap.set("n", "<S-l>", "<cmd>BufferNext<cr>", { desc = "Buffer next" })
			vim.keymap.set("n", "<S-h>", "<cmd>BufferPrevious<cr>", { desc = "Buffer previous" })
			vim.keymap.set("n", "<A-<>", "<Cmd>BufferMovePrevious<cr>", { desc = "Move buffer previous" })
			vim.keymap.set("n", "<A->>", "<Cmd>BufferMoveNext<cr>", { desc = "Move buffer next" })
			vim.keymap.set("n", "<leader>w", "<cmd>BufferDelete<cr>", { desc = "Buffer previous" })
		end,
	},
}
