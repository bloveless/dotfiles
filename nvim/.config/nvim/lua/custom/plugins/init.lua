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
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- nvim v0.8.0
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },

  -- Lazy
  {
    'crnvl96/lazydocker.nvim',
    event = 'VeryLazy',
    opts = {}, -- automatically calls `require("lazydocker").setup()`
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { '<leader>gd', '<cmd>LazyDocker<cr>', desc = 'LazyDocker' },
    },
  },

  {
    'folke/trouble.nvim',
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
          theme = 'gruvbox',
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

  {
    'romgrk/barbar.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- patched fonts support
      'lewis6991/gitsigns.nvim', -- display git status
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    config = function()
      local barbar = require 'barbar'

      barbar.setup {
        clickable = true, -- Enables/disables clickable tabs
        tabpages = false, -- Enable/disables current/total tabpages indicator (top right corner)
        insert_at_end = true,
        icons = {
          button = '',
          buffer_index = true,
          filetype = { enabled = true },
          visible = { modified = { buffer_number = false } },
          gitsigns = {
            added = { enabled = true, icon = '+' },
            changed = { enabled = true, icon = '~' },
            deleted = { enabled = true, icon = '-' },
          },
        },
      }

      -- key maps

      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }

      -- Move to previous/next
      map('n', 'H', '<Cmd>BufferPrevious<CR>', opts)
      map('n', 'L', '<Cmd>BufferNext<CR>', opts)
      -- Re-order to previous/next
      -- map('n', '<A-H>', '<Cmd>BufferMovePrevious<CR>', opts)
      -- map('n', '<A-L>', '<Cmd>BufferMoveNext<CR>', opts)
      -- Goto buffer in position...
      -- map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
      -- map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
      -- map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
      -- map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
      -- map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
      -- map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
      -- map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
      -- map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
      -- map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
      -- map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
      -- Pin/unpin buffer
      -- map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
      -- Close buffer
      map('n', '<C-c>', '<Cmd>BufferClose<CR>', opts)
      -- map('n', '<A-b>', '<Cmd>BufferCloseAllButCurrent<CR>', opts)
    end,
  },
}
