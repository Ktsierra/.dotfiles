return {
  -- lazy.nvim
  {
    'folke/snacks.nvim',
    event = 'VeryLazy',
    ---@type snacks.Config
    opts = {
      styles = {
        snacks_image = {
          relative = 'editor',
          col = -1,
        },
      },
      image = {
        doc = {
          inline = false,
        },
      },
      picker = {
        sources = {
          media = {
            finder = 'files',
            ft = {
              'jpg',
              'jpeg',
              'png',
              'gif',
              'bmp',
              'webp', -- Images
              'mp4',
              'mov',
              'avi',
              'mkv',
              'webm', -- Videos
              'mp3',
              'wav',
              'ogg',
              'flac', -- Audio
            },
            prompt_title = 'Media Files',
          },
        },
      },
    },
    keys = {
      {
        '<leader>sm',
        function()
          Snacks.picker.pick 'media'
        end,
        desc = '[S]nacks [M]edia picker',
      },
    },
  },
}
