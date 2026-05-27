return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePost' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_after_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      markdown = { 'markdownlint-cli2' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      kotlin = { 'ktlint' },
    },
  },
}
