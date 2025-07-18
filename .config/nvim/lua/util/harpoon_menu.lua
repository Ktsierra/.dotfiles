local M = {}

function M.delete_menu()
  local list = require('harpoon'):list()
  local list_len = list:length()

  if list_len == 0 then
    vim.notify('Harpoon list is empty.', vim.log.levels.WARN)
    return
  end

  local lines_to_display = { 'Select a file to remove (or q/Esc to close):', '' }

  -- Create a scratch buffer for the menu
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
  vim.api.nvim_set_option_value('modifiable', true, { buf = buf })

  local win
  local function close_win()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  for i = 1, list_len do
    local item = list:get(i)
    if item and item.value then
      local filename = vim.fn.fnamemodify(item.value, ':t')
      table.insert(lines_to_display, string.format('  %d: %s', i, filename))
      if i <= 9 then
        vim.keymap.set('n', tostring(i), function()
          list:remove_at(i)
          vim.notify(string.format('Removed "%s" from Harpoon list.', filename))
          close_win()
        end, { buffer = buf, nowait = true, silent = true })
      end
    else
      table.insert(lines_to_display, string.format('  %d: [empty]', i))
    end
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines_to_display)
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.60)
  local height = #lines_to_display + 2
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = 'Harpoon Delete',
    title_pos = 'left',
  })

  vim.keymap.set('n', 'q', close_win, { buffer = buf, nowait = true, silent = true })
  vim.keymap.set('n', '<Esc>', close_win, { buffer = buf, nowait = true, silent = true })
end

return M
