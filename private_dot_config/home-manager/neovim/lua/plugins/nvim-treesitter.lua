return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      -- For some reason specifying gcc specifically instead of clang (even though they seem to be the same thing) works for compiling terraform and hcl on Apple M1
      require("nvim-treesitter.install").compilers = { "gcc" }
    end,
  },
}
