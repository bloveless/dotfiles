-- Map leader to space
vim.g.mapleader = ' '
vim.g.catppuccin_flavour = "macchiato"
--
-- disable netrw at the very start of your init.lua (strongly advised for nvim-tree)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

require('brennon.globals')
require('brennon.plugins')

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

vim.opt.syntax = "enable"
-- vim.cmd "colorscheme gruvbox"
vim.cmd "colorscheme catppuccin"
-- Make the background transparent so it uses the terminal background color
vim.cmd [[ hi normal guibg=000000 ]]

-- Hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.signcolumn = "yes"

-- Enable powerline fonts for airline
vim.g.airline_powerline_fonts = 1

-- Netrw config settings
-- vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
-- vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 20

-- Default spaces instead of tabs
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = '>-', lead = '.', trail = '~', precedes = '<', extends = '>' }

-- Automatically trim trailing whitespace on save
-- if there are any issues with this (I.E. files that need trailing whitespace)
-- consider this link https://vim.fandom.com/wiki/Remove_unwanted_spaces for
-- solutions
vim.cmd [[autocmd BufWritePre * :%s/\s\+$//e]]

vim.keymap.set('n', '<leader>ex', '<cmd>Explore<cr>')
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })

-- Open new splits on the right and below the current buffer by default
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Set search to use case sensitive queries only if the user provides cases
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set('n', '<leader><leader>x', SaveAndExec)

-- Global status bar
vim.opt.laststatus = 3
-- Show the current filename and modified status at the top right of the window
vim.opt.winbar = '%=%m %f'

-- Use ctrl-[hjkl] to select the active split!
vim.keymap.set('n', '<c-k>', '<cmd>wincmd k<cr>', { silent = true })
vim.keymap.set('n', '<c-j>', '<cmd>wincmd j<cr>', { silent = true })
vim.keymap.set('n', '<c-h>', '<cmd>wincmd h<cr>', { silent = true })
vim.keymap.set('n', '<c-l>', '<cmd>wincmd l<cr>', { silent = true })

-- Keep the cursor away from the edge of the screen by 8 lines. Use 999 to keep it in the very center of the screen
vim.opt.scrolloff = 8

