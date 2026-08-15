-- Neotest: run and inspect tests inline
-- https://github.com/nvim-neotest/neotest
--
-- Backends:  Go: `go test` (gotestsum optional)   Rust: cargo-nextest

vim.pack.add {
  'https://github.com/nvim-neotest/nvim-nio', -- required by neotest
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/akinsho/neotest-go',
  'https://github.com/rouge8/neotest-rust',
}

local neotest = require 'neotest'
neotest.setup {
  adapters = {
    require 'neotest-go',
    require 'neotest-rust',
  },
}

vim.keymap.set('n', '<leader>tt', function() neotest.run.run() end, { desc = '[T]est nearest' })
vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand '%') end, { desc = '[T]est [F]ile' })
vim.keymap.set('n', '<leader>ta', function() neotest.run.run(vim.uv.cwd()) end, { desc = '[T]est [A]ll files' })
vim.keymap.set('n', '<leader>tl', function() neotest.run.run_last() end, { desc = '[T]est [L]ast' })
vim.keymap.set('n', '<leader>tx', function() neotest.run.stop() end, { desc = '[T]est stop' })
vim.keymap.set('n', '<leader>to', function() neotest.output.open { enter = true } end, { desc = '[T]est [O]utput' })
vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = '[T]est [S]ummary' })
