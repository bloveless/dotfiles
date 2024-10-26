return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- lots of things use this so just execute it immediately
			local icons = require("mini.icons")
			icons.setup()
			icons.mock_nvim_web_devicons()

			-- setup basic editor settings. Do this first so that plugins that are loaded after it will use these settings (specifically leader keys)
			require("mini.basics").setup({
				options = {
					-- Extra UI features ('winblend', 'cmdheight=0', ...)
					extra_ui = true,
				},
				mappings = {
					-- Window navigation with <C-hjkl>, resize with <C-arrow>
					windows = true,
				},
				autocommands = {
					-- Set 'relativenumber' only in linewise and blockwise Visual mode
					relnum_in_visual_mode = true,
				},
			})

			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- lsp info and other notifications
			-- require("mini.git").setup()
			-- require("mini.diff").setup()
			-- icons.mock_nvim_web_devicons()

			require("mini.extra").setup()

			-- local minifiles = require("mini.files")
			-- minifiles.setup({
			-- 	windows = {
			-- 		preview = true,
			-- 		width_preview = 75,
			-- 	},
			-- })
			-- vim.keymap.set("n", "<leader>e", function()
			-- 	minifiles.open(vim.api.nvim_buf_get_name(0))
			-- 	minifiles.reveal_cwd()
			-- end, { desc = "File explorer" })

			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
					hack = { pattern = "HACK", group = "MiniHipatternsHack" },
					todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
					note = { pattern = "NOTE", group = "MiniHipatternsNote" },
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			require("mini.bufremove").setup()
			vim.keymap.set("n", "<leader>w", function()
				require("mini.bufremove").delete(0, false)
			end, { desc = "buffer delete" })

			-- this is already done by something else... although I'm not sure what
			require("mini.cursorword").setup()

			-- require("mini.statusline").setup()

			-- require("mini.notify").setup()
		end,
	},
}
