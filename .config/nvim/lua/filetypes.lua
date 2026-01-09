-- Filetype mappings for env files
-- Map common .env variants to the dosini filetype for KEY=VALUE highlighting
vim.filetype.add {
  filename = {
    ['.env'] = 'dosini',
    ['.env.example'] = 'dosini',
    ['.env.local'] = 'dosini',
    ['env.local'] = 'dosini',
  },
  pattern = {
    -- matches files like .env.production, .env.test, etc.
    ['^%.env%..*$'] = 'dosini',
    -- matches env.local without leading dot
    ['^env%.local$'] = 'dosini',
  },
}
