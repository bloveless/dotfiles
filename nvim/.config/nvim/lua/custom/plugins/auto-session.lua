-- auto-session: automatically save/restore a session per directory
-- https://github.com/rmagatti/auto-session
--
-- Behavior:
--  - `nvim` and `nvim <dir>` restore the session for that directory
--    (args_allow_single_directory); a directory argument is cd'd into
--  - launching with file arguments (nvim main.go — and thus git $EDITOR
--    etc.) opts out of both restore and save (args_allow_files_auto_save)
--  - neo-tree is closed before saving (its buffers restore inert) and is
--    re-opened live after restore by the auto-open autocmd in
--    kickstart.plugins.neo-tree, which runs after this module's VimEnter
--    hook (load order in init.lua SECTION 10)

vim.pack.add { 'https://github.com/rmagatti/auto-session' }

-- What goes into a session: layout, windows, tab pages, folds, buffers
-- and the terminal — but NOT `options` (global settings must not leak
-- between projects) and not `args`.
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,terminal'

require('auto-session').setup {
  enabled = true, -- enables create/save/restore
  auto_restore = true,
  auto_create = true, -- create a session when none exists for the cwd

  -- `nvim <dir>` restores <dir>'s session; file arguments fully opt out
  args_allow_single_directory = true,
  args_allow_files_auto_save = false,

  -- Never touch sessions for the home directory or filesystem root
  suppressed_dirs = { '/', '~' },

  -- Keep sessions pure: tree buffers restore as inert windows, so close
  -- the tree before saving. It re-opens live after restore.
  pre_save_cmds = { 'Neotree close' },
}

-- Commands provided by auto-session (same muscle memory as before):
--   :SessionRestore :SessionDelete :SessionSave :SessionSearch :SessionPurge
