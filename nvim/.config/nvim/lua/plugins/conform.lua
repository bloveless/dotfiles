return {
	{
		"stevearc/conform.nvim",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				{ desc = "[F]ormat buffer" },
			},
		},
		opts = {
			-- log_level = vim.log.levels.DEBUG,
			format_after_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style.
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					lsp_format = lsp_format_opt,
				}
			end,
			formatters = {
				goimports = {
					prepend_args = { "-local", "github.com/bayer-int" },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				go = {
					"goimports",
					"gofumpt",
				},
				php = { "pint" },
				blade = { "blade-formatter" },
				proto = { "buf" },
			},
		},
	},
}
