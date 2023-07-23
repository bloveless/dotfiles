local map = vim.keymap.set

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- LazyGit
map("n", "<leader>gg", ":LazyGit<cr>", { desc = "Open lazygit" })
map("n", "<leader>gG", ":LazyGitCurrentFile<cr>", { desc = "Open lazygit" })

-- Neotree
map("n", "<leader>e", ":Neotree source=filesystem position=float toggle=true reveal_file=%:p<cr>",
  { desc = "Open file tree" })

-- Persistence
map("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]],
  { desc = "Restore the session for the current directory" })
map("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]],
  { desc = "Restore the last session" })
map("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]],
  { desc = "Stop persistence => session won't be saved on exit" })

-- Trouble
map("n", "<leader>xx", function() require("trouble").toggle() end, { desc = "Trouble open" })
map("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, { desc = "Trouble workspace" })
map("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end, { desc = "Trouble document" })
map("n", "<leader>xl", function() require("trouble").toggle("quickfix") end, { desc = "Trouble in a quickfix" })
map("n", "<leader>xq", function() require("trouble").toggle("loclist") end, { desc = "Trouble in a location list" })
map("n", "gR", function() require("trouble").toggle("lsp_references") end, { desc = "Trouble lsp references" })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- set the scrolloff to leave a 10 line window in the middle of the screen where scrolling doesn't happen
vim.api.nvim_create_augroup("SetScrolloff", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "WinNew", "VimResized" }, {
  group = "SetScrolloff",
  callback = function()
    local newscrolloff = math.ceil((vim.api.nvim_win_get_height(0) / 2) - 5)
    if newscrolloff < 0 then
      newscrolloff = 0
    end

    vim.opt.scrolloff = newscrolloff
  end
})
