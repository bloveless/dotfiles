return {
  { -- Golang setup
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup {
        lsp_cfg = false,
        lsp_gofumpt = true,
        goimport = 'goimport-revise',
        tag_transform = 'camelcase',
        tag_options = '',
        lsp_inlay_hints = {
          style = 'eol',
        },
      }
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
