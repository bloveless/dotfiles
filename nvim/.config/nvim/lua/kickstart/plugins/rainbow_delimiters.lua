-- Rainbow delimiters for matching brackets/parens
-- Uses tree-sitter for language-aware delimiter highlighting

vim.pack.add { 'https://github.com/HiPhish/rainbow-delimiters.nvim' }

-- Rainbow highlight groups for DELIMITERS (full color)
local delimiter_colors = {
  'RainbowDelimiterRed',
  'RainbowDelimiterYellow',
  'RainbowDelimiterBlue',
  'RainbowDelimiterOrange',
  'RainbowDelimiterGreen',
  'RainbowDelimiterViolet',
  'RainbowDelimiterCyan',
}

local rainbow_fg = { '#e06c75', '#e5c07b', '#61afef', '#d19a66', '#98c379', '#c678dd', '#56b6c2' }

for i, name in ipairs(delimiter_colors) do
  vim.api.nvim_set_hl(0, name, { fg = rainbow_fg[i] })
end

-- Dimmed rainbow colors for indent guides (same hue, lower saturation)
local indent_colors = {
  'IblIndentRed',
  'IblIndentYellow',
  'IblIndentBlue',
  'IblIndentOrange',
  'IblIndentGreen',
  'IblIndentViolet',
  'IblIndentCyan',
}

local dimmed_rainbow = { '#5c3a3d', '#5c543b', '#3d5c7a', '#5c4d3d', '#3d5c44', '#5c3d6e', '#3d5c63' }

for i, name in ipairs(indent_colors) do
  vim.api.nvim_set_hl(0, name, { fg = dimmed_rainbow[i] })
end

-- Scope highlight colors (between dimmed and full brightness)
local scope_colors = {
  'IblScopeRed',
  'IblScopeYellow',
  'IblScopeBlue',
  'IblScopeOrange',
  'IblScopeGreen',
  'IblScopeViolet',
  'IblScopeCyan',
}

local scope_rainbow = { '#7a4a4f', '#7a6d4d', '#4d7a98', '#7a634d', '#4d7a56', '#7a4d8c', '#4d7a7c' }

for i, name in ipairs(scope_colors) do
  vim.api.nvim_set_hl(0, name, { fg = scope_rainbow[i] })
end

-- Store highlight groups for indent-blankline integration
_G.rainbow_delimiter_highlights = delimiter_colors
_G.rainbow_indent_highlights = indent_colors
_G.rainbow_scope_highlights = scope_colors

local rainbow_delimiters = require 'rainbow-delimiters'

vim.g.rainbow_delimiters = {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
  },
  query = {
    [''] = 'rainbow-delimiters',
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
}
