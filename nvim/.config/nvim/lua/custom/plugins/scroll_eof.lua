-- scrollEOF.nvim: enforce `scrolloff` past the end of the file
-- https://github.com/Aasim-A/scrollEOF.nvim

vim.pack.add { 'https://github.com/Aasim-A/scrollEOF.nvim' }

require('scrollEOF').setup {
  insert_mode = true,
  floating = false,
  disabled_filetypes = { 'terminal', 'neo-tree', 'qf' },
}
