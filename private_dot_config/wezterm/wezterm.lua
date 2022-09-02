local wezterm = require 'wezterm'

local mykeys = {
  { key = '{', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative(-1) },
  { key = '}', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative(1) },
}

for i = 1, 8 do
  -- CTRL+ALT + number to move to that position
  table.insert(mykeys, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = wezterm.action.MoveTab(i - 1),
  })
end

return {
  color_scheme = "Gruvbox dark, medium (base16)",
  font_size = 13,
  initial_cols = 140,
  initial_rows = 40,
  scrollback_lines = 4000,
  keys = mykeys,
}
