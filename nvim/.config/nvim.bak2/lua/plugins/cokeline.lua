return {
	{
		"willothy/nvim-cokeline",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for v0.4.0+
			"nvim-tree/nvim-web-devicons", -- If you want devicons
			"stevearc/resession.nvim", -- Optional, for persistent history
			"cbochs/grapple.nvim",
		},
		config = function()
			local get_hex = require("cokeline.hlgroups").get_hl_attr

			require("cokeline").setup({
				default_hl = {
					fg = function(buffer)
						return buffer.is_focused and get_hex("ColorColumn", "bg") or get_hex("Normal", "fg")
					end,
					bg = function(buffer)
						return buffer.is_focused and get_hex("Normal", "fg") or get_hex("ColorColumn", "bg")
					end,
				},

				buffers = {
					filter_valid = function(buffer)
						return require("grapple").exists({
							buffer = buffer.number,
						})
					end,
				},

				components = {
					{
						text = function(buffer)
							return " " .. buffer.devicon.icon
						end,
						fg = function(buffer)
							return buffer.devicon.color
						end,
					},
					{
						text = function(buffer)
							return buffer.unique_prefix
						end,
						fg = get_hex("Comment", "fg"),
						italic = true,
					},
					{
						text = function(buffer)
							return buffer.filename .. " "
						end,
						underline = function(buffer)
							return buffer.is_hovered and not buffer.is_focused
						end,
					},
					{
						text = "x",
						on_click = function(_, _, _, _, buffer)
							buffer:delete()
						end,
					},
					{
						text = " ",
					},
				},
			})
		end,
	},
}
