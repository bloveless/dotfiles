require("trouble").setup({})

local keyops = { silent = true, noremap = true }

-- Lua
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", keyops)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", keyops)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", keyops)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", keyops)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", keyops)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", keyops)
