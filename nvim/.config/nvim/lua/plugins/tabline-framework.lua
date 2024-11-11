return {
	{
		"rafcamlet/tabline-framework.nvim",
		enabled = false,
		dependencies = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			local render = function(f)
				f.add({ " ", fg = "#bb0000" })
				f.add(" ")
			end

			require("tabline_framework").setup({
				render = require("tabline_framework.examples.tabs_and_buffers"),
				-- Default color of tabline items: tabs/bufs
				-- if not set TF uses TabLine highlight group colors
				hl = { fg = "#abb2bf", bg = "#31353f" },
				-- Default color of selected item
				-- if not set TF uses TabLineSel highlight group colors
				hl_sel = { fg = "#282c34", bg = "#abb2bf", gui = "bold,underline" },
				-- Default color of everything except items
				-- if not set TF uses TabLineFill highlight group colors
				hl_fill = { fg = "#282c34", bg = "#abb2bf" },
			})
		end,
	},
}
