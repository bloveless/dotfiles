return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              ["local"] = "github.com/bayer-int,github.com/shadowglass-xyz,github.com/bloveless",
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
      },
    },
  },
  { -- automatically run code actions on save
    "fnune/codeactions-on-save.nvim",
    config = function()
      local cos = require("codeactions-on-save")
      cos.register({ "*.go" }, { "source.organizeImports" }, 2000)
    end,
  },
}
