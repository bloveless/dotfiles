vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.setup()
