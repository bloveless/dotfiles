return {
	{
		"navarasu/onedark.nvim",
		enabled = false,
		priority = 1000,
		config = function()
			require("onedark").setup({
				highlights = {
					DiagnosticUnderlineWarn = {
						sp = "#513a10",
					},
				},
			})

			require("onedark").load()
		end,
	},

	{
		"neanias/everforest-nvim",
		enabled = false,
		priority = 1000,
		opts = {},
		config = function(_, opts)
			require("everforest").setup(opts)
			vim.cmd([[colorscheme everforest]])
		end,
	},

	{
		"rmehri01/onenord.nvim",
		enabled = false,
		config = function()
			require("onenord").setup()
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		enabled = false,
		opts = {},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd([[colorscheme tokyonight-moon]])
		end,
	},

	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		enabled = true,
		config = function()
			require("onedark").setup({
				highlights = {
					DiagnosticUnderlineWarn = {
						sp = "#513a10",
					},
					CursorColumn = {
						bg = "#242830",
					},
				},
			})

			require("onedark").load()
		end,
	},

	{
		"shaunsingh/nord.nvim",
		enabled = false,
		priority = 1000,
		config = function()
			require("nord").set()
		end,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		enabled = false,
		priority = 1000,
		opts = {
			variant = "moon",
		},
		config = function(_, opts)
			require("rose-pine").setup(opts)
			vim.cmd([[colorscheme rose-pine]])
		end,
	},

	{
		"AlexvZyl/nordic.nvim",
		enabled = false,
		priority = 1000,
		config = function()
			require("nordic").load()
		end,
	},

	{
		"EdenEast/nightfox.nvim",
		enabled = false,
		priority = 1000,
		opts = {},
		config = function(_, opts)
			require("nightfox").setup(opts)

			vim.cmd("colorscheme nightfox")
		end,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			cmdline = {
				view = "cmdline",
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = { -- specific messages in the mini area instead of a popup
							{ find = "%d+L, %d+B" }, -- file saved
							{ find = "; after #%d+" }, -- undo/redo
							{ find = "; before #%d+" }, -- undo/redo
							{ find = "yanked" }, -- yank
							{ find = "%d more lines" }, -- paste
							{ find = "%d fewer lines" }, -- delete
							{ find = "Already at newest change" }, -- history
						},
					},
					view = "mini",
				},
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "^/" }, -- search performed with no results will show the search performed as well as the no results message. This hides the search performed messages
						},
					},
					opt = { show = false },
				},
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
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

	{ -- better quickfix
		"stevearc/quicker.nvim",
		event = "FileType qf",
		keys = {
			{
				"<leader>q",
				function()
					require("quicker").toggle()
				end,
				desc = "Toggle quickfix",
			},
			{
				"<leader>l",
				function()
					require("quicker").toggle({ loclist = true })
				end,
				desc = "Toggle loclist",
			},
		},
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {
			keys = {
				{
					">",
					function()
						require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
					end,
					desc = "Expand quickfix context",
				},
				{
					"<",
					function()
						require("quicker").collapse()
					end,
					desc = "Collapse quickfix context",
				},
			},
		},
	},
}
