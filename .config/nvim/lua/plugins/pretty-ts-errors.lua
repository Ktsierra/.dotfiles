-- Custom TypeScript diagnostic float setup
-- Uses PrettyTsFormat rplugin for formatting, render-markdown for display
-- The actual float is in lua/util/ts_diagnostic_float.lua
return {
  {
    'ktsierra/nvim-ts-errors',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = {
      keys = {
        show = '<leader>dd',
      },
    },
  },
}
