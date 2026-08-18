-- Add indentation guides even on blank lines
-- Uses muted colors that complement rainbow delimiters

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help ibl`
vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
require('ibl').setup {
  indent = {
    highlight = _G.rainbow_indent_highlights or { 'Whitespace' },
  },
  scope = {
    enabled = true,
    highlight = _G.rainbow_scope_highlights or { 'Whitespace' },
    show_start = false,
  },
}
