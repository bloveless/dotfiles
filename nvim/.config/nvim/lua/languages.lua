local add, now = MiniDeps.add, MiniDeps.now

now(function() -- Autocompletion
	add({
		source = "hrsh7th/nvim-cmp",
		depends = {
			-- Snippet Engine & its associated nvim-cmp source
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
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
		},
	})
end)

now(function() -- treesitter
	add({
		source = "nvim-treesitter/nvim-treesitter",
		-- Use 'master' while monitoring updates in 'main'
		checkout = "master",
		monitor = "main",
		-- Perform action after every checkout
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	add({
		source = "nvim-treesitter/nvim-treesitter-textobjects",
	})

	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"go",
			"gomod",
			"gosum",
			"gotmpl",
			"hcl",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"php",
			"query",
			"vim",
			"vimdoc",
		},
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	})
	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

	parser_config.blade = {
		install_info = {
			url = "https://github.com/EmranMR/tree-sitter-blade",
			files = { "src/parser.c" },
			branch = "main",
		},
		filetype = "blade",
	}
end)

now(function() -- auto-formatting
	add({
		source = "stevearc/conform.nvim",
	})

	require("conform").setup({
		-- log_level = vim.log.levels.DEBUG,
		format_after_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style.
			local disable_filetypes = { c = true, cpp = true }
			local lsp_format_opt
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			return {
				lsp_format = lsp_format_opt,
			}
		end,
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
	})

	vim.keymap.set("n", "<leader>f", function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, { desc = "[F]ormat buffer" })
end)

now(function() -- linting
	add({
		source = "mfussenegger/nvim-lint",
	})

	local lint = require("lint")
	table.insert(lint.linters.phpstan.args, "--memory-limit=256M")

	-- To allow other plugins to add linters to require('lint').linters_by_ft,
	lint.linters_by_ft = lint.linters_by_ft or {}
	lint.linters_by_ft["clojure"] = nil
	lint.linters_by_ft["dockerfile"] = { "hadolint" }
	lint.linters_by_ft["go"] = { "golangcilint", "revive" }
	lint.linters_by_ft["inko"] = nil
	lint.linters_by_ft["janet"] = nil
	lint.linters_by_ft["json"] = { "jsonlint" }
	lint.linters_by_ft["markdown"] = { "markdownlint" }
	lint.linters_by_ft["rst"] = nil
	lint.linters_by_ft["ruby"] = nil
	lint.linters_by_ft["terraform"] = { "tflint", "tfsec" }
	lint.linters_by_ft["docker"] = { "hadolint" }
	lint.linters_by_ft["text"] = nil
	lint.linters_by_ft["php"] = { "phpstan" }
	lint.linters_by_ft["proto"] = { "buf_lint" }

	-- Create autocommand which carries out the actual linting
	-- on the specified events.
	local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		group = lint_augroup,
		callback = function()
			require("lint").try_lint()
		end,
	})
end)

now(function() -- go implements virtual text
	add({
		source = "maxandron/goplements.nvim",
	})
end)

now(function() -- lua dev
	add({
		source = "folke/lazydev.nvim",
	})

	-- Meta type definitions for the Lua platform Luvit.
	add({
		source = "Bilal2453/luvit-meta",
	})

	require("lazydev").setup({
		library = {
			-- Load luvit types when the `vim.uv` word is found
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	})
end)
