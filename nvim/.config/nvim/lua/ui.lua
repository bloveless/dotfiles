local add, now = MiniDeps.add, MiniDeps.now

now(function() -- colorscheme
	add({
		source = "catppuccin/nvim",
	})

	require("catppuccin").setup({
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
	})

	vim.cmd([[colorscheme catppuccin-macchiato]])
end)

now(function() -- vscode style breadcrumbs
	add({
		source = "utilyre/barbecue.nvim",
		depends = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
	})

	-- triggers CursorHold event faster
	vim.opt.updatetime = 200

	require("barbecue").setup({
		theme = "catppuccin-macchiato",
		create_autocmd = false, -- prevent barbecue from updating itself automatically
		exclude_filetypes = { "toggleterm" },
	})

	vim.api.nvim_create_autocmd({
		"WinScrolled", -- or WinResized on NVIM-v0.9 and higher
		"BufWinEnter",
		"CursorHold",
		"InsertLeave",

		-- include this if you have set `show_modified` to `true`
		"BufModifiedSet",
	}, {
		group = vim.api.nvim_create_augroup("barbecue.updater", {}),
		callback = function()
			require("barbecue.ui").update()
		end,
	})
end)

now(function() -- show cursor column only on specific file types
	add({
		-- source = "tummetott/reticle.nvim",
		-- revert back to tummetott if https://github.com/tummetott/reticle.nvim/pull/13 gets merged
		source = "bloveless/reticle.nvim",
	})

	require("reticle").setup({
		on_startup = {
			cursorline = true,
			cursorcolumn = false,
		},
		always = {
			cursorcolumn = {
				"yaml",
				"python",
			},
		},
	})
end)

now(function() -- diagnostics in the scrollbar
	add({
		source = "petertriho/nvim-scrollbar",
	})

	require("scrollbar").setup()
end)

now(function() -- render markdown in terminal with glow
	add({
		source = "ellisonleao/glow.nvim",
	})

	require("glow").setup()
end)

now(function() -- Adds git related signs to the gutter, as well as utilities for managing changes
	add({
		source = "lewis6991/gitsigns.nvim",
		depends = {
			"petertriho/nvim-scrollbar",
		},
	})

	require("gitsigns").setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Jump to next git [c]hange" })

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Jump to previous git [c]hange" })

			-- Actions
			-- visual mode
			map("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "stage git hunk" })
			map("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "reset git hunk" })
			-- normal mode
			map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
			map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
			map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
			map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
			map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
			map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
			map("n", "<leader>gb", gitsigns.blame_line, { desc = "git [b]lame line" })
			map("n", "<leader>gd", gitsigns.diffthis, { desc = "git [d]iff against index" })
			map("n", "<leader>gD", function()
				gitsigns.diffthis("@")
			end, { desc = "git [D]iff against last commit" })
			-- Toggles
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
			map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
		end,
	})
	require("scrollbar.handlers.gitsigns").setup()
end)

now(function() -- Useful plugin to show you pending keybinds.
	add({
		source = "folke/which-key.nvim",
	})

	require("which-key").setup({
		icons = {
			-- set icon mappings to true if you have a Nerd Font
			mappings = vim.g.have_nerd_font,
			-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
			-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
			keys = vim.g.have_nerd_font and {} or {
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				C = "<C-…> ",
				M = "<M-…> ",
				D = "<D-…> ",
				S = "<S-…> ",
				CR = "<CR> ",
				Esc = "<Esc> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				NL = "<NL> ",
				BS = "<BS> ",
				Space = "<Space> ",
				Tab = "<Tab> ",
				F1 = "<F1>",
				F2 = "<F2>",
				F3 = "<F3>",
				F4 = "<F4>",
				F5 = "<F5>",
				F6 = "<F6>",
				F7 = "<F7>",
				F8 = "<F8>",
				F9 = "<F9>",
				F10 = "<F10>",
				F11 = "<F11>",
				F12 = "<F12>",
			},
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
	})
end)
