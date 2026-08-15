-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

-- Toggle the tree with <leader>e; `\` reveals the current file
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'NeoTree toggle', silent = true })
vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  -- Close Neo-tree if it is the last window left in the tab
  close_if_last_window = true,
  filesystem = {
    -- Keep the tree in sync with the active buffer
    follow_current_file = {
      enabled = true,
    },
    window = {
      position = 'right',
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}

-- Open the tree automatically when Neovim starts in a directory
--  (i.e. plain `nvim`, or `nvim .`); skip it when opening files directly.
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Open Neo-tree when Neovim starts with a directory (or no arguments)',
  group = vim.api.nvim_create_augroup('kickstart-neotree-autoopen', { clear = true }),
  callback = function()
    local argv0 = vim.fn.argv(0) --[[@as string]]
    if vim.fn.argc() == 0 or (argv0 ~= '' and vim.fn.isdirectory(argv0) == 1) then
      vim.cmd 'Neotree show'
      -- Keep focus in the (restored) file window, not the tree
      vim.cmd 'wincmd p'
    end
  end,
})
