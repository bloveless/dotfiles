return {
	{
		"freddiehaddad/feline.nvim",
		enabled = false,
		opts = {},
		config = function(_, opts)
			local clrs = require("catppuccin.palettes").get_palette()
			local latte = require("catppuccin.palettes.latte")
			local ctp_feline = require("catppuccin.groups.integrations.feline")
			local U = require("catppuccin.utils.colors")

			ctp_feline.setup({
				assets = {
					left_separator = "",
					right_separator = "",
					mode_icon = "",
					dir = "󰉖",
					file = "󰈙",
					lsp = {
						server = "󰅡",
						error = "",
						warning = "",
						info = "",
						hint = "",
					},
					git = {
						branch = "",
						added = "",
						changed = "",
						removed = "",
					},
				},
				sett = {
					text = U.vary_color({ latte = latte.base }, clrs.surface0),
					bkg = U.vary_color({ latte = latte.crust }, clrs.surface0),
					diffs = clrs.mauve,
					extras = clrs.overlay1,
					curr_file = clrs.maroon,
					curr_dir = clrs.flamingo,
					show_modified = false, -- show if the file has been modified
					show_lazy_updates = false, -- show the count of updatable plugins from lazy.nvim
					-- need to set checker.enabled = true in lazy.nvim first
					-- the icon is set in ui.icons.plugin in lazy.nvim
				},
				mode_colors = {
					["n"] = { "NORMAL", clrs.lavender },
					["no"] = { "N-PENDING", clrs.lavender },
					["i"] = { "INSERT", clrs.green },
					["ic"] = { "INSERT", clrs.green },
					["t"] = { "TERMINAL", clrs.green },
					["v"] = { "VISUAL", clrs.flamingo },
					["V"] = { "V-LINE", clrs.flamingo },
					["�"] = { "V-BLOCK", clrs.flamingo },
					["R"] = { "REPLACE", clrs.maroon },
					["Rv"] = { "V-REPLACE", clrs.maroon },
					["s"] = { "SELECT", clrs.maroon },
					["S"] = { "S-LINE", clrs.maroon },
					["�"] = { "S-BLOCK", clrs.maroon },
					["c"] = { "COMMAND", clrs.peach },
					["cv"] = { "COMMAND", clrs.peach },
					["ce"] = { "COMMAND", clrs.peach },
					["r"] = { "PROMPT", clrs.teal },
					["rm"] = { "MORE", clrs.teal },
					["r?"] = { "CONFIRM", clrs.mauve },
					["!"] = { "SHELL", clrs.green },
				},
				view = {
					lsp = {
						progress = true, -- if true the status bar will display an lsp progress indicator
						name = false, -- if true the status bar will display the lsp servers name, otherwise it will display the text "Lsp"
						exclude_lsp_names = {}, -- lsp server names that should not be displayed when name is set to true
						separator = "|", -- the separator used when there are multiple lsp servers
					},
				},
			})

			require("feline").setup({
				components = ctp_feline.get(),
			})
		end,
	},
}
