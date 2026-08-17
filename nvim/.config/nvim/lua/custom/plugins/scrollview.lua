-- Decorated scrollbar: LSP diagnostics, git hunks, search, etc.
-- https://github.com/dstein64/nvim-scrollview
--
-- Toggle markers by commenting/uncommenting entries in `signs_on_startup`.
-- Runtime: `:ScrollViewToggle diagnostics` (or any group name).
-- Legend: `:ScrollViewLegend`

vim.pack.add { 'https://github.com/dstein64/nvim-scrollview' }

require('scrollview').setup {
  -- Comment out any entry below to hide that marker group.
  signs_on_startup = {
    'diagnostics', -- LSP / vim.diagnostic
    'search', -- / and ? matches
    'cursor', -- current line position on the bar
    'marks', -- a-z / A-Z marks
    'conflicts', -- merge conflict markers
    'keywords', -- TODO, FIXME, etc.
    'quickfix',
    'loclist',
    -- 'folds',
    -- 'changelist',
    -- 'indent',
    -- 'spell',
    -- 'textwidth',
    -- 'trail',
  },
  excluded_filetypes = {
    'neo-tree',
    'fugitive',
    'help',
    'qf',
    'terminal',
  },
  current_only = false,
  winblend = 50,
}

-- Git hunks on the scrollbar (needs gitsigns; already set up in init.lua).
-- Comment out this block to drop git markers without touching the list above.
require('scrollview.contrib.gitsigns').setup()
