return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Virtual text
    'theHamsta/nvim-dap-virtual-text',

    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',

    -- Telescope for nice floating windows
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Sets up virtual text for DAP
    require('nvim-dap-virtual-text').setup {}

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'js-debug-adapter',
        'firefox-debug-adapter',
      },
    }

    -- Add the missing pwa-node adapter (needed for Metro/Node apps)
    require('dap').adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        -- 💀 Make sure to update this path to point to your installation
        args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
      },
    }

    dap.adapters.firefox = {
      type = 'executable',
      command = 'node',
      args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js' },
    }

    -- Add configurations for javascript/typescript files
    dap.configurations.javascript = {
      -- React Native Debugging Workflow (SDK 53)
      --
      -- IMPORTANT: Both React Native DevTools and nvim-dap need source maps, but they expect
      -- different Metro server configurations. Here's the workflow to make both work:
      --
      -- 1. `expo run:ios` - Builds app with Hermes bytecode, generates source maps for DevTools
      -- 2. Kill Metro server (Ctrl+C)
      -- 3. `expo start` - Starts dev server that serves source maps in nvim-dap compatible format
      -- 4. Refresh app in simulator
      -- 5. Launch debugger below to attach
      --
      -- WHY THIS WORKS:
      -- - run:ios creates compiled bundle + source maps (DevTools can read these)
      -- - expo start serves those same maps through dev server (nvim-dap can read these)
      -- - App keeps compiled version but gets debugging from dev server
      -- - Only 1 debugger active at time (RN limitation)
      --
      -- NOTE: nvim-dap might disconnect the first time you run it with DevTools open,
      -- thats just how it works. Devtools will disconnect too, you can safely recconect using
      -- nvim-dap. Make sure to reload your app if this happens.
      --
      -- TL;DR: Need run:ios THEN expo start for both debugging tools to have source maps
      -- Both configs for RN works, the simple is the one used before compiling the app, then use the advanced one
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Debug React Native App (Advanced Setup)',
        port = 8081,
        address = 'localhost',
        localRoot = '${workspaceFolder}',
        remoteRoot = '${workspaceFolder}',
        sourceMaps = true,
        skipFiles = {
          '<node_internals>/**',
          'node_modules/**',
          '**/node_modules/undici/**',
          '**/node_modules/typescript/**',
          '**/node_modules/@expo/**',
          '**/*.bundle.js',
          '**/*.min.js',
        },
        -- Connect via WebSocket protocol used by React Native
        protocol = 'inspector',
        timeout = 30000,
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Debug React Native App (Simple Setup)',
        cwd = '${workspaceFolder}',
        port = 8081,
        sourceMaps = true,
      },
      {
        name = 'Debug Vite React App (Firefox)',
        type = 'firefox',
        request = 'launch',
        reAttach = true,
        url = 'http://localhost:5173',
        webRoot = '${workspaceFolder}/src',
        pathMappings = {
          {
            url = 'http://localhost:5173',
            path = '${workspaceFolder}',
          },
        },
        skipFiles = {
          '<node_internals>/**',
          'node_modules/**',
        },
      },
    }

    dap.configurations.typescript = dap.configurations.javascript
    dap.configurations.typescriptreact = dap.configurations.javascript
    dap.configurations.javascriptreact = dap.configurations.javascript

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {}

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
