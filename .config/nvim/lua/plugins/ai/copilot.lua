return {
  {
    -- run :Copilot setup
    'github/copilot.vim',
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('i', '<C-y>', 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.cmd 'Copilot'
      print ''
    end,
  },
}
