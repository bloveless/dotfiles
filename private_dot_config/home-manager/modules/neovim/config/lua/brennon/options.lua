local set = vim.opt

vim.g.mapleader = ' '
vim.g.localmapleader = ' '

set.number = true
set.relativenumber = true
set.splitright = true
set.splitbelow = true

set.cmdheight = 0
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.termguicolors = true

set.signcolumn = "yes"

local opt = vim.opt

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.confirm = true    -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.list = true       -- Show some invisible characters (tabs...
