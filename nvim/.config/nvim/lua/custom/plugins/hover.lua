-- hover.nvim: context-aware hover providers with K to cycle
-- Press K to open hover, K again to enter the window and cycle sources with <C-n>/<C-p>

vim.pack.add { 'https://github.com/lewis6991/hover.nvim' }

require('hover').config {
  providers = {
    'hover.providers.lsp',
    'hover.providers.diagnostic',
  },
  preview_opts = {
    border = 'rounded',
  },
  title = true,
}

local hover = require 'hover'

vim.keymap.set('n', 'K', function() hover.open() end, { desc = 'Hover (open)' })

vim.keymap.set('n', '<C-n>', function() hover.switch 'next' end, { desc = 'Hover (next source)' })

vim.keymap.set('n', '<C-p>', function() hover.switch 'previous' end, { desc = 'Hover (previous source)' })
