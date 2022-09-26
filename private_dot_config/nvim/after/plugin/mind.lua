require("mind").setup({
  width = 50
})

vim.keymap.set('n', '<leader>mp', require("mind").open_project)
vim.keymap.set('n', '<leader>mg', require("mind").open_main)
