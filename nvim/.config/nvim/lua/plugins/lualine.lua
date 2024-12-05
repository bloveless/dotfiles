return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"arkav/lualine-lsp-progress",
			-- {
			-- 	"will-lynas/grapple-line.nvim",
			-- 	version = "1.x",
			-- 	dependencies = {
			-- 		"cbochs/grapple.nvim",
			-- 	},
			-- },
		},
		config = function()
			local colors = {
				blue = "#80a0ff",
				cyan = "#79dac8",
				black = "#080808",
				white = "#c6c6c6",
				red = "#ff5189",
				violet = "#d183e8",
				grey = "#303030",
			}

			-- require("grapple-line").setup({
			-- 	number_of_files = 10,
			-- })

			require("lualine").setup({
				options = {
					component_separators = "",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = {
						{
							"mode",
							icon = "",
							separator = { left = "" },
						},
					},
					lualine_b = {
						"filename",
						"branch",
						{
							"diagnostics",
							sources = { "nvim_lsp" },
						},
						"diff",
					},
					lualine_c = {
						{
							"lsp_progress",
							-- display_components = { "lsp_client_name", { "title", "percentage", "message" } },
							-- With spinner
							-- display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
							colors = {
								percentage = colors.cyan,
								title = colors.cyan,
								message = colors.cyan,
								spinner = colors.cyan,
								lsp_client_name = colors.magenta,
								use = true,
							},
							separators = {
								component = " ",
								progress = " | ",
								percentage = { pre = "", post = "%% " },
								title = { pre = "", post = ": " },
								lsp_client_name = { pre = "[", post = "]" },
								spinner = { pre = "", post = "" },
								message = { pre = "(", post = ")", commenced = "In Progress", completed = "Completed" },
							},
							display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
							timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
							spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
						},
						-- "%=", --[[ add your center components here in place of this comment ]]
					},
					lualine_x = {},
					lualine_y = { "filetype", "progress" },
					lualine_z = {
						{ "location", separator = { right = "" }, left_padding = 2 },
					},
				},
				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "location" },
				},
				tabline = {
					-- lualine_a = {
					-- 	{ require("grapple-line").lualine, separator = { right = "", left = "" } },
					-- },
				},
				extensions = {
					"aerial",
					"trouble",
					"quickfix",
					"lazy",
					"mason",
				},
			})
		end,
	},
}
