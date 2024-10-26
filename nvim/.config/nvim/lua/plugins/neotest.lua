return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"fredrikaverpil/neotest-golang",
			"V13Axel/neotest-pest",
		},
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").output_panel.clear()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				{ desc = "Run File" },
			},
			{
				"<leader>tT",
				function()
					require("neotest").output_panel.clear()
					require("neotest").run.run(vim.uv.cwd())
				end,
				{ desc = "Run All Test Files" },
			},
			{
				"<leader>tr",
				function()
					require("neotest").output_panel.clear()
					require("neotest").run.run()
				end,
				{ desc = "Run Nearest" },
			},
			{
				"<leader>tdr",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				{ desc = "Debug nearest" },
			},
			{
				"<leader>tdl",
				function()
					require("neotest").run.run_last({ strategy = "dap" })
				end,
				{ desc = "Debug last" },
			},
			{
				"<leader>tl",
				function()
					require("neotest").output_panel.clear()
					require("neotest").run.run_last()
				end,
				{ desc = "Run Last" },
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				{ desc = "Toggle Summary" },
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = false, auto_close = true })
				end,
				{ desc = "Show Output" },
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				{ desc = "Toggle Output Panel" },
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.stop()
				end,
				{ desc = "Stop" },
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				{ desc = "Toggle Watch" },
			},
		},
		opts = {
			-- this will log to `:lua vim.print(require("neotest.logging"):get_filename())`
			-- log_level = vim.log.levels.DEBUG,
			-- See all config options with :h neotest.Config (options from https://github.com/fredrikaverpil/neotest-golang to help neotest performance in large code bases)
			discovery = {
				-- Drastically improve performance in ginormous projects by
				-- only AST-parsing the currently opened buffer.
				enabled = false,
				-- Number of workers to parse files concurrently.
				-- A value of 0 automatically assigns number based on CPU.
				-- Set to 1 if experiencing lag.
				concurrent = 0,
			},
			running = {
				-- Run tests concurrently when an adapter provides multiple commands to run.
				concurrent = true,
			},
			summary = {
				-- Enable/disable animation of icons.
				animated = true,
			},
			status = {
				virtual_text = false,
			},
			output = {
				open_on_run = false,
			},
			output_summary = {
				enabled = true,
			},
		},
		config = function(_, opts)
			opts.adapters = {
				require("neotest-golang")({
					-- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
					go_test_args = { "-cover", "-short" },
					dap_go_enabled = true,
				}),
				require("neotest-pest")({
					sail_enabled = false,
				}),
			}

			require("neotest").setup(opts)
		end,
	},
}
