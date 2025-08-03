return {
  {
    -- run :Copilot setup
    'github/copilot.vim',
    event = 'UIEnter',
    config = function()
      -- vim.cmd 'Copilot'
      vim.keymap.set('i', '<C-y>', 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    event = 'UIEnter',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken',
    opts = {
      -- See Configuration section for options
    },
    keys = {
      { '<leader>ca', '<CMD>CopilotChat<CR>', mode = { 'n', 'v' }, desc = 'Open [C]opilot Ch[A]t' },
      { '<leader>ce', '<CMD>CopilotChatExplain<CR>', mode = 'v', desc = '[C]opilot [E]xplain selection' },
      { '<leader>cw', '<CMD>CopilotChatReview<CR>', mode = 'v', desc = '[C]opilot Revie[W] selection' },
      { '<leader>cf', '<CMD>CopilotChatFix<CR>', mode = 'v', desc = '[C]opilot [F]ix selection' },
      { '<leader>co', '<CMD>CopilotChatOptimize<CR>', mode = 'v', desc = '[C]opilot [O]ptimize selection' },
      { '<leader>cd', '<CMD>CopilotChatDocs<CR>', mode = 'v', desc = '[C]opilot [D]ocs for selection' },
      { '<leader>ct', '<CMD>CopilotChatTests<CR>', mode = 'v', desc = '[C]opilot [T]ests for selection' },
      -- { '<leader>cr', '<CMD>CopilotChatRefactor<CR>', mode = 'v', desc = '[C]opilot [R]efactor selection' },
      { '<leader>cm', '<CMD>CopilotChatCommit<CR>', mode = 'v', desc = '[C]opilot [C]ommit for selection' },
      { '<leader>cm', '<CMD>CopilotChatCommit<CR>', mode = 'n', desc = '[C]opilot [C]ommit Message' },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
