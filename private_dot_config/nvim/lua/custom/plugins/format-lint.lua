return {
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
      local util = require('formatter.util')

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

          -- all go formatting is handled by go plugin

          -- Use the special "*" filetype for defining formatter configurations on
          -- any filetype
          ['*'] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require('formatter.filetypes.any').remove_trailing_whitespace,
          },
        },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          vim.api.nvim_cmd({
            cmd = 'FormatWrite'
          }, {})
        end,
      })
    end,
  },
}
