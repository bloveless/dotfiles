-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Navigate quickfix list quicker
vim.keymap.set("n", "]q", "<cmd>cn<cr>", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", "<cmd>cp<cr>", { desc = "Previous quickfix item" })

-- Navigate buffer tabs
vim.keymap.set("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "H", "<cmd>bprev<cr>", { desc = "Next buffer" })

-- Shortcut to inspect diagnostics just in case they don't open for some reason
vim.keymap.set("n", "<leader>i", function()
	for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(winid).zindex then
			return
		end
	end
	vim.diagnostic.open_float({
		scope = "cursor",
		focusable = false,
		close_events = {
			"CursorMoved",
			"CursorMovedI",
			"BufHidden",
			"InsertCharPre",
			"WinLeave",
		},
	})
end, { desc = "Toggle Diagnostics" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Show diagnostics after jumping" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Show diagnostics after jumping" })
