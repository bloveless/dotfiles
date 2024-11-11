return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>sf",
        require("telescope.builtin").find_files,
        desc = "[S]earch [F]iles",
      },
      {
        "<leader><space>",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      {
        "<leader>,",
        false,
      },
    },
  },
}
