local ok, plenary_reload = pcall(require, "plenary.reload")
if not ok then
  Reloader = require
else
  Reloader = plenary_reload.reload_module
end

P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return Reloader(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

SaveAndExec = function ()
    local file = vim.api.nvim_buf_get_name(0);
    vim.cmd('silent! write')

    if vim.bo.filetype == 'vim' then
        vim.cmd('source ' .. file)
    else
        vim.cmd('luafile ' .. file)
    end
end

