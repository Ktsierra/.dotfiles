return {
  {
    'ThePrimeagen/harpoon',
    event = 'VeryLazy',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      local harpoon_utils = require 'util.harpoon_utils'

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
        harpoon_utils.update_harpoon_keymaps()
      end, { desc = '[H]arpoon: [A]dd file' })

      vim.keymap.set('n', '<leader>hc', function()
        harpoon:list():clear()
        harpoon_utils.update_harpoon_keymaps()
      end, { desc = '[H]arpoon: [C]lear List' })

      vim.keymap.set('n', '<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = '[H]arpoon: [H]arpoon menu' })

      vim.keymap.set('n', '<leader>hp', function()
        harpoon:list():prev()
      end, { desc = '[H]arpoon: [P]rev Buffer' })

      vim.keymap.set('n', '<leader>hn', function()
        harpoon:list():next()
      end, { desc = '[H]arpoon: [N]ext Buffer' })

      -- Call on startup
      harpoon_utils.update_harpoon_keymaps()

      -- Interactively remove an item from the list with a custom floating menu
      vim.keymap.set('n', '<leader>hd', function()
        require('util.harpoon_menu').delete_menu()
      end, { desc = '[H]arpoon: [D]elete from list' })

      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>ht', function()
        toggle_telescope(harpoon:list())
      end, { desc = '[H]arpoon: [T]elescope window' })
    end,
  },
}
