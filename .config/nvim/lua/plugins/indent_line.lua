return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    main = 'ibl',
    opts = {
      exclude = {
        filetypes = { 'dashboard' },
      },
    },
  },
}
