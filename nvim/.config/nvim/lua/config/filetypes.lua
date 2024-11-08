-- Additional file types
vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
    [".go.tmpl"] = "gotmpl",
    ddl = "sql",
    [".*%.blade%.php"] = "blade",
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
    ["docker-compose.ya?ml"] = "yaml.docker-compose",
  },
})
