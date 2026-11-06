-- Pretty list for diagnostics, plus quickfix and location lists via :Trouble.
-- https://github.com/folke/trouble.nvim
--
-- <leader>xx workspace diagnostics, <leader>xX the current buffer.
-- <leader>cs document symbols, <leader>cl LSP definitions / references.

vim.pack.add { 'https://github.com/folke/trouble.nvim' }

require('trouble').setup()

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Trouble: diagnostics' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Trouble: buffer diagnostics' })

-- ]q / [q: step through the open Trouble list from the code window; fall back to quickfix when it's closed.
local function step(dir)
  return function()
    local trouble = require 'trouble'
    if trouble.is_open() then
      trouble[dir] { skip_groups = true, jump = true }
    else
      local ok, err = pcall(vim.cmd[dir == 'next' and 'cnext' or 'cprev'])
      if not ok then vim.notify(err, vim.log.levels.WARN) end
    end
  end
end
vim.keymap.set('n', ']q', step 'next', { desc = 'Next Trouble/quickfix item' })
vim.keymap.set('n', '[q', step 'prev', { desc = 'Previous Trouble/quickfix item' })
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<CR>', { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', { desc = 'LSP Definitions / references / ... (Trouble)' })

require('which-key').add {
  { '<leader>x', group = 'Trouble' },
  { '<leader>c', group = '[C]ode' },
}
