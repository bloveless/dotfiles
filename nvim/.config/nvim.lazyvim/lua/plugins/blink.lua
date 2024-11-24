-- this file had to be renamed to .bak instead of setting enabled = false
-- enabled = false would disable it from the lazyextras and I couldn't uninstall it
return {
  {
    "saghen/blink.cmp",
    version = false,
    build = "cargo build --release",
    opts = {
      keymap = { preset = "default" },
      accept = { auto_brackets = { enabled = true } },
      trigger = { signature_help = { enabled = true } },
    },
  },
}
