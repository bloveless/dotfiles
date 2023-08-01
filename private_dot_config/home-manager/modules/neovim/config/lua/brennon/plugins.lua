--################### START ALPHA ###################--

local dashboard = require("alpha.themes.dashboard")
local logo = [[

███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                  
]]

dashboard.section.header.val = vim.split(logo, "\n")
dashboard.section.buttons.val = {
	dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", " " .. " File explorer", ":NvimTreeOpen<CR>"),
	dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
	dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
	dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
	dashboard.button("q", " " .. " Quit", ":qa<CR>"),
}
for _, button in ipairs(dashboard.section.buttons.val) do
	button.opts.hl = "AlphaButtons"
	button.opts.hl_shortcut = "AlphaShortcut"
end
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"
dashboard.opts.layout[1].val = 8

require("alpha").setup(dashboard.opts)

--################### END ALPHA ###################--

--################### START COMMENT ###################--

require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
		end,
	},
})

--################### END COMMENT ###################--

--################### START GITSIGNS ###################--

require("gitsigns").setup()

--################### END GITSIGNS ###################--

--################### START LUALINE ###################--

require("lualine").setup({
	options = {
		theme = "catppuccin",
	},
})

--################### END LUALINE ###################--

--################### START NOTIFY ###################--

local notify = require("notify")
notify.setup({
	top_down = false,
	background_colour = "#000000",
	timeout = 3000,
	max_height = function()
		return math.floor(vim.o.lines * 0.75)
	end,
	max_width = function()
		return math.floor(vim.o.columns * 0.75)
	end,
})

vim.notify = notify

require("telescope").load_extension("notify")

--################### END NOTIFY ###################--

--################### START PERSISTENCE ###################--

require("persistence").setup()

--################### END PERSISTENCE ###################--

--################### START SURROUND ###################--

require("nvim-surround").setup()

--################### END SURROUND ###################--

--################### START TELESCOPE ###################--

-- You don't need to set any of these options. These are the default ones. Only
-- the loading is important
require("telescope").setup({})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", function()
	builtin.find_files({ hidden = true })
end, {})
vim.keymap.set("n", "<leader>sg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>sb", builtin.buffers, {})
vim.keymap.set("n", "<leader>sh", builtin.help_tags, {})

--################### END TELESCOPE ###################--

--################### MINI INDENT SCOPE ###################--

require("mini.indentscope").setup({
	symbol = "│",
	options = {
		try_as_border = true,
	},
})

--################### END MINI INDENT SCOPE ###################--

--################### START NOICE ###################--

require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
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
})

--################### END NOICE ###################--

--################### START FIDGET ###################--

require("fidget").setup({})

--################### END FIDGET ###################--

--################### START TERRAFORM ###################--

-- setup terraform file types
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

-- terraform format and align on save
vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])

--################### END TERRAFORM ###################--

--################### START NEO-TREE ###################--

-- require("neo-tree").setup({
--     sources = { "filesystem", "buffers", "git_status", "document_symbols" },
--     open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
--     enable_git_status = true,
--     enable_diagnostics = true,
--     filesystem = {
--         filtered_items = {
--             visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
--             hide_dotfiles = true,
--             hide_gitignored = true,
--         },
--         bind_to_cwd = false,
--         follow_current_file = { enabled = true },
--         use_libuv_file_watcher = true,
--     },
--     buffers = {
--         follow_current_file = { enabled = true },
--     },
--     window = {
--         mappings = {
--             ["<space>"] = "none",
--         },
--     },
--     default_component_configs = {
--         indent = {
--             with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
--             expander_collapsed = "",
--             expander_expanded = "",
--             expander_highlight = "NeoTreeExpander",
--         },
--         git_status = {
--             symbols = {
--                 -- Change type
--                 added     = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
--                 modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
--                 deleted   = "✖", -- this can only be used in the git_status source
--                 renamed   = "󰁕", -- this can only be used in the git_status source
--                 -- Status type
--                 untracked = "",
--                 ignored   = "",
--                 unstaged  = "󰄱",
--                 staged    = "",
--                 conflict  = "",
--             }
--         },
--     },
-- })

--################### END NEO-TREE ###################--

--################### START NVIM-TREE ###################--

local NVIM_TREE_HEIGHT_RATIO = 0.8 -- You can change this
local NVIM_TREE_WIDTH_RATIO = 0.5 -- You can change this too

require("nvim-tree").setup({
	view = {
		float = {
			enable = true,
			open_win_config = function()
				local screen_w = vim.opt.columns:get()
				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
				local window_w = screen_w * NVIM_TREE_WIDTH_RATIO
				local window_h = screen_h * NVIM_TREE_HEIGHT_RATIO
				local window_w_int = math.floor(window_w)
				local window_h_int = math.floor(window_h)
				local center_x = (screen_w - window_w) / 2
				local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
				return {
					border = "rounded",
					relative = "editor",
					row = center_y,
					col = center_x,
					width = window_w_int,
					height = window_h_int,
				}
			end,
		},
		width = function()
			return math.floor(vim.opt.columns:get() * NVIM_TREE_WIDTH_RATIO)
		end,
	},
	update_focused_file = {
		enable = true,
	},
	diagnostics = {
		enable = true,
	},
})

--################### END NVIM-TREE ###################--

--################### START TREESITTER ###################--

require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<C-space>",
			scope_incremental = false,
			node_decremental = "<bs>",
		},
	},
	context_commentstring = {
		enable = true,
	},
})

--################### END TREESITTER ###################--

--################### START GO ###################--

require("go").setup()

--################### END GO ###################--
