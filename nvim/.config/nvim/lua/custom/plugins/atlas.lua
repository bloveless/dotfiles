-- PR review + issues for GitHub/GitLab/Bitbucket/Jira.
-- https://github.com/emrearmagan/atlas.nvim
-- Needs `git`, `curl`, `gh` (auth'd). Run `:checkhealth atlas`.

vim.pack.add { 'https://github.com/emrearmagan/atlas.nvim' }

-- Providers are opt-in: one must be listed or "No supported Git repository found".
require('atlas').setup {
  pulls = {
    diff = { lsp = { enabled = true } }, -- temp worktree at PR head so LSPs attach
  },
  providers = {
    github = { cache_ttl = 300 }, -- auth via `gh`
  },
}
