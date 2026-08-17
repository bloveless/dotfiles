-- IDE-like breadcrumbs in the winbar: file path + current symbol
-- (function/class/etc.), the way Zed and VS Code show it at the top.
-- https://github.com/Bekaboo/dropbar.nvim
--
-- Sources come from Neovim's builtin LSP and treesitter (both already
-- configured in init.lua), so no extra providers are needed. Catppuccin
-- colors are enabled via the `dropbar` integration in init.lua.

vim.pack.add { 'https://github.com/Bekaboo/dropbar.nvim' }

require('dropbar').setup {
  bar = {
    -- Per-buffer symbol trail: file path, then LSP symbols with a
    -- treesitter fallback when no language server is attached.
    sources = function(buf, _)
      local sources = require 'dropbar.sources'
      local utils = require 'dropbar.utils'
      if vim.bo[buf].ft == 'markdown' then return { sources.path, sources.markdown } end
      return {
        sources.path,
        utils.source.fallback { sources.lsp, sources.treesitter },
      }
    end,
  },
}

-- Jump into a breadcrumb segment (interactive dropdown menu), similar to
-- clicking a crumb in VS Code.
vim.keymap.set('n', '<leader>;', function() require('dropbar.api').pick() end, { desc = 'Dropbar: pick symbol' })
