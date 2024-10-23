-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Decrease update time until swap file is written to disk
vim.opt.updatetime = 250

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- display tabs as 4 characters
vim.opt.tabstop = 4

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })

-- lots of things use this so just execute it immediately
require("mini.icons").setup()

-- setup basic editor settings. Do this first so that plugins that are loaded after it will use these settings (specifically leader keys)
require("mini.basics").setup({
	options = {
		-- Extra UI features ('winblend', 'cmdheight=0', ...)
		extra_ui = true,
	},
	mappings = {
		-- Window navigation with <C-hjkl>, resize with <C-arrow>
		windows = true,
	},
	autocommands = {
		-- Set 'relativenumber' only in linewise and blockwise Visual mode
		relnum_in_visual_mode = true,
	},
})

require("autocommands")
require("keymaps")
require("filetypes")
require("ui")
require("lsp")
require("coding")
require("testing")
require("utilities")
