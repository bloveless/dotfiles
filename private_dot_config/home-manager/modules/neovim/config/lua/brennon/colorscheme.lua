require("catppuccin").setup({
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        alpha = true,
        illuminate = true,
    }
})

vim.cmd.colorscheme [[catppuccin-macchiato]]
