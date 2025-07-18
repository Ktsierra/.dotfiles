local M = {}

---@param capabilities table
function M.opts(capabilities)
  return {
    capabilities = capabilities,
    settings = {
      -- Enable completion for function calls
      complete_function_calls = true,

      -- All code actions are exposed
      expose_as_code_action = 'all',

      -- Settings for auto-closing JSX tags
      jsx_close_tag = {
        enable = false,
        filetypes = { 'javascriptreact', 'typescriptreact' },
      },

      -- File preferences for tsserver
      tsserver_file_preferences = {
        -- Use single quotes for imports
        quotePreference = 'single',

        -- Complete imports and module exports
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        includeCompletionsWithSnippetText = true,

        -- Use shortest paths for imports
        importModuleSpecifierPreference = 'shortest',
        importModuleSpecifierEnding = 'minimal',

        -- Auto-import from package.json
        includePackageJsonAutoImports = 'auto',

        -- Use braces for JSX attributes
        jsxAttributeCompletionStyle = 'braces',

        -- Inlay hints configuration
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },

      -- Formatting options are handled by conform.nvim/prettierd
      tsserver_format_options = {},
    },
  }
end

return M
