vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
vim.opt.laststatus = 3
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,globals,tabpages,winsize,winpos,terminal,localoptions"
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.diagnostic.config({ virtual_text = false })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- close some filetypes with <q> (From LazyVim)
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

vim.filetype.add({
	extension = {
		gotmpl = "gotmpl",
		[".go.tmpl"] = "gotmpl",
		ddl = "sql",
		[".*%.blade%.php"] = "blade",
	},
	pattern = {
		[".*/templates/.*%.tpl"] = "helm",
		[".*/templates/.*%.ya?ml"] = "helm",
		["helmfile.*%.ya?ml"] = "helm",
		["docker-compose.ya?ml"] = "yaml.docker-compose",
	},
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = "VimEnter",
		---@type gitsigns.Config
		opts = {
			current_line_blame = true,
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
		--stylua: ignore
		keys = {
			{ "<leader>gb", function() require("gitsigns").blame() end, desc = "Git Blame" },
		},
	},

	{
		"petertriho/nvim-scrollbar",
		dependencies = {
			"lewis6991/gitsigns.nvim",
		},
		opts = {
			excluded_buftypes = { "terminal" },
			excluded_filetypes = {
				"dropbar_menu",
				"dropbar_menu_fzf",
				"minifiles",
				"minipick",
				"prompt",
			},
		},
		config = function(_, opts)
			require("scrollbar").setup(opts)
			require("scrollbar.handlers.gitsigns").setup()
		end,
	},

	{ "akinsho/git-conflict.nvim", version = "*", config = true },

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = {},
			},
			-- Document existing key chains
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{ -- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			if vim.g.have_nerd_font then
				local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
				local diagnostic_signs = {}
				for type, icon in pairs(signs) do
					diagnostic_signs[vim.diagnostic.severity[type]] = icon
				end
				vim.diagnostic.config({ signs = { text = diagnostic_signs } })
			end

			local servers = {
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							["local"] = "github.com/bayer-int,github.com/shadowglass-xyz,github.com/bloveless",
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								nilness = true,
								unusedfunc = true,
								unusedparams = true,
								unusedresult = true,
								unusedvariable = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},
				harper_ls = {},
				terraformls = {},
				intelephense = {
					init_options = {
						licenceKey = "~/.config/intelephense/license.txt",
					},
					settings = {
						intelephense = {
							files = {
								maxSize = 10000000,
							},
						},
					},
				},
				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
				buf = {},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"golangci-lint",
				"tflint",
				"tfsec",
				"delve",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup(servers[server_name] or {})
					end,
				},
			})
		end,
	},

	{ -- automatically run code actions on save
		"fnune/codeactions-on-save.nvim",
		config = function()
			local cos = require("codeactions-on-save")
			cos.register({ "*.go" }, { "source.organizeImports" }, 2000)
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				return {
					timeout_ms = 1000,
					lsp_format = "fallback",
				}
			end,
			formatters = {},
			formatters_by_ft = {
				lua = { "stylua" },
				-- fallback to go lsp formatter
			},
		},
	},

	{ -- Code linter
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				go = { "golangcilint" },
				terraform = { "tflint", "tfsec" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	{ "ellisonleao/gruvbox.nvim", priority = 1000 },

	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd("colorscheme gruvbox")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				vim.cmd("colorscheme gruvbox")
			end,
			update_interval = 3000,
			fallback = "dark",
		},
	},

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		lazy = false,
		config = function()
			require("mini.ai").setup({ n_lines = 500 })

			require("mini.extra").setup()

			require("mini.surround").setup()

			require("mini.bracketed").setup()

			require("mini.notify").setup()

			require("mini.diff").setup()
			vim.keymap.set("n", "<leader>gd", require("mini.diff").toggle_overlay, { desc = "Toggle git diff" })

			require("mini.icons").setup()

			require("mini.files").setup({
				windows = {
					preview = true,
					width_preview = 100,
				},
			})

			require("mini.pick").setup()

			require("mini.bufremove").setup()

			require("mini.completion").setup()
		end,
		-- stylua: ignore
		keys = {
			{ "\\", function() 
    			if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end
			end, desc = "File explorer" },
			{ "<leader>sf", function() MiniPick.builtin.files() end, desc = "Find Files" },
			{ "<leader>sr", function() MiniPick.builtin.resume() end, desc = "Resume last search" },
			{ "<leader>sg", function() MiniPick.builtin.grep_live() end, desc = "Grep" },
			{ "<leader>sb", function() MiniPick.builtin.buffers() end, desc = "Buffers" },
			{ "<leader>sh", function() MiniPick.builtin.help() end, desc = "Help" },
			{ "gd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, desc = "Goto Definition" },
			{ "gD", function() MiniExtra.pickers.lsp({ scope = "declaration" }) end, desc = "Goto Delcaration" },
			{ "gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, nowait = true, desc = "References" },
			{ "gI", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, desc = "Goto Implementation" },
			{ "gy", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, desc = "Goto T[y]pe Definition" },
			{ "<leader>ss", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end, desc = "LSP Symbols" },
			{ "<leader>bd", function() MiniBufremove.delete() end, desc = "Buffer Delete" },
		},
	},

	{ -- statusline
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"blade",
				"c",
				"diff",
				"go",
				"gomod",
				"gowork",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = { enable = true },
		},
		config = function(_, opts)
			---@class ParserInfo
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}

			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{ -- create sessions automatically
		"rmagatti/auto-session",
		opts = {
			pre_save_cmds = {
				"tabdo Trouble close",
			},
		},
		config = function(_, opts)
			require("auto-session").setup(opts)
		end,
	},

	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	{ -- test runner
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"fredrikaverpil/neotest-golang", -- Installation
				dependencies = {
					"uga-rosa/utf8.nvim", -- Additional dependency required
				},
			},
		},
		config = function()
			require("neotest").setup({
				-- See all config options with :h neotest.Config
				discovery = {
					-- Drastically improve performance in ginormous projects by
					-- only AST-parsing the currently opened buffer.
					enabled = false,
				},
				running = {
					-- Run tests concurrently when an adapter provides multiple commands to run.
					concurrent = true,
				},
				adapters = {
					require("neotest-golang")({ sanitize_output = true }), -- Registration
				},
			})
		end,
		-- stylua: ignore
		keys = {
			{ "<leader>t", "", desc = "+test" },
			{ "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
			{ "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
			{ "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
			{ "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
			{ "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
			{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
			{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
			{ "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
			{ "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
			{ "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
		},
	},

	{
		"mfussenegger/nvim-dap",
		recommended = true,
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

		dependencies = {
			{ "igorlfs/nvim-dap-view", opts = {} },
			{
				"leoluz/nvim-dap-go",
				opts = {},
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},

	    -- stylua: ignore
	    keys = {
		    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
		    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
		    -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
		    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
		    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
		    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
		    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
		    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
		    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
		    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
		    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
		    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
		    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
		    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
		    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
		    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
	    },
	},

	{
		"lewis6991/hover.nvim",
		config = function()
			require("hover").setup({
				init = function()
					-- Require providers
					require("hover.providers.lsp")
					require("hover.providers.gh")
					-- require('hover.providers.gh_user')
					-- require('hover.providers.jira')
					require("hover.providers.dap")
					-- require('hover.providers.fold_preview')
					require("hover.providers.diagnostic")
					-- require('hover.providers.man')
					-- require("hover.providers.dictionary")
				end,
				preview_opts = {
					border = "single",
				},
				preview_window = false,
				title = true,
				mouse_providers = {
					"LSP",
				},
				mouse_delay = 1000,
			})
			vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
		end,
	},

	{
		"nanozuki/tabby.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("tabby").setup({
				preset = "active_wins_at_tail",
			})

			vim.api.nvim_set_keymap("n", "H", "<cmd>tabn<cr>", { noremap = true })
			vim.api.nvim_set_keymap("n", "L", "<cmd>tabp<cr>", { noremap = true })
		end,
	},

	{
		"Bekaboo/dropbar.nvim",
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},

	-- "github/copilot.vim",

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "CodeCompanion" },
				},
				ft = { "markdown", "CodeCompanion" },
			},
		},
		keys = {
			{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
		},
		opts = {
			strategies = {
				chat = {
					adapter = "copilot",
				},
				inline = {
					adapter = "copilot",
				},
			},
			adapters = {
				qwen25 = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "qwen2.5-coder:14b", -- Give this adapter a different name to differentiate it from the default ollama adapter
						schema = {
							model = {
								default = "qwen2.5-coder:14b",
							},
							num_ctx = {
								default = 16384,
							},
							num_predict = {
								default = -1,
							},
						},
					})
				end,
			},
		},
	},
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
