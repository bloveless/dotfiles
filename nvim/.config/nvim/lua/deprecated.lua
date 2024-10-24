-- This file exists simply to store configurations that I've tried with plugins that I'm not using right now

later(function() -- Autocompletion
	add({
		name = "nvim-cmp",
		source = "iguanacucumber/magazine.nvim",
		depends = {
			-- Adds other completion capabilities.
			{
				name = "cmp-nvim-lsp",
				source = "iguanacucumber/mag-nvim-lsp",
			},
			{
				name = "cmp-nvim-lua",
				source = "iguanacucumber/mag-nvim-lua",
			},
			{
				name = "cmp-buffer",
				source = "iguanacucumber/mag-buffer",
			},
			{
				name = "cmp-cmdline",
				source = "iguanacucumber/mag-cmdline",
			},
			"https://codeberg.org/FelipeLema/cmp-async-path",

			-- Snippet Engine & its associated nvim-cmp source
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	})

	-- See `:help cmp`
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	luasnip.config.setup({})

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		completion = { completeopt = "menu,menuone,noinsert" },

		-- For an understanding of why these mappings were
		-- chosen, you will need to read `:help ins-completion`
		--
		-- No, but seriously. Please read `:help ins-completion`, it is really good!
		mapping = cmp.mapping.preset.insert({
			-- Select the [n]ext item
			["<C-n>"] = cmp.mapping.select_next_item(),
			-- Select the [p]revious item
			["<C-p>"] = cmp.mapping.select_prev_item(),

			-- Scroll the documentation window [b]ack / [f]orward
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),

			-- Accept ([y]es) the completion.
			["<C-y>"] = cmp.mapping.confirm({ select = true }),

			-- Manually trigger a completion from nvim-cmp.
			["<C-Space>"] = cmp.mapping.complete({}),

			-- Think of <c-l> as moving to the right of your snippet expansion.
			["<C-l>"] = cmp.mapping(function()
				if luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { "i", "s" }),
			["<C-h>"] = cmp.mapping(function()
				if luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { "i", "s" }),

			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		}),
		sources = {
			{
				name = "lazydev",
				-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
				group_index = 0,
			},
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "buffer" },
		},
	})

	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
		matching = { disallow_symbol_nonprefix_matching = false },
	})
end)

later(function()
	add({ -- autocompletion
		source = "saghen/blink.cmp",
		depends = {
			"rafamadriz/friendly-snippets",
		},
		checkout = "v0.3.1", -- check releases for latest tag
	})

	require("blink.cmp").setup({
		keymap = {
			accept = "<C-y>",
		},
		highlight = {
			-- sets the fallback highlight groups to nvim-cmp's highlight groups
			-- useful for when your theme doesn't support blink.cmp
			-- will be removed in a future release, assuming themes add support
			use_nvim_cmp_as_default = true,
		},
		-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- adjusts spacing to ensure icons are aligned
		nerd_font_variant = "normal",

		-- experimental auto-brackets support
		-- accept = { auto_brackets = { enabled = true } }

		-- experimental signature help support
		trigger = { signature_help = { enabled = true } },

		windows = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
			},
		},
	})
end)

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

	{ -- tabbar
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			-- "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons (using mini.icons instead)
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			animation = false,
			-- insert_at_start = true,
			-- …etc.
		},
		config = function(_, opts)
			require("barbar").setup(opts)

			vim.keymap.set("n", "<C-p>", "<Cmd>BufferPick<CR>", { desc = "Buffer pick" })
			vim.keymap.set("n", "<S-l>", "<cmd>BufferNext<cr>", { desc = "Buffer next" })
			vim.keymap.set("n", "<S-h>", "<cmd>BufferPrevious<cr>", { desc = "Buffer previous" })
			vim.keymap.set("n", "<A-<>", "<Cmd>BufferMovePrevious<cr>", { desc = "Move buffer previous" })
			vim.keymap.set("n", "<A->>", "<Cmd>BufferMoveNext<cr>", { desc = "Move buffer next" })
			vim.keymap.set("n", "<leader>w", "<cmd>BufferDelete<cr>", { desc = "Buffer previous" })
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"folke/noice.nvim",
			-- "nvim-tree/nvim-web-devicons", -- optional dependency (using mini.icons instead)
		},
		config = function()
			require("lualine").setup({
				theme = "catppuccin",
				sections = {
					lualine_x = {
						{
							require("noice").api.status.command.get,
							cond = require("noice").api.status.command.has,
							color = { fg = "#ff9e64" },
						},
						{
							require("noice").api.status.mode.get,
							cond = require("noice").api.status.mode.has,
							color = { fg = "#ff9e64" },
						},
						{
							require("noice").api.status.search.get,
							cond = require("noice").api.status.search.has,
							color = { fg = "#ff9e64" },
						},
					},
				},
			})
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

	{
		"j-hui/fidget.nvim",
		opts = {},
	},
}
