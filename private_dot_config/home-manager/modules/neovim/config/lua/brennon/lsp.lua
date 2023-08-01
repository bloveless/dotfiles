local navic = require("nvim-navic")
-- local null_ls = require("null-ls")
-- local cspell = require("cspell")

-- null_ls.setup({
--   sources = {
--     null_ls.builtins.diagnostics.eslint_d,
--     null_ls.builtins.code_actions.eslint_d,
--     null_ls.builtins.code_actions.gitsigns,
--     null_ls.builtins.formatting.prettier_d_slim,
--     null_ls.builtins.formatting.terraform_fmt,
--     null_ls.builtins.diagnostics.terraform_validate,
--     null_ls.builtins.code_actions.gomodifytags,
--     null_ls.builtins.code_actions.impl,
--     null_ls.builtins.formatting.gofumpt,
--     null_ls.builtins.formatting.goimports_reviser,
--     null_ls.builtins.diagnostics.hadolint, -- dockerfile
--     cspell.diagnostics,
--     cspell.code_actions,
--   },
-- })

-- Set up nvim-cmp.
local cmp = require("cmp")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
		-- { name = 'crates' },
	}, {
		{ name = "buffer" },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = "buffer" },
	}),
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
})

-- LSP settings.
local lsp_formatting = function(bufnr, async)
	local opts = {
		async = async,
		filter = function(client)
			-- disable using tsserver formatting
			return client.name ~= "tsserver"
		end,
		bufnr = bufnr,
	}

	if vim.lsp.buf.format then
		vim.lsp.buf.format(opts)
	elseif vim.lsp.buf.formatting then
		vim.lsp.buf.formatting(opts)
	end
end

--  This function gets run when an LSP connects to a particular buffer.
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end

	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")
	nmap("[d", vim.diagnostic.goto_prev, opts)
	nmap("]d", vim.diagnostic.goto_next, opts)

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
		lsp_formatting(bufnr, true)
	end, { desc = "Format current buffer with LSP" })

	nmap("<leader>f", function()
		lsp_formatting(bufnr, true)
	end, "[F]ormat")

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr, false)
			end,
		})
	end
end

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				-- Stop suggesting environment emulations since it asks everytime no matter the selection
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

require("typescript").setup({
	disable_commands = false, -- prevent the plugin from creating Vim commands
	debug = false,         -- enable debug logging for commands
	go_to_source_definition = {
		fallback = true,   -- fall back to standard LSP definition on failure
	},
	server = {             -- pass options to lspconfig's setup method
		on_attach = on_attach,
	},
})

local rt = require("rust-tools")

rt.setup({
	tools = {
		on_initialized = function()
			vim.cmd([[
        augroup RustLSP
          autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
          autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
        augroup END
      ]])
		end,
	},
	server = {
		on_attach = on_attach,
	},
})

require("lspconfig").terraformls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

require("lspconfig").tflint.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

require("lspconfig").tailwindcss.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

require("lspconfig").gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		gopls = {
			gofumpt = true,
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
				fieldalignment = true,
				nilness = true,
				unusedparams = true,
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
})

require("lspconfig").docker_compose_language_service.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

require("lspconfig").dockerls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

require("lspconfig").svelte.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

local efmls = require("efmls-configs")

efmls.init({
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = { documentFormatting = true },
	-- Use a list of default configurations
	-- set by this plugin
	-- (Default: false)
	default_config = false,
})

local fs = require('efmls-configs.fs')

local eslint = require("efmls-configs.linters.eslint")
local prettier = require("efmls-configs.formatters.prettier")

local cspellLinter = 'cspell'
local cspellBin = fs.executable(cspellLinter, fs.Scope.NODE)
local cspellArgs = 'lint --no-progress --no-summary --no-color'
local cspellCommand = string.format('%s %s', cspellBin, cspellArgs)

local cspell = {
	prefix = cspellLinter,
	lintCommand = cspellCommand,
	lintFormats = { '%f:%l:%c - %m', '%f:%l:%c %m' },
	rootMarkers = {
		'package.json',
		'.cspell.json',
		'cspell.json',
		'.cSpell.json',
		'cSpell.json',
		'cspell.config.js',
		'cspell.config.cjs',
		'cspell.config.json',
		'cspell.config.yaml',
		'cspell.config.yml',
		'cspell.yaml',
		'cspell.yml',
	},
}

require("lspconfig").efm.setup({
	filetypes = { "typescript", "javascript", "lua", "svelte" },
	settings = {
		rootMarkers = { ".git/" },
		languages = {
			lua = {
				require("efmls-configs.linters.luacheck"),
				require("efmls-configs.formatters.stylua"),
			},
			go = {
				{ formatCommand = "goimports-reviser", formatStdin = true },
			},
			javascript = {
				require('efmls-configs.linters.eslint'),
				require('efmls-configs.formatters.prettier'),
			},
			javascriptreact = {
				require('efmls-configs.linters.eslint'),
				require('efmls-configs.formatters.prettier'),
			},
			typescript = {
				require('efmls-configs.linters.eslint'),
				require('efmls-configs.formatters.prettier'),
			},
			typescriptreact = {
				require('efmls-configs.linters.eslint'),
				require('efmls-configs.formatters.prettier'),
			},
			svelte = {
				require('efmls-configs.linters.eslint'),
				require('efmls-configs.formatters.prettier'),
			},
			["="] = {
				cspell
			}
		},
	},
})
