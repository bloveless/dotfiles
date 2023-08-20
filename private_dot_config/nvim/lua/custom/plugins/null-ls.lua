return {
  -- {
  --   'jose-elias-alvarez/null-ls.nvim',
  --   config = function()
  --     local null_ls = require 'null-ls'
  --
  --     null_ls.setup {
  --       sources = {
  --         null_ls.builtins.code_actions.gomodifytags,
  --         null_ls.builtins.code_actions.impl,
  --         null_ls.builtins.formatting.gofumpt,
  --         null_ls.builtins.formatting.goimports_reviser,
  --         -- null_ls.builtins.formatting.stylua,
  --         -- null_ls.builtins.code_actions.eslint_d,
  --         -- null_ls.builtins.diagnostics.eslint_d,
  --         -- null_ls.builtins.formatting.prettier,
  --         null_ls.builtins.completion.spell,
  --         null_ls.builtins.diagnostics.cspell,
  --       },
  --     }
  --   end,
  -- },
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        javascript = { 'eslint_d' },
        javascripreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
  {
    'mhartington/formatter.nvim',
    config = function()
      -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
      require('formatter').setup {
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        -- All formatter configurations are opt-in
        filetype = {
          -- Formatter configurations for filetype "lua" go here
          -- and will be executed in order
          lua = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require('formatter.filetypes.lua').stylua,
          },

          javascript = {
            require 'formatter.defaults.prettierd',
          },

          javascriptreact = {
            require 'formatter.defaults.prettierd',
          },

          typescript = {
            require 'formatter.defaults.prettierd',
          },

          typescriptreact = {
            require 'formatter.defaults.prettierd',
          },

          go = {
            require('formatter.filetypes.go').gofumpt,
            {
              exe = "goimports-reviser",
              stdin = true,
            }
          },

          -- Use the special "*" filetype for defining formatter configurations on
          -- any filetype
          ['*'] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require('formatter.filetypes.any').remove_trailing_whitespace,
          },
        },
      }
    end,
  },
}
