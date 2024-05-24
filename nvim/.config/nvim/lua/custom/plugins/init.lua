-- Session management
vim.keymap.set('n', '<leader>qs', [[<cmd>lua require("persistence").load()<cr>]], { desc = 'Restore the session for the current directory' })
vim.keymap.set('n', '<leader>ql', [[<cmd>lua require("persistence").load({ last = true })<cr>]], { desc = 'Restore the last session' })
vim.keymap.set('n', '<leader>qd', [[<cmd>lua require("persistence").stop()<cr>]], { desc = "stop Persistence => session won't be saved on exit" })

return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {},
  },

  {
    'folke/trouble.nvim',
    branch = 'dev',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
    opts = {
      modes = {
        diagnostics = {
          mode = 'diagnostics',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.5,
          },
        },
        quickfix = {
          mode = 'quickfix',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.5,
          },
        },
        telescope = {
          mode = 'telescope',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.5,
          },
        },
      },
    },
  },

  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {
        '<leader>gy',
        function()
          require('gitlinker').get_buf_range_url 'n'
        end,
        mode = { 'n', 'v' },
        desc = '[g]it permalink [y]ank',
      },
    },
    opts = {
      mappings = nil,
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function(_, opts)
      local config = require('lualine').get_config()
      config = vim.tbl_deep_extend('force', config, {
        options = {
          theme = 'monokai-pro',
        },
        sections = {
          lualine_c = {
            {
              'filename',
              file_status = true,
              path = 1,
            },
          },
        },
      })

      require('lualine').setup(config)
    end,
  },

  -- necessary for blade indentation
  'jwalton512/vim-blade',
}
