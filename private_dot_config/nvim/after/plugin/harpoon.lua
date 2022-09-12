require('harpoon').setup {}
require("telescope").load_extension('harpoon')

vim.keymap.set('n', '<leader>hh', require('harpoon.ui').toggle_quick_menu)
vim.keymap.set('n', '<leader>hn', require('harpoon.ui').nav_next)
vim.keymap.set('n', '<leader>hp', require('harpoon.ui').nav_prev)
vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file)
vim.keymap.set('n', '<leader>h1', function () require('harpoon.ui').nav_file(1) end)
vim.keymap.set('n', '<leader>h2', function () require('harpoon.ui').nav_file(2) end)
vim.keymap.set('n', '<leader>h3', function () require('harpoon.ui').nav_file(3) end)
vim.keymap.set('n', '<leader>fm', '<cmd>Telescope harpoon marks<cr>')


