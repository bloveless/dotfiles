return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				{ desc = "[F]ormat buffer" },
			},
		},
		-- This will provide type hinting with LuaLS
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			-- log_level = vim.log.levels.DEBUG,
			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
			},
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
