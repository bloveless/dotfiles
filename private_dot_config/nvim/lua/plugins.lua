-- Automatically bootstrap packer when initializing a new editor
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Auto recompile whenever this file is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'morhetz/gruvbox'

  -- golang
  use { 'fatih/vim-go', run = ':GoUpdateBinaries' }
  -- use 'ray-x/go.nvim'

  -- fancy icons
  use 'kyazdani42/nvim-web-devicons'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'}, -- This is a dependency for telescope-zoxide
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
      {'jvgrootveld/telescope-zoxide'}
    }
  }

	use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
	use 'WhoIsSethDaniel/mason-tool-installer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- For luasnip users.
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  use 'tpope/vim-surround'
  use 'tpope/vim-obsession'
  use 'tpope/vim-commentary'

  use 'editorconfig/editorconfig-vim'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    'lewis6991/gitsigns.nvim',
    tag = 'release',
  }

  use 'hashivim/vim-terraform'

  use '~/Projects/notical.nvim'
end)

