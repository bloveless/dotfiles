-- Persistent Floating Terminal State Tracker
local float_term_win = nil
local float_term_buf = nil

local function toggle_float_term()
  -- If the window exists and is valid, close/hide it
  if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
    vim.api.nvim_win_close(float_term_win, true)
    float_term_win = nil
    return
  end

  -- Get current screen dimensions using modern option value API
  local width = vim.api.nvim_get_option_value('columns', {})
  local height = vim.api.nvim_get_option_value('lines', {})

  -- Calculate size (80% of screen)
  local win_width = math.ceil(width * 0.8)
  local win_height = math.ceil(height * 0.8)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    style = 'minimal',
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = 'rounded',
  }

  -- Create or reuse buffer
  if not float_term_buf or not vim.api.nvim_buf_is_valid(float_term_buf) then
    float_term_buf = vim.api.nvim_create_buf(false, true)
    -- Open the window with the new buffer
    float_term_win = vim.api.nvim_open_win(float_term_buf, true, opts)

    -- Launch the interactive terminal shell
    vim.cmd 'terminal'

    -- Clean up everything automatically when the shell process exits
    local current_buf = float_term_buf
    vim.api.nvim_create_autocmd('TermClose', {
      buffer = current_buf,
      callback = function()
        -- Delete the terminal buffer (this also closes its active window)
        if vim.api.nvim_buf_is_valid(current_buf) then vim.api.nvim_buf_delete(current_buf, { force = true }) end
        -- Reset tracking variables so next toggle starts fresh
        float_term_win = nil
        float_term_buf = nil
      end,
    })
  else
    -- Reuse the existing background buffer in a new floating window
    float_term_win = vim.api.nvim_open_win(float_term_buf, true, opts)
  end

  -- Enter insert mode inside the terminal immediately
  vim.cmd 'startinsert'
end

vim.api.nvim_create_user_command('FloatTermToggle', toggle_float_term, {})

-- Keymap to trigger it with Ctrl + t
vim.keymap.set('n', '<C-t>', ':FloatTermToggle<CR>', { silent = true })
vim.keymap.set('t', '<C-t>', [[<C-\><C-n>:FloatTermToggle<CR>]], { silent = true })
