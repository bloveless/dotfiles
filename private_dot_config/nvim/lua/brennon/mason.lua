require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua", "gopls", }, automatic_installation = true
})
require('mason-tool-installer').setup({
    ensure_installed = { "gopls", "gofumpt", "lua-language-server", "yaml-language-server", "typescript-language-server" },
    auto_update = true,
    run_on_start = true,
})
