return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Harpoon: Add file' })

      vim.keymap.set('n', '<leader>hc', function()
        harpoon:list():clear()
      end, { desc = 'Harpoon: Clear List' })

      vim.keymap.set('n', '<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon: Toggle menu' })

      vim.keymap.set('n', '<leader>hp', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon: Prev Buffer' })

      vim.keymap.set('n', '<leader>hn', function()
        harpoon:list():next()
      end, { desc = 'Harpoon: Next Buffer' })

      -- Set <space>1..<space>5 be my shortcuts to moving to the files
      for _, idx in ipairs { 1, 2, 3, 4, 5 } do
        local desc
        local item = harpoon:list():get(idx)
        if item and item.value then
          desc = 'Harpoon: ' .. vim.fn.fnamemodify(item.value, ':t')
        else
          desc = 'Harpoon: empty slot ' .. idx
        end
        vim.keymap.set('n', string.format('<leader>%d', idx), function()
          harpoon:list():select(idx)
        end, { desc = desc })
      end

      -- Interactively remove an item from the list with a custom floating menu
      vim.keymap.set('n', '<leader>hd', function()
        require('util.harpoon_menu').delete_menu()
      end, { desc = 'Harpoon: [D]elete from list' })

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
      end, { desc = '[H]arpoon [T]elescope window' })
    end,
  },
}
