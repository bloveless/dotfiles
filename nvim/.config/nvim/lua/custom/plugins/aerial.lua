-- Code outline: symbols for the current file, from treesitter with an LSP fallback.
-- https://github.com/stevearc/aerial.nvim
--
-- Opens on the right (`prefer_right`), so it stays out of neo-tree's way.
-- Toggle with <leader>o. <leader>a is the AI group (sidekick).

vim.pack.add { 'https://github.com/stevearc/aerial.nvim' }

require('aerial').setup()

vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle!<CR>', { desc = '[O]utline' })
