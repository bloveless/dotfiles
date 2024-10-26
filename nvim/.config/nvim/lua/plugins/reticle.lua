return {
	{
		-- source = "tummetott/reticle.nvim",
		-- revert back to tummetott if https://github.com/tummetott/reticle.nvim/pull/13 gets merged
		"bloveless/reticle.nvim",
		ft = { "yaml", "python" },
		opts = {
			on_startup = {
				cursorline = true,
				cursorcolumn = false,
			},
			always = {
				cursorcolumn = {
					"yaml",
					"python",
				},
			},
		},
	},
}
