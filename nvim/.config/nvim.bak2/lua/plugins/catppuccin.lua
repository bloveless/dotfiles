return {
	{
		"catppuccin/nvim",
		opts = {
			integrations = {
				cmp = true,
				gitsigns = true,
				treesitter = true,
				notify = true,
				barbecue = {
					dim_dirname = true, -- directory name is dimmed by default
					bold_basename = true,
					dim_context = false,
					alt_background = false,
				},
				barbar = true,
				fidget = true,
				flash = true,
				indent_blankline = {
					enabled = true,
					scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
					colored_indent_levels = false,
				},
				mason = true,
				mini = {
					enabled = true,
					indentscope_color = "", -- catppuccin color (eg. `lavender`) Default: text
				},
				dap = true,
				dap_ui = true,
				telescope = {
					enabled = true,
					-- style = "nvchad"
				},
				lsp_trouble = true,
				which_key = true,
			},
			custom_highlights = function()
				return {
					DiagnosticUnderlineWarn = {
						sp = "#564d3a",
					},
				}
			end,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd([[colorscheme catppuccin-macchiato]])
		end,
	},
}
