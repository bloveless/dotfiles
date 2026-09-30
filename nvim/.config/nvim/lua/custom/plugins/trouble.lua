-- Pretty list for diagnostics, plus quickfix and location lists via :Trouble.
-- https://github.com/folke/trouble.nvim
--
-- <leader>xx workspace diagnostics, <leader>xX the current buffer.
-- <leader>cs document symbols, <leader>cl LSP definitions / references.

vim.pack.add { 'https://github.com/folke/trouble.nvim' }

require('trouble').setup()

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Trouble: diagnostics' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Trouble: buffer diagnostics' })
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<CR>', { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', { desc = 'LSP Definitions / references / ... (Trouble)' })

require('which-key').add {
  { '<leader>x', group = 'Trouble' },
  { '<leader>c', group = '[C]ode' },
}
