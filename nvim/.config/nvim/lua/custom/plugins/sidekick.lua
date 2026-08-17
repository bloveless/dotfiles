-- Sidekick: terminal for any AI CLI (pi, opencode, claude, codex, ...) + context sending
-- https://github.com/folke/sidekick.nvim
--
-- Only the CLI-terminal half is used here: the Copilot "Next Edit Suggestions"
-- half is disabled (no Copilot LSP in this config).
--
-- Inside a sidekick terminal window: q / <c-q> hide, <c-p> prompt library,
-- <c-b> / <c-f> buffer & file pickers (fzf-lua). <Esc><Esc> still exits
-- terminal mode (mapped in init.lua).
--
-- Sessions run inside zellij panes (cli.mux), so agent conversations
-- survive hiding the window and Neovim restarts / auto-session restores.
-- Run `:checkhealth sidekick` after changes. The "Copilot LSP" error there
-- is expected (NES is disabled); only the CLI-terminal half is used.

vim.pack.add { 'https://github.com/folke/sidekick.nvim' }

require('sidekick').setup {
  nes = {
    enabled = false, -- no Copilot LSP; CLI terminal only
  },
  cli = {
    picker = 'fzf-lua', -- matches the picker used everywhere else in this config
    mux = {
      enabled = true,
      backend = 'zellij', -- explicit: auto-detect prefers tmux unless nvim runs inside zellij
    },
    win = {
      layout = 'right',
      split = { width = 90 },
    },
  },
}

local cli = require 'sidekick.cli'

vim.keymap.set('n', '<leader>aa', function() cli.toggle() end, { desc = '[A]I toggle CLI terminal' })
vim.keymap.set('n', '<leader>as', function() cli.select { filter = { installed = true } } end, { desc = '[A]I [S]elect CLI tool' })
vim.keymap.set('n', '<leader>ai', function() cli.toggle { name = 'pi' } end, { desc = '[A]I toggle p[i] directly' })
vim.keymap.set('n', '<leader>ad', function() cli.close() end, { desc = '[A]I [D]etach CLI session' })

-- Send context to the active CLI: {file}, {selection}, {this} (textobject +
-- cursor position + diagnostics), and the prompt library
vim.keymap.set('n', '<leader>af', function() cli.send { msg = '{file}' } end, { desc = '[A]I send [F]ile' })
vim.keymap.set('x', '<leader>av', function() cli.send { msg = '{selection}' } end, { desc = '[A]I send [V]isual selection' })
vim.keymap.set({ 'n', 'x' }, '<leader>at', function() cli.send { msg = '{this}' } end, { desc = '[A]I send [T]his (context)' })
vim.keymap.set({ 'n', 'x' }, '<leader>ap', function() cli.prompt() end, { desc = '[A]I [P]rompt library' })

-- Register the group label with which-key (already set up by the time this loads)
require('which-key').add { { '<leader>a', group = '[A]I' } }
