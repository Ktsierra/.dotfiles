-- Custom TypeScript diagnostic float setup
-- Uses PrettyTsFormat rplugin for formatting, render-markdown for display
-- The actual float is in lua/util/ts_diagnostic_float.lua
return {
  {
    'enochchau/nvim-pretty-ts-errors',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    build = 'cd ~/.local/share/nvim/lazy/nvim-pretty-ts-errors && pnpm install',
  },
  {
    -- Top-level so it loads independently of codecompanion
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'codecompanion', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = {},
  },
}
