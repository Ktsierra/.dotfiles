-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  desc = 'Diagnostics description on hover',
  group = vim.api.nvim_create_augroup('diagnostic-hover', { clear = true }),
  callback = function()
    vim.diagnostic.open_float()
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'InsertLeave' }, {
  desc = 'Auto-save when leaving a modified buffer',
  group = vim.api.nvim_create_augroup('buffer_leave_events', { clear = true }),
  pattern = '*',
  callback = function()
    if vim.bo.modified and vim.bo.buftype == '' then
      vim.lsp.buf.format { async = true }
      vim.cmd.write()
    end
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  desc = 'Add trailing comma for JS/TS object properties (small, treesitter-based)',
  group = vim.api.nvim_create_augroup('comma_after_prop_minimal', { clear = true }),
  pattern = '*',
  callback = function()
    local ft = vim.bo.filetype
    local allowed = { js = true, javascript = true, ts = true, typescript = true, tsx = true, jsx = true, javascriptreact = true, typescriptreact = true }
    if not allowed[ft] then
      return
    end

    local ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
    if not ok or not ts_utils.get_node_at_cursor then
      return
    end

    local node = ts_utils.get_node_at_cursor()
    local inside_prop, inside_obj = false, false
    while node do
      local t = node:type()
      if t:match 'object' then
        inside_obj = true
      end
      if t:match 'pair' or t:match 'property' or t:match 'shorthand' then
        inside_prop = true
      end
      node = node:parent()
    end
    if not (inside_obj and inside_prop) then
      return
    end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
    if line:match '^%s*$' then
      return
    end
    if line:match '%,%s*$' then
      return
    end

    local c1 = line:find('//', 1, true)
    local c2 = line:find('/*', 1, true)
    local comment_pos = nil
    if c1 and c2 then
      comment_pos = math.min(c1, c2)
    elseif c1 or c2 then
      comment_pos = c1 or c2
    end

    local code = line
    local comment = ''
    if comment_pos then
      code = line:sub(1, comment_pos - 1)
      comment = line:sub(comment_pos)
    end
    code = code:gsub('%s*$', '')
    if code == '' or code:match ',$' then
      return
    end

    local new_line = code .. ',' .. comment
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })

    local new_col = math.min(col, #new_line)
    vim.api.nvim_win_set_cursor(0, { row, new_col })
  end,
})
