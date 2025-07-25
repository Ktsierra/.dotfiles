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
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

vim.api.nvim_create_autocmd('BufLeave', {
  desc = 'Auto-save when leaving a modified buffer',
  group = vim.api.nvim_create_augroup('auto-save-on-buf-leave', { clear = true }),
  pattern = '*',
  callback = function()
    if vim.bo.modified and vim.bo.buftype == '' then
      vim.cmd.write()
    end
  end,
})
