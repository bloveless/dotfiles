return {
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",

	{
		"nvchad/ui",
		priority = 1000,
		config = function()
			require("nvchad")

			-- Navigate buffer tabs
			vim.keymap.set("n", "L", require("nvchad.tabufline").next, { desc = "Next buffer" })
			vim.keymap.set("n", "H", require("nvchad.tabufline").prev , { desc = "Prev buffer" })
		end,
	},

	{
		"nvchad/base46",
		priority = 1000,
		lazy = true,
		build = function()
			require("base46").load_all_highlights()
		end,
	},

	"nvchad/volt", -- optional, needed for theme switcher
	-- or just use Telescope themes
}
