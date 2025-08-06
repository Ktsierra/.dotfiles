return {
  'eldritch-theme/eldritch.nvim',
  lazy = false,
  priority = 1000,
  -- opts = {},
  config = function()
    require('eldritch').setup {
      transparent = true,
      styles = {
        floats = 'transparent',
        sidebars = 'transparent',
      },
    }

    vim.cmd.colorscheme 'eldritch'
    -- vim.api.nvim_set_hl(0, '@lsp.type.class.typescript', { link = 'Constant' })
    vim.api.nvim_set_hl(0, '@keyword.operator.typescript', { link = '@keyword' })
    -- vim.api.nvim_set_hl(0, 'Type', { link = 'Character' })
    -- vim.api.nvim_set_hl(0, '@lsp.type.interface', { link = 'Character' })
  end,
}
