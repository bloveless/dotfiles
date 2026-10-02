-- persistence.nvim: automatically save/restore a session per directory
-- https://github.com/folke/persistence.nvim
--
-- Behavior:
--  - `nvim` and `nvim <dir>` restore the session for that directory
--    (a directory argument is cd'd into)
--  - launching with file arguments (nvim main.go — and thus git $EDITOR
--    etc.) opts out of both restore and save
--  - neo-tree is closed before saving (its buffers restore inert) and is
--    re-opened live after restore by the auto-open autocmd in
--    kickstart.plugins.neo-tree, which runs after this module's VimEnter
--    hook (load order in init.lua SECTION 10)

vim.pack.add { 'https://github.com/folke/persistence.nvim' }

-- What goes into a session: layout, windows, tab pages, folds, buffers
-- and the terminal — but NOT `options` (global settings must not leak
-- between projects) and not `args`. `localoptions` keeps filetype /
-- highlighting correct after restore.
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

local persistence = require 'persistence'
persistence.setup {
  need = 0,
  branch = false,
}

local argc = vim.fn.argc()
local argv0 = vim.fn.argv(0) --[[@as string]]
local directory_start = argc == 0 or (argc == 1 and vim.fn.isdirectory(argv0) == 1)
local session_dir = vim.fs.normalize(argc == 0 and vim.fn.getcwd() or vim.fn.fnamemodify(argv0, ':p'))

if not directory_start or session_dir == '/' or session_dir == vim.uv.os_homedir() then
  persistence.stop()
else
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
      vim.cmd.cd(vim.fn.fnameescape(session_dir))
      persistence.load()
    end,
  })

  -- Keep sessions pure: tree, outline, and trouble buffers restore as inert
  -- windows, so close them before saving. Neo-tree re-opens live after restore.
  vim.api.nvim_create_autocmd('User', {
    pattern = 'PersistenceSavePre',
    callback = function()
      vim.cmd 'silent! Neotree close'
      if package.loaded.trouble then require('trouble').close() end
    end,
  })
end
