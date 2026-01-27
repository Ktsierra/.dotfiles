-- Custom TypeScript diagnostic float setup
-- return {
--   {
--     'ktsierra/nvim-ts-errors',
--     ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
--     opts = {
--       keys = {
--         show = '<leader>dd',
--       },
--     },
--   },
-- }

return {
  'OlegGulevskyy/better-ts-errors.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    keymaps = {
      toggle = '<leader>dd', -- default '<leader>dd'
      go_to_definition = '<leader>dx', -- default '<leader>dx'
    },
  },
}
