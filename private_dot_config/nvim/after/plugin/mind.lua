require("mind").setup({
  ui = {
    width = 50,
  },
  tree = {
    automatic_data_creation = false,
  },
  keymaps = {
    normal = {
      ["<cr>"] = function(args)
        require("mind.ui").with_confirmation("Are you sure you'd like to create a new data node?", function()
          require("mind.commands").commands.open_data(args)
        end)
      end,
    },
    selection = {
      ["<cr>"] = function(args)
        require("mind.ui").with_confirmation("Are you sure you'd like to create a new data node?", function()
          require("mind.commands").commands.open_data(args)
        end)
      end,
    },
  },
})

vim.keymap.set("n", "<leader>mp", require("mind").open_project)
vim.keymap.set("n", "<leader>mg", require("mind").open_main)
