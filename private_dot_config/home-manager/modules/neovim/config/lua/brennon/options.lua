local set = vim.opt

-- disable netrw at the very start of your init.lua (for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.g.localmapleader = ' '

set.number = true
set.relativenumber = true
set.splitright = true
set.splitbelow = true

set.autoindent = true
set.smartindent = true
set.cmdheight = 0
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.termguicolors = true

set.signcolumn = "yes"
