require("catppuccin").setup({
    integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        treesitter = true,
        notify = true,
        alpha = true,
        illuminate = true,
        noice = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
        navic = {
            enabled = false,
            custom_bg = "NONE", -- "lualine" will set background to mantle
        },
    }
})

vim.cmd.colorscheme [[catppuccin-macchiato]]
