return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup {
      mappings = {
        add = '<leader>za', -- Add surrounding in Normal and Visual modes
        delete = '<leader>zd', -- Delete surrounding
        find = '<leader>zf', -- Find surrounding (to the right)
        find_left = '<leader>zF', -- Find surrounding (to the left)
        highlight = '<leader>zh', -- Highlight surrounding
        replace = '<leader>zr', -- Replace surrounding
        update_n_lines = '<leader>zn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    }

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    require('mini.notify').setup {
      window = {
        winblend = 0,
      },
    }

    local hipatterns = require 'mini.hipatterns'
    hipatterns.setup {
      highlighters = {
        -- -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        -- fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        -- hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        -- todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        -- note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },

      -- Icons for oil.nvim
      require('mini.icons').setup {},
    }
  end,
}
