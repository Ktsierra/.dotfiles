---@module "lazy"
---@return LazyPluginSpec[]
return {
  {
    'github/copilot.vim',
    cmd = 'Copilot',
    event = 'BufWinEnter',
    init = function()
      vim.g.copilot_no_maps = true
    end,
    config = function()
      -- Block the normal Copilot suggestions
      -- This setup and the callback is required for
      -- https://github.com/fang2hou/blink-copilot
      vim.api.nvim_create_augroup('github_copilot', { clear = true })
      vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
        group = 'github_copilot',
        callback = function(args)
          vim.fn['copilot#On' .. args.event]()
        end,
      })
      vim.fn['copilot#OnFileType']()
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    event = 'UIEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Copilot authorization
      'github/copilot.vim',
      -- Diff looks
      {
        'echasnovski/mini.diff',
        config = function()
          local diff = require 'mini.diff'
          diff.setup {
            -- Disabled by default
            source = diff.gen_source.none(),

            vim.api.nvim_create_user_command('DiffOff', function()
              -- Disable for all current buffers first
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(buf) then
                  diff.disable(buf)
                end
              end
              diff.config.source = diff.gen_source.none()
              vim.notify 'Mini.diff disabled'
            end, { desc = 'Disable mini.diff' }),
          }
        end,
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown', 'codecompanion' },
      },
    },
    -- config = true,
    cmd = {
      'CodeCompanion',
      'CodeCompanionChat',
      'CodeCompanionCmd',
      'CodeCompanionActions',
    },
    keys = {
      { '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle Chat', mode = { 'n', 'v' } },
      { '<leader>ca', '<cmd>CodeCompanionActions<cr>', desc = 'Prompt Actions', mode = { 'n', 'v' } },
      { '<leader>ct', '<cmd>DiffOff<cr>', desc = 'Turn off diff' },
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
      show_defaults = false,
      adapters = {
        copilot = function()
          -- lua print(vim.inspect(require("codecompanion.adapters").extend("copilot").schema.model.choices()))
          local adapters = require 'codecompanion.adapters'
          return adapters.extend('copilot', {
            schema = {
              model = {
                default = 'claude-sonnet-4',
              },
            },
          })
        end,
      },
      display = {
        diff = {
          provider = 'mini_diff',
        },
        chat = {
          render_headers = true,
          show_settings = true,
          show_token_count = true,
          buf_options = {
            buflisted = false,
          },
          win_options = {
            linebreak = true,
            wrap = true,
          },
        },
      },
    },
  },
}
