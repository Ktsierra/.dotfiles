local M = {}

function M.update_harpoon_keymaps()
  local harpoon = require 'harpoon'
  for _, idx in ipairs { 1, 2, 3, 4, 5 } do
    local desc
    local item = harpoon:list():get(idx)
    if item and item.value then
      desc = '[H]arpoon: [' .. idx .. '] ' .. vim.fn.fnamemodify(item.value, ':t')
    else
      desc = '[H]arpoon: [' .. idx .. '] empty slot'
    end
    vim.keymap.set('n', string.format('<leader>%d', idx), function()
      harpoon:list():select(idx)
    end, { desc = desc })
  end
end

return M