local theme_specs = {}

local theme_dir = vim.fn.stdpath 'config' .. '/lua/theme'
local scan = vim.loop.fs_scandir(theme_dir)
if scan then
  while true do
    local name, typ = vim.loop.fs_scandir_next(scan)
    if not name then
      break
    end
    if typ == 'file' and name ~= 'init.lua' and name:match '%.lua$' then
      local spec = require('theme.' .. name:gsub('%.lua$', ''))
      table.insert(theme_specs, spec)
    end
  end
end

return theme_specs
