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
    background_colour = "#000000",
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

-- You don't need to set any of these options. These are the default ones. Only
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


--################### START FIDGET ###################--

require("fidget").setup({})

--################### END FIDGET ###################--


--################### START TERRAFORM ###################--

-- setup terraform file types
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

-- terraform format and align on save
vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])

--################### END TERRAFORM ###################--


--################### START NEO-TREE ###################--

require("neo-tree").setup({
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
    filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
    },
    buffers = {
        follow_current_file = { enabled = true },
    },
    window = {
        mappings = {
            ["<space>"] = "none",
        },
    },
    default_component_configs = {
        indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
        },
    },
})

--################### END NEO-TREE ###################--
--################### START TREESITTER ###################--

require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },
})

--################### END TREESITTER ###################--
