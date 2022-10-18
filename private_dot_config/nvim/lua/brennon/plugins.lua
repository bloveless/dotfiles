-- Automatically bootstrap packer when initializing a new editor
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap =
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

-- Auto recompile whenever this file is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  use("gruvbox-community/gruvbox")
  use("folke/tokyonight.nvim")
  use({ "catppuccin/nvim", as = "catppuccin" })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
  })
  use("nvim-treesitter/playground")

  use("nvim-treesitter/nvim-treesitter-context")

  use("p00f/nvim-ts-rainbow")

  -- golang
  use({
    "ray-x/go.nvim",
    requires = {
      { "ray-x/guihua.lua" },
    },
  })

  -- fancy icons
  use("kyazdani42/nvim-web-devicons")

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/popup.nvim" }, -- This is a dependency for telescope-zoxide
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "jvgrootveld/telescope-zoxide" },
    },
  })

  use({
    "kyazdani42/nvim-tree.lua",
    requires = {
      { "kyazdani42/nvim-web-devicons" },
    },
  })

  -- LSP Support
  use({ "neovim/nvim-lspconfig" })
  use({ "williamboman/mason.nvim" })
  use({ "WhoIsSethDaniel/mason-tool-installer.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })

  -- Autocompletion
  use({ "hrsh7th/nvim-cmp" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-cmdline" })
  use({ "hrsh7th/cmp-path" })
  use({ "saadparwaiz1/cmp_luasnip" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-nvim-lua" })

  -- Snippets
  use({ "L3MON4D3/LuaSnip" })
  use({ "rafamadriz/friendly-snippets" })

  use("tpope/vim-surround")
  use("tpope/vim-obsession")
  use("tpope/vim-commentary")

  use("editorconfig/editorconfig-vim")

  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })

  use({ "lewis6991/gitsigns.nvim" })

  use("hashivim/vim-terraform")

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = "nvim-lua/plenary.nvim",
  })

  use({
    "ThePrimeagen/harpoon",
    requires = "nvim-lua/plenary.nvim",
  })

  use("lukas-reineke/indent-blankline.nvim")

  use("mickael-menu/zk-nvim")

  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })

  use("ellisonleao/glow.nvim")

  -- Standalone UI for nvim-lsp progress
  use("j-hui/fidget.nvim")
  -- vscode-like pictograms for neovim lsp completion items
  use("onsails/lspkind.nvim")

  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  })

  use("gorbit99/codewindow.nvim")
end)
