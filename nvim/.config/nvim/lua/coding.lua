local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
	require("mini.completion").setup()
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

later(function() -- quick diagnostics display
	add({
		source = "folke/trouble.nvim",
	})

	require("trouble").setup()

	vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
	vim.keymap.set(
		"n",
		"<leader>xX",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		{ desc = "Buffer Diagnostics (Trouble)" }
	)
	vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
	vim.keymap.set(
		"n",
		"<leader>cl",
		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		{ desc = "LSP Definitions / references / ... (Trouble)" }
	)
	vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
	vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
end)

later(function()
	add({
		source = "cbochs/grapple.nvim",
	})

	require("grapple").setup({
		scope = "git_branch",
	})

	vim.keymap.set("n", "<leader>m", "<cmd>Grapple toggle<cr>", { desc = "Grapple toggle tag" })
	vim.keymap.set("n", "<leader>M", "<cmd>Grapple toggle_tags<cr>", { desc = "Grapple open tags window" })
	vim.keymap.set("n", "<leader>n", "<cmd>Grapple cycle_tags next<cr>", { desc = "Grapple cycle next tag" })
	vim.keymap.set("n", "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", { desc = "Grapple cycle previous tag" })
	vim.keymap.set("n", "<leader>1", "<cmd>Grapple select index=1<cr>", { desc = "Grapple cycle index one" })
	vim.keymap.set("n", "<leader>2", "<cmd>Grapple select index=2<cr>", { desc = "Grapple cycle index two" })
	vim.keymap.set("n", "<leader>3", "<cmd>Grapple select index=3<cr>", { desc = "Grapple cycle index three" })
	vim.keymap.set("n", "<leader>4", "<cmd>Grapple select index=4<cr>", { desc = "Grapple cycle index four" })
end)

now(function()
	add({
		source = "iamcco/markdown-preview.nvim",
	})
end)

later(function()
	vim.fn["mkdp#util#install"]()
end)
