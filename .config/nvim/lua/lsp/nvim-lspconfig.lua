return {
  -- Main LSP configuration
  'neovim/nvim-lspconfig',
  event = { 'UIEnter' },
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'mason-org/mason.nvim', opts = {} },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim', event = 'VimEnter' },
    'b0o/SchemaStore.nvim',
    'saghen/blink.cmp',

    -- Provides a suite of tools for TypeScript development
    {
      'pmizio/typescript-tools.nvim',
      dependencies = { 'nvim-lua/plenary.nvim', 'saghen/blink.cmp' },
      opts = function()
        -- Defer the loading of capabilities until after blink.cmp is loaded
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        return require('lsp.typescript-tools').opts(capabilities)
      end,
    },
  },
  config = function()
    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buf = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Hover with rounded border
        map('K', function()
          vim.lsp.buf.hover { border = 'rounded' }
        end, 'Hover Documentation')

        -- rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>a', vim.lsp.buf.code_action, '[G]oto [C]ode Action', { 'n', 'x' })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      update_in_insert = false,
      float = {
        border = 'rounded',
        source = 'if_many',
        focusable = false,
        scope = 'line',
        close_events = {
          'CursorMoved',
          'CursorMovedI',
          'BufLeave',
          'BufHidden',
          'InsertCharPre',
          'WinLeave',
          'InsertEnter',
          'InsertLeave',
          'LspAttach',
          'LspDetach',
        },
        format = function(diagnostic)
          if diagnostic.source == 'eslint' then
            return nil
          end
          return diagnostic.message
        end,
      },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          if diagnostic.source == 'eslint' then
            return nil
          end
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
      virtual_lines = false,
      jump = {
        on_jump = function(diagnostic)
          vim.diagnostic.open_float()
        end,
      },
    }

    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },

      yamlls = {
        settings = {
          yaml = {
            schemas = require('schemastore').yaml.schemas(),
            validate = true,
            hover = true,
            completion = true,
          },
        },
      },

      tailwindcss = {},
      pyright = {},
      bashls = {},

      eslint = {
        settings = {
          format = false,
          experimental = {
            useFlatConfig = true,
          },
          workingDirectory = { mode = 'auto' },
        },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          client.server_capabilities.publishDiagnostics = false
        end,
      },

      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    -- Map lspconfig names -> mason package names
    -- NOTE: This replaces mason-lspconfig translations
    local mason_name_map = {
      jsonls = 'json-lsp',
      yamlls = 'yaml-language-server',
      tailwindcss = 'tailwindcss-language-server',
      eslint = 'eslint-lsp',
      lua_ls = 'lua-language-server',
      pyright = 'pyright',
      bashls = 'bash-language-server',
    }

    local mason_ensure_installed = {}
    for lsp_name in pairs(servers) do
      table.insert(mason_ensure_installed, mason_name_map[lsp_name] or lsp_name)
    end

    vim.list_extend(mason_ensure_installed, {
      'stylua', -- Used to format Lua code
      'luacheck',
      'markdownlint-cli2',
      'eslint_d',
      'prettierd',
      -- You can add other tools here that you want Mason to install
    })

    require('mason-tool-installer').setup { ensure_installed = mason_ensure_installed, auto_update = true }

    for name, server in pairs(servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
  end,
}
