return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "cspell" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "davidmh/cspell.nvim",
    },
    config = function()
      local cspell = require("cspell")
      require("null-ls").setup({
        sources = {
          cspell.diagnostics,
        },
      })
    end,
  },
}
