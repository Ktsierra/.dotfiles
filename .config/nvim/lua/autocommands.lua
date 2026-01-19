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
      -- call conform like the <leader>f mapping, but run synchronously so we write the formatted content
      local ok, conform = pcall(require, 'conform')
      if ok and conform and type(conform.format) == 'function' then
        -- synchronous format to ensure buffer is updated before write
        pcall(conform.format, { timeout_ms = 500, lsp_format = 'fallback' })
      end
      -- perform the write so BufWritePre/BufWritePost and any linters run
      vim.cmd.write()
    end
  end,
})
