return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft['clojure'] = nil
      lint.linters_by_ft['dockerfile'] = { 'hadolint' }
      lint.linters_by_ft['go'] = { 'golangcilint' }
      lint.linters_by_ft['inko'] = nil
      lint.linters_by_ft['janet'] = nil
      lint.linters_by_ft['json'] = { 'jsonlint' }
      lint.linters_by_ft['markdown'] = { 'markdownlint' }
      lint.linters_by_ft['rst'] = nil
      lint.linters_by_ft['ruby'] = nil
      lint.linters_by_ft['terraform'] = { 'tflint' }
      lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
