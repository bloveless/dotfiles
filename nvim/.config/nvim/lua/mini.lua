-- lots of things use this so just execute it immediately
local icons = require("mini.icons")
icons.setup()
icons.mock_nvim_web_devicons()

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
