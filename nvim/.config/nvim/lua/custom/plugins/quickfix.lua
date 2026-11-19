-- Native quickfix/location lists, rendered by quicker.nvim (aligned columns, diagnostic icons,
-- editable entries, expandable context). The windows are plain qf windows, so :cclose works.
-- https://github.com/stevearc/quicker.nvim
--
-- <leader>xx workspace diagnostics (current file first, live-updating while open)
-- <leader>xX buffer diagnostics (location list)
-- <leader>xq / <leader>xl toggle the quickfix / location list window
-- Git changes: <leader>hQ / <leader>hq (gitsigns.setqflist, see kickstart.plugins.gitsigns)
-- ]q / [q and ]l / [l are Neovim's built-in :cnext / :cprev / :lnext / :lprev.
-- In the list: > / < expand / collapse surrounding context, q closes.

vim.pack.add { 'https://github.com/stevearc/quicker.nvim' }

local quicker = require 'quicker'
quicker.setup {
  -- Scroll the open list to the item closest to the cursor
  follow = { enabled = true },
  keys = {
    { '>', function() quicker.expand { before = 2, after = 2, add_to_existing = true } end, desc = 'Expand quickfix context' },
    { '<', function() quicker.collapse() end, desc = 'Collapse quickfix context' },
    { 'q', '<cmd>close<CR>', desc = 'Close list' },
  },
}

local open_opts = { open_cmd_mods = { split = 'botright' } }

-- Workspace diagnostics ------------------------------------------------------

local TITLE = 'Workspace diagnostics'

---@return integer? id, integer? nr
local function find_diag_list()
  for nr = 1, vim.fn.getqflist({ nr = '$' }).nr do
    local list = vim.fn.getqflist { nr = nr, id = 0, title = 0 }
    if list.title == TITLE then return list.id, nr end
  end
end

local function is_current_list(id) return id ~= nil and vim.fn.getqflist({ id = 0 }).id == id end

-- All diagnostics, with `anchor`'s entries first, then the rest grouped by file name.
local function diag_items(anchor)
  local items = vim.diagnostic.toqflist(vim.diagnostic.get())
  local names = {}
  local function name(bufnr)
    names[bufnr] = names[bufnr] or vim.api.nvim_buf_get_name(bufnr)
    return names[bufnr]
  end
  table.sort(items, function(a, b)
    local a_anchor, b_anchor = a.bufnr == anchor, b.bufnr == anchor
    if a_anchor ~= b_anchor then return a_anchor end
    if a.bufnr ~= b.bufnr then return name(a.bufnr) < name(b.bufnr) end
    if a.lnum ~= b.lnum then return a.lnum < b.lnum end
    return a.col < b.col
  end)
  return items
end

-- Index of the anchor-file item at (or just above) the cursor, so ]q continues from there.
local function nearest_idx(items, anchor, lnum)
  local idx
  for i, item in ipairs(items) do
    if item.bufnr ~= anchor then break end
    if item.lnum > lnum and idx then break end
    idx = i
  end
  return idx or 1
end

local function toggle_workspace_diagnostics()
  local id = find_diag_list()
  if quicker.is_open() and is_current_list(id) then return quicker.close() end

  local anchor = vim.api.nvim_get_current_buf()
  local items = diag_items(anchor)
  local what = {
    title = TITLE,
    items = items,
    idx = nearest_idx(items, anchor, vim.api.nvim_win_get_cursor(0)[1]),
    context = { anchor = anchor },
  }
  if id then
    what.id = id
    vim.fn.setqflist({}, 'r', what)
    local _, nr = find_diag_list()
    vim.cmd(('silent %dchistory'):format(nr))
  else
    vim.fn.setqflist({}, ' ', what)
  end
  quicker.open(open_opts)
end

-- Trouble-style live updates: while the diagnostics list is the one on screen, rebuild it
-- (keeping the original anchor file first) when diagnostics change. Debounced, since
-- DiagnosticChanged fires per buffer per LSP publish.
local refresh_timer = assert(vim.uv.new_timer())
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = vim.api.nvim_create_augroup('custom-qf-diagnostics', { clear = true }),
  callback = function()
    refresh_timer:stop()
    refresh_timer:start(
      150,
      0,
      vim.schedule_wrap(function()
        local id = find_diag_list()
        if not (quicker.is_open() and is_current_list(id)) then return end
        local ctx = vim.fn.getqflist({ id = id, context = 0 }).context
        local anchor = type(ctx) == 'table' and ctx.anchor or -1
        -- 'u' keeps the selected entry where possible
        vim.fn.setqflist({}, 'u', { id = id, items = diag_items(anchor) })
      end)
    )
  end,
})

-- Keymaps ---------------------------------------------------------------------

vim.keymap.set('n', '<leader>xx', toggle_workspace_diagnostics, { desc = 'Workspace diagnostics (quickfix)' })
vim.keymap.set('n', '<leader>xX', function()
  if quicker.is_open(0) then return quicker.close { loclist = true } end
  vim.diagnostic.setloclist { open = false, title = 'Buffer diagnostics' }
  quicker.open(vim.tbl_extend('force', open_opts, { loclist = true }))
end, { desc = 'Buffer diagnostics (loclist)' })
vim.keymap.set('n', '<leader>xq', function() quicker.toggle(open_opts) end, { desc = 'Toggle quickfix' })
vim.keymap.set('n', '<leader>xl', function() quicker.toggle(vim.tbl_extend('force', open_opts, { loclist = true })) end, { desc = 'Toggle loclist' })

-- LSP lists formerly shown in Trouble, now via fzf-lua (ctrl-q sends results to quickfix)
vim.keymap.set('n', '<leader>cs', function() require('fzf-lua').lsp_document_symbols() end, { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>cl', function() require('fzf-lua').lsp_finder() end, { desc = 'LSP definitions / references / ...' })

require('which-key').add {
  { '<leader>x', group = 'Quickfi[x] / diagnostics' },
  { '<leader>c', group = '[C]ode' },
}
