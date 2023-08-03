return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.gomodifytags,
          null_ls.builtins.code_actions.impl,
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.goimports_reviser,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.completion.spell,
          null_ls.builtins.diagnostics.cspell,
        },
      })
    end,
  },
}
