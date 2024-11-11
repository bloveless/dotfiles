return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        goimports = {
          prepend_args = { "-local", "github.com/bayer-int" },
        },
      },
    },
  },
}
