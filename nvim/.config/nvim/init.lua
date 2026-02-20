vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.tabstop = 4

vim.o.list = true
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 25
vim.o.confirm = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines
  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.filetype.add {
  extension = {
    ddl = 'sql',
  },
  pattern = {
    ['.*/templates/.*%.yaml'] = 'helm',
    ['.*/templates/.*%.yml'] = 'helm',
    ['.*/templates/.*%.tpl'] = 'helm',
    ['.*/helm/.*%.yaml'] = 'helm',
    ['.*/helm/.*%.yml'] = 'helm',
    ['.*/helm/.*%.tpl'] = 'helm',
  },
}

--[[ Your UUID function global and renamed for example --]]
local function generate_uuid() return string.lower(vim.trim(vim.system({ 'uuidgen' }, { text = true }):wait().stdout)) end

--[[ Generate a uuid and place it at current cursor position --]]
local insert_uuid = function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local uuid = generate_uuid()
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { uuid })
  vim.api.nvim_win_set_cursor(0, { row, col + string.len(uuid) })
end

vim.keymap.set('i', '<c-u>', insert_uuid, { noremap = true, silent = true })

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      integrations = {
        aerial = true,
        blink_cmp = {
          style = 'bordered',
        },
        dropbar = {
          enabled = true,
        },
        gitsigns = true,
        mini = {
          enabled = true,
        },
        lsp_trouble = true,
        snacks = {
          enabled = true,
        },
        which_key = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },

  { 'NMAC427/guess-indent.nvim', opts = {} },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },

  { -- experimental plugin that replaces some UI elements like cmdline, messages, and the popup menu
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      presets = {
        command_palette = true,
        long_message_to_split = true,
      },
      lsp = {
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {},
    ---@diagnostic enable: missing-fields
    event = 'VimEnter',
    config = function(_, opts)
      local fzf = require 'fzf-lua'
      fzf.setup(opts)
      fzf.register_ui_select()

      vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect FZF' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sc', fzf.commands, { desc = '[S]earch [C]ommands' })
      vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function() fzf.lgrep_curbuf { previewer = 'builtin' } end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set(
        'n',
        '<leader>s/',
        function() fzf.live_grep { rg_opts = '--type-list | grep -v ":" | tr "\\n" "," | sed "s/,$//" | xargs -I {} rg --type {} --multiline' } end,
        { desc = '[S]earch [/] in Open Files' }
      )

      vim.keymap.set('n', '<leader>sn', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('fzf-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          vim.keymap.set('n', 'grr', fzf.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
          vim.keymap.set('n', 'gri', fzf.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
          vim.keymap.set('n', 'grd', fzf.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
          vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
          vim.keymap.set('n', 'gW', fzf.lsp_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
          vim.keymap.set('n', 'grt', fzf.lsp_typedefs, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })
    end,
  },

  { -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('grd', vim.lsp.buf.definition, '[G]oto [D]efinition')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      vim.lsp.config('intelephense', {
        init_options = {
          licenceKey = '~/.config/intelephense/license.txt',
        },
        settings = {
          intelephense = {
            files = {
              maxSize = 10000000,
            },
          },
        },
      })

      vim.lsp.config('gopls', {
        settings = {
          gopls = {
            gofumpt = true,
            ['local'] = 'github.com/bayer-int,bayer.buf.dev,github.com/shadowglass-xyz,github.com/bloveless',
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              nilness = true,
              unusedfunc = true,
              unusedparams = true,
              unusedresult = true,
              unusedvariable = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
            semanticTokens = true,
          },
        },
      })

      -- Special Lua Config, as recommended by neovim help docs
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
              --  See https://github.com/neovim/nvim-lspconfig/issues/3189
              library = vim.api.nvim_get_runtime_file('', true),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      vim.lsp.enable 'expert'
      vim.lsp.enable 'ty'
      vim.lsp.enable 'gopls'
      vim.lsp.enable 'harper_ls'
      vim.lsp.enable 'terraformls'
      vim.lsp.enable 'intelephense'
      vim.lsp.enable 'buf_ls'
      vim.lsp.enable 'ruff'
      vim.lsp.enable 'lua_ls'
      vim.lsp.enable 'zls'
    end,
  },

  {
    'fnune/codeactions-on-save.nvim',
    config = function()
      local cos = require 'codeactions-on-save'
      cos.register({ '*.go' }, { 'source.organizeImports' })
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        go = { 'gofumpt' },
        elixir = { 'mix' },
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
          },
        },
        opts = {},
      },
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<Tab>'] = {
          'snippet_forward',
          function() -- sidekick next edit suggestion
            return require('sidekick').nes_jump_or_apply()
          end,
          'fallback',
        },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    keys = {
      {
        '<leader>bd',
        function() require('mini.bufremove').delete(0, false) end,
        desc = 'Delete Buffer',
      },
      {
        '\\',
        function()
          local MiniFiles = require 'mini.files'
          local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
          MiniFiles.reveal_cwd()
        end,
        desc = 'Open mini.files (Directory of Current File)',
      },
      {
        '<leader>fM',
        function() require('mini.files').open(vim.uv.cwd(), true) end,
        desc = 'Open mini.files (cwd)',
      },
    },
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.bufremove').setup()
      require('mini.surround').setup()
      require('mini.files').setup {
        windows = {
          preview = true,
          width_focus = 30,
          width_preview = 100,
        },
      }
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    config = function()
      local filetypes = {
        'bash',
        'blade',
        'c',
        'diff',
        'elixir',
        'go',
        'gomod',
        'gowork',
        'heex',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      }
      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },

  {
    'zbirenbaum/copilot.lua',
    enabled = string.find(os.getenv 'HOME' or '', 'ejvzx', 1, true) ~= nil,
    dependencies = {
      'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
    },
    opts = {},
  },

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
        '<c-a>',
        function() require('sidekick').nes_jump_or_apply() end,
        desc = 'Goto/Apply Next Edit Suggestion',
        mode = { 'n', 'i' },
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
      options = { globalstatus = true },
      disabled_filetypes = {
        statusline = { 'AgenticChat', 'AgenticInput', 'AgenticCode', 'AgenticFiles' },
        winbar = { 'AgenticChat', 'AgenticInput', 'AgenticCode', 'AgenticFiles' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          'filename',
          {
            function() return ' ' end,
            color = function()
              local status = require('sidekick.status').get()
              if status then return status.kind == 'Error' and 'DiagnosticError' or status.busy and 'DiagnosticWarn' or 'Special' end
            end,
            cond = function()
              local status = require 'sidekick.status'
              return status.get() ~= nil
            end,
          },
        },
        lualine_x = {
          {
            function()
              local status = require('sidekick.status').cli()
              return ' ' .. (#status > 1 and #status or '')
            end,
            cond = function() return #require('sidekick.status').cli() > 0 end,
            color = function() return 'Special' end,
          },
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
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
    'qvalentin/helm-ls.nvim',
    ft = 'helm',
    opts = {},
  },

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        go = { 'golangcilint' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then lint.try_lint() end
        end,
      })
    end,
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function(_, opts) require('rainbow-delimiters.setup').setup(opts) end,
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    config = function(_, opts)
      require('ibl').setup(opts)
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }
      local highlight_dim = {
        'RainbowRedDim',
        'RainbowYellowDim',
        'RainbowBlueDim',
        'RainbowOrangeDim',
        'RainbowGreenDim',
        'RainbowVioletDim',
        'RainbowCyanDim',
      }
      local hooks = require 'ibl.hooks'
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
        vim.api.nvim_set_hl(0, 'RainbowRedDim', { fg = '#72373b' })
        vim.api.nvim_set_hl(0, 'RainbowYellowDim', { fg = '#776440' })
        vim.api.nvim_set_hl(0, 'RainbowBlueDim', { fg = '#3d6c93' })
        vim.api.nvim_set_hl(0, 'RainbowOrangeDim', { fg = '#543e2a' })
        vim.api.nvim_set_hl(0, 'RainbowGreenDim', { fg = '#38472d' })
        vim.api.nvim_set_hl(0, 'RainbowVioletDim', { fg = '#472c50' })
        vim.api.nvim_set_hl(0, 'RainbowCyanDim', { fg = '#265055' })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require('ibl').setup { scope = { show_start = false, highlight = highlight_dim } }

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function() vim.g.mkdp_filetypes = { 'markdown' } end,
    ft = { 'markdown' },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
