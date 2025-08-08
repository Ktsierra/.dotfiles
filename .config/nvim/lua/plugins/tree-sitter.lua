return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- branch = 'main',
  -- -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
  -- config = function()
  --   local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  --   require('nvim-treesitter').install(parsers)
  --
  --   vim.api.nvim_create_autocmd('FileType', {
  --     pattern = parsers,
  --     callback = function()
  --       -- enbales syntax highlighting and other treesitter features
  --       vim.treesitter.start()
  --
  --       -- enbales treesitter based folds
  --       -- for more info on folds see `:help folds`
  --       vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  --
  --       -- enables treesitter based indentation
  --       vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  --     end,
  --   })
  -- end,

  -- master branch setup, branch is frozen
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby', 'markdown' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },

  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects(using 'main' branch)
}
