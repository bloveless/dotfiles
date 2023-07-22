--################### START ALPHA ###################--

local dashboard = require("alpha.themes.dashboard")
local logo = [[

███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                  
]]

dashboard.section.header.val = vim.split(logo, "\n")
dashboard.section.buttons.val = {
    dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
    dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
    dashboard.button("q", " " .. " Quit", ":qa<CR>"),
}
for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = "AlphaButtons"
    button.opts.hl_shortcut = "AlphaShortcut"
end
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"
dashboard.opts.layout[1].val = 8

require("alpha").setup(dashboard.opts)

--################### END ALPHA ###################--


--################### START COMMENT ###################--

require('Comment').setup()

--################### END COMMENT ###################--


--################### START GITSIGNS ###################--

require('gitsigns').setup()

--################### END GITSIGNS ###################--


--################### START LUALINE ###################--

require('lualine').setup({
    options = {
        theme = "catppuccin"
    }
})

--################### END LUALINE ###################--


--################### START NOTIFY ###################--

local notify = require('notify')
notify.setup({
    top_down = false,
})

vim.notify = notify

--################### START NOTIFY ###################--


--################### START PERSISTENCE ###################--

require("persistence").setup()

--################### END PERSISTENCE ###################--


--################### START SURROUND ###################--

require("nvim-surround").setup()

--################### END SURROUND ###################--


--################### START TELESCOPE ###################--

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup({})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>sb', builtin.buffers, {})
vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})

--################### END TELESCOPE ###################--


--################### MINI INDENT SCOPE ###################--

require('mini.indentscope').setup({
    symbol = "│",
    options = {
        try_as_border = true
    },
})

--################### END MINI INDENT SCOPE ###################--

--################### START NOICE ###################--

require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
    },
})

--################### END NOICE ###################--
