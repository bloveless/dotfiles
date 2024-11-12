return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        intelephense = {
          init_options = {
            licenceKey = "~/.config/intelephense/license.txt",
          },
          settings = {
            intelephense = {
              files = {
                maxSize = 10000000,
              },
            },
          },
        },
      },
      document_highlight = false,
      inlay_hints = {
        enabled = false,
      },
    },
  },
}
