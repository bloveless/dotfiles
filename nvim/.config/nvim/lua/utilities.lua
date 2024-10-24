local add, now = MiniDeps.add, MiniDeps.now

now(function() -- Detect tabstop and shiftwidth automatically
	add({
		source = "tpope/vim-sleuth",
	})
end)

now(function() -- Fuzzy Finder (files, lsp, etc)
	local function make_fzf_native(params)
		vim.notify("Building fzf native extension", vim.log.levels.INFO)
		vim.cmd("lcd " .. params.path)
		vim.cmd("!make -s")
		vim.cmd("lcd -")
	end

	add({
		source = "nvim-telescope/telescope.nvim",
		depends = {
			"nvim-lua/plenary.nvim",
			{
				source = "nvim-telescope/telescope-fzf-native.nvim",
				hooks = {
					post_checkout = make_fzf_native,
					post_install = make_fzf_native,
				},
			},
			"nvim-telescope/telescope-ui-select.nvim",
			"echasnovski/mini.icons",
		},
	})

	-- [[ Configure Telescope ]]
	-- See `:help telescope` and `:help telescope.setup()`
	require("telescope").setup({
		defaults = {
			-- layout_strategy = "vertical",
			path_display = {
				shorten = 3,
				truncate = 2,
			},
			dynamic_preview_title = true,
		},
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown(),
			},
		},
	})

	-- Enable Telescope extensions if they are installed
	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")
	pcall(require("telescope").load_extension, "harpoon")

	-- See `:help telescope.builtin`
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

	-- Slightly advanced example of overriding default behavior and theme
	vim.keymap.set("n", "<leader>/", function()
		-- You can pass additional configuration to Telescope to change the theme, layout, etc.
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 0,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })

	-- It's also possible to pass additional configuration options.
	--  See `:help telescope.builtin.live_grep()` for information about particular keys
	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, { desc = "[S]earch [/] in Open Files" })

	-- Shortcut for searching your Neovim configuration files
	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [N]eovim files" })
end)

now(function() -- Collection of various small independent plugins/modules
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

	local minifiles = require("mini.files")
	minifiles.setup({
		windows = {
			preview = true,
			width_preview = 75,
		},
	})
	vim.keymap.set("n", "<leader>e", function()
		minifiles.open(vim.api.nvim_buf_get_name(0))
		minifiles.reveal_cwd()
	end, { desc = "File explorer" })

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

	require("mini.statusline").setup()

	require("mini.notify").setup()
end)

now(function() -- Generate permalinks to github
	add({
		source = "ruifm/gitlinker.nvim",
		depends = {
			"nvim-lua/plenary.nvim",
		},
	})

	require("gitlinker").setup({
		mappings = nil,
	})

	vim.keymap.set({ "n", "v" }, "<leader>gy", function()
		require("gitlinker").get_buf_range_url("n")
	end, { desc = "[g]it permalink [y]ank" })
end)

now(function() -- symbol browser
	add({
		source = "stevearc/aerial.nvim",
		depends = {
			"nvim-treesitter/nvim-treesitter",
			-- "nvim-tree/nvim-web-devicons", (using mini.icons instead)
		},
	})

	require("aerial").setup({
		on_attach = function(bufnr)
			-- Jump forwards/backwards with '{' and '}'
			vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
			vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
		end,
	})

	vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle [a]erial" })
end)

now(function() -- git
	add({
		source = "kdheepak/lazygit.nvim",
		depends = {
			"nvim-lua/plenary.nvim",
		},
	})

	vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
end)

now(function() -- sessions
	add({
		source = "folke/persistence.nvim",
	})

	require("persistence").setup({})

	vim.keymap.set("n", "<leader>qs", function()
		require("persistence").load()
	end, { desc = "[q][s] Load session" })

	vim.keymap.set("n", "<leader>qS", function()
		require("persistence").load()
	end, { desc = "[q][S] Select session to load" })

	vim.keymap.set("n", "<leader>ql", function()
		require("persistence").load({ last = true })
	end, { desc = "[q][l] Load last session" })

	vim.keymap.set("n", "<leader>qd", function()
		require("persistence").load({ last = true })
	end, { desc = "[q][d] Stop persistence, session won't be saved" })
end)
