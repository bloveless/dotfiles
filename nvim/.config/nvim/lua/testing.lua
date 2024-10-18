local add, later = MiniDeps.add, MiniDeps.later

later(function()
	add({
		source = "nvim-neotest/neotest",
		depends = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"fredrikaverpil/neotest-golang",
			"V13Axel/neotest-pest",
		},
	})

	require("neotest").setup({
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
		adapters = neotest_adapters,
		adapters = {
			require("neotest-golang")({
				-- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
				go_test_args = { "-cover", "-short" },
				dap_go_enabled = true,
			}),
			require("neotest-pest")({
				sail_enabled = false,
			}),
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
	})

	vim.keymap.set("n", "<leader>tt", function()
		require("neotest").output_panel.clear()
		require("neotest").run.run(vim.fn.expand("%"))
	end, { desc = "Run File" })
	vim.keymap.set("n", "<leader>tT", function()
		require("neotest").output_panel.clear()
		require("neotest").run.run(vim.uv.cwd())
	end, { desc = "Run All Test Files" })
	vim.keymap.set("n", "<leader>tr", function()
		require("neotest").output_panel.clear()
		require("neotest").run.run()
	end, { desc = "Run Nearest" })
	vim.keymap.set("n", "<leader>tdr", function()
		require("neotest").run.run({ strategy = "dap" })
	end, { desc = "Debug nearest" })
	vim.keymap.set("n", "<leader>tdl", function()
		require("neotest").run.run_last({ strategy = "dap" })
	end, { desc = "Debug last" })
	vim.keymap.set("n", "<leader>tl", function()
		require("neotest").output_panel.clear()
		require("neotest").run.run_last()
	end, { desc = "Run Last" })
	vim.keymap.set("n", "<leader>ts", function()
		require("neotest").summary.toggle()
	end, { desc = "Toggle Summary" })
	vim.keymap.set("n", "<leader>to", function()
		require("neotest").output.open({ enter = false, auto_close = true })
	end, { desc = "Show Output" })
	vim.keymap.set("n", "<leader>tO", function()
		require("neotest").output_panel.toggle()
	end, { desc = "Toggle Output Panel" })
	vim.keymap.set("n", "<leader>tS", function()
		require("neotest").run.stop()
	end, { desc = "Stop" })
	vim.keymap.set("n", "<leader>tw", function()
		require("neotest").watch.toggle(vim.fn.expand("%"))
	end, { desc = "Toggle Watch" })

	add({
		source = "mfussenegger/nvim-dap",
		depends = {
			"rcarriga/nvim-dap-ui",
			-- virtual text for the debugger
			"theHamsta/nvim-dap-virtual-text",
			"leoluz/nvim-dap-go",
		},
	})

	require("nvim-dap-virtual-text").setup()
	require("dap-go").setup()

	vim.keymap.set("n", "<leader>dB", function()
		require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "Breakpoint Condition" })
	vim.keymap.set("n", "<leader>db", function()
		require("dap").toggle_breakpoint()
	end, { desc = "Toggle Breakpoint" })
	vim.keymap.set("n", "<leader>dc", function()
		require("dap").continue()
	end, { desc = "Continue" })
	vim.keymap.set("n", "<leader>da", function()
		require("dap").continue({ before = get_args })
	end, { desc = "Run with Args" })
	vim.keymap.set("n", "<leader>dC", function()
		require("dap").run_to_cursor()
	end, { desc = "Run to Cursor" })
	vim.keymap.set("n", "<leader>dg", function()
		require("dap").goto_()
	end, { desc = "Go to Line (No Execute)" })
	vim.keymap.set("n", "<leader>di", function()
		require("dap").step_into()
	end, { desc = "Step Into" })
	vim.keymap.set("n", "<leader>dj", function()
		require("dap").down()
	end, { desc = "Down" })
	vim.keymap.set("n", "<leader>dk", function()
		require("dap").up()
	end, { desc = "Up" })
	vim.keymap.set("n", "<leader>dl", function()
		require("dap").run_last()
	end, { desc = "Run Last" })
	vim.keymap.set("n", "<leader>do", function()
		require("dap").step_out()
	end, { desc = "Step Out" })
	vim.keymap.set("n", "<leader>dO", function()
		require("dap").step_over()
	end, { desc = "Step Over" })
	vim.keymap.set("n", "<leader>dp", function()
		require("dap").pause()
	end, { desc = "Pause" })
	vim.keymap.set("n", "<leader>dr", function()
		require("dap").repl.toggle()
	end, { desc = "Toggle REPL" })
	vim.keymap.set("n", "<leader>ds", function()
		require("dap").session()
	end, { desc = "Session" })
	vim.keymap.set("n", "<leader>dt", function()
		require("dap").terminate()
	end, { desc = "Terminate" })
	vim.keymap.set("n", "<leader>dw", function()
		require("dap.ui.widgets").hover()
	end, { desc = "Widgets" })

	local dap, dapui = require("dap"), require("dapui")
	dapui.setup()
	dap.listeners.before.attach.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.launch.dapui_config = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated.dapui_config = function()
		dapui.close()
	end
	dap.listeners.before.event_exited.dapui_config = function()
		dapui.close()
	end
end)
