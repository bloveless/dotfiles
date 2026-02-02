return {
  { 'zbirenbaum/copilot.lua', opts = {} },

  {
    'folke/sidekick.nvim',
    opts = {
      cli = {
        mux = {
          backend = 'zellij',
          enabled = true,
        },
        tools = {
          amp = {
            cmd = { 'amp' },
            format = function(text)
              local Text = require 'sidekick.text'
              Text.transform(text, function(str) return str:find '[^%w/_%.%-]' and ('"' .. str .. '"') or str end, 'SidekickLocFile')
              local ret = Text.to_string(text)
              -- transform line ranges to a format that amp understands
              ret = ret:gsub('@([^ ]+)%s*:L(%d+):C%d+%-L(%d+):C%d+', '@%1#L%2-%3') -- @file :L5:C20-L6:C8 => @file#L5-6
              ret = ret:gsub('@([^ ]+)%s*:L(%d+):C%d+%-C%d+', '@%1#L%2') -- @file :L5:C9-C29 => @file#L5
              ret = ret:gsub('@([^ ]+)%s*:L(%d+)%-L(%d+)', '@%1#L%2-%3') -- @file :L5-L13 => @file#L5-13
              ret = ret:gsub('@([^ ]+)%s*:L(%d+):C%d+', '@%1#L%2') -- @file :L5:C9 => @file#L5
              ret = ret:gsub('@([^ ]+)%s*:L(%d+)', '@%1#L%2') -- @file :L5 => @file#L5
              return ret
            end,
          },
          ['csgdaa-code'] = {
            cmd = { 'csgdaa-code' },
          },
        },
      },
    },
    keys = {
      {
        '<tab>',
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require('sidekick').nes_jump_or_apply() then
            return '<Tab>' -- fallback to normal tab
          end
        end,
        expr = true,
        desc = 'Goto/Apply Next Edit Suggestion',
      },
      {
        '<c-.>',
        function() require('sidekick.cli').toggle() end,
        desc = 'Sidekick Toggle',
        mode = { 'n', 't', 'i', 'x' },
      },
      {
        '<leader>aa',
        function() require('sidekick.cli').toggle() end,
        desc = 'Sidekick Toggle CLI',
      },
      {
        '<leader>as',
        function() require('sidekick.cli').select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = 'Select CLI',
      },
      {
        '<leader>ad',
        function() require('sidekick.cli').close() end,
        desc = 'Detach a CLI Session',
      },
      {
        '<leader>at',
        function() require('sidekick.cli').send { msg = '{this}' } end,
        mode = { 'x', 'n' },
        desc = 'Send This',
      },
      {
        '<leader>af',
        function() require('sidekick.cli').send { msg = '{file}' } end,
        desc = 'Send File',
      },
      {
        '<leader>av',
        function() require('sidekick.cli').send { msg = '{selection}' } end,
        mode = { 'x' },
        desc = 'Send Visual Selection',
      },
      {
        '<leader>ap',
        function() require('sidekick.cli').prompt() end,
        mode = { 'n', 'x' },
        desc = 'Sidekick Select Prompt',
      },
      -- Example of a keybinding to open Claude directly
      {
        '<leader>ac',
        function() require('sidekick.cli').toggle { name = 'claude', focus = true } end,
        desc = 'Sidekick Toggle Claude',
      },
    },
  },

  { -- statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        globalstatus = true,
        disabled_filetypes = {
          statusline = { 'AgenticChat', 'AgenticInput', 'AgenticCode', 'AgenticFiles' },
          winbar = { 'AgenticChat', 'AgenticInput', 'AgenticCode', 'AgenticFiles' },
        },
      },
    },
  },

  { -- create sessions automatically
    'rmagatti/auto-session',
    opts = {
      pre_save_cmds = {
        'tabdo Trouble close',
      },
    },
    config = function(_, opts) require('auto-session').setup(opts) end,
  },

  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
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
  },

  {
    'lewis6991/hover.nvim',
    config = function()
      require('hover').config {
        providers = {
          'hover.providers.diagnostic',
          'hover.providers.lsp',
          'hover.providers.dap',
          'hover.providers.man',
          'hover.providers.gh',
        },
        preview_opts = {
          border = 'single',
        },
        preview_window = false,
        title = true,
        mouse_providers = {},
      }

      -- Setup keymaps
      vim.keymap.set('n', 'K', function() require('hover').open() end, { desc = 'hover.nvim (open)' })

      vim.keymap.set('n', 'gK', function() require('hover').enter() end, { desc = 'hover.nvim (enter)' })

      vim.keymap.set('n', '<C-p>', function() require('hover').switch 'previous' end, { desc = 'hover.nvim (previous source)' })

      vim.keymap.set('n', '<C-n>', function() require('hover').switch 'next' end, { desc = 'hover.nvim (next source)' })
    end,
  },

  {
    'akinsho/bufferline.nvim',
    enabled = false,
    event = 'VeryLazy',
    dependencies = {
      'echasnovski/mini.nvim',
    },
    keys = {
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
      {
        '<leader>q',
        function() require('mini.bufremove').delete(0) end,
        desc = 'Toggle Pin',
      },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
      { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
    },
    opts = {
      options = {
        close_command = function(n) require('mini.bufremove').delete(n) end,
        right_mouse_command = function(n) require('mini.bufremove').delete(n) end,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        offsets = {
          {
            filetype = 'snacks_picker_list',
            text = 'Explorer',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
        callback = function()
          vim.schedule(function() pcall(nvim_bufferline) end)
        end,
      })
    end,
  },

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        '<leader>sh',
        function() Snacks.picker.help() end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        function() Snacks.picker.keymaps() end,
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>sf',
        function() Snacks.picker.files() end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>ss',
        function() Snacks.picker.pickers() end,
        desc = '[S]earch [S]elect Picker',
      },
      {
        '<leader>sw',
        function() Snacks.picker.grep_word() end,
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sg',
        function() Snacks.picker.grep() end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sd',
        function() Snacks.picker.diagnostics() end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sr',
        function() Snacks.picker.resume() end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>s.',
        function() Snacks.picker.recent() end,
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      {
        '<leader><leader>',
        function() Snacks.picker.buffers() end,
        desc = '[ ] Find existing buffers',
      },
      {
        '<leader>/',
        function() Snacks.picker.lines() end,
        desc = '[/] Fuzzily search in current buffer',
      },
      {
        '<leader>s/',
        function() Snacks.picker.grep_buffers() end,
        desc = '[S]earch [/] in Open Files',
      },
      {
        '<leader>sn',
        function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end,
        desc = '[S]earch [N]eovim files',
      },
    },
  },

  {
    'Bekaboo/dropbar.nvim',
    config = function()
      local dropbar_api = require 'dropbar.api'
      vim.keymap.set('n', '<leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end,
  },

  {
    'stevearc/aerial.nvim',
    opts = {
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    },
    keys = {
      { '<leader>o', '<cmd>AerialToggle!<cr>', desc = 'Show [o]utline' },
    },
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    opts = {
      at_edge = 'stop',
    },
    keys = {
      {
        '<c-h>',
        function() require('smart-splits').move_cursor_left() end,
        mode = { 'n', 't' },
        desc = 'Navigate left',
      },
      {
        '<c-j>',
        function() require('smart-splits').move_cursor_down() end,
        mode = { 'n', 't' },
        desc = 'Navigate down',
      },
      {
        '<c-k>',
        function() require('smart-splits').move_cursor_up() end,
        mode = { 'n', 't' },
        desc = 'Navigate up',
      },
      {
        '<c-l>',
        function() require('smart-splits').move_cursor_right() end,
        mode = { 'n', 't' },
        desc = 'Navigate right',
      },
      {
        '<c-\\>',
        function() require('smart-splits').move_cursor_previous() end,
        mode = { 'n', 't' },
        desc = 'Navigate to previous',
      },
    },
  },

  {
    'petertriho/nvim-scrollbar',
    dependencies = {
      'lewis6991/gitsigns.nvim',
    },
    opts = {
      excluded_filetypes = {
        'blink-cmp-menu',
        'dropbar_menu',
        'dropbar_menu_fzf',
        'DressingInput',
        'cmp_docs',
        'cmp_menu',
        'noice',
        'prompt',
        'TelescopePrompt',
        'snacks_picker_list',
        'aerial',
      },
    },
    config = function(_, opts)
      require('scrollbar').setup(opts)
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },

  {
    'qvalentin/helm-ls.nvim',
    ft = 'helm',
    opts = {
      -- leave empty or see below
    },
  },
}
