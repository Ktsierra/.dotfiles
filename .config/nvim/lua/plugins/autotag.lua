return {
  'windwp/nvim-ts-autotag',
  event = 'VeryLazy',
  config = function()
    require('nvim-ts-autotag').setup {
      enable_close_on_slash = true,
    }
  end,
}
