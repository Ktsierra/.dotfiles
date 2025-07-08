return {
  'eldritch-theme/eldritch.nvim',
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('eldritch').setup {
      transparent = true,
      styles = {
        floats = 'transparent',
        sidebars = 'transparent',
      },
    }

    vim.cmd.colorscheme 'eldritch'
  end,
}
